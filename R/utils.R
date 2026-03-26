# Internal utilities for tesouror
# These functions are not exported

# -- Parameter validation ------------------------------------------------------

#' Check that required arguments were supplied via missing()
#' @noRd
check_required <- function(...) {
  args <- as.character(match.call())[-1]
  env <- parent.frame()
  missing_args <- character()
  na_args <- character()

  for (arg in args) {
    tryCatch(
      {
        val <- eval(call("missing", as.symbol(arg)), envir = env)
        if (isTRUE(val)) {
          missing_args <- c(missing_args, arg)
        } else {
          arg_val <- get(arg, envir = env)
          if (length(arg_val) == 1 && is.na(arg_val)) {
            na_args <- c(na_args, arg)
          }
        }
      },
      error = function(e) {
        missing_args <<- c(missing_args, arg)
      }
    )
  }

  if (length(missing_args) > 0) {
    cli::cli_abort(
      "Missing required argument{?s}: {.arg {missing_args}}."
    )
  }
  if (length(na_args) > 0) {
    cli::cli_abort(
      "Required argument{?s} {.arg {na_args}} cannot be NA."
    )
  }
  invisible(NULL)
}

# -- Null coalescing -----------------------------------------------------------

#' Null-coalescing operator (from rlang)
#' @noRd
`%||%` <- function(x, y) if (is.null(x)) y else x

# -- Parameter collapsing ------------------------------------------------------

#' Collapse a vector into a colon-separated string
#' @noRd
collapse_param <- function(x) {
  if (is.null(x)) return(NULL)
  paste(x, collapse = ":")
}

# -- Verbose helper ------------------------------------------------------------

#' Check if verbose mode is enabled
#' @noRd
is_verbose <- function(verbose) {
  isTRUE(verbose) || isTRUE(getOption("tesouror.verbose", FALSE))
}

#' Build the full URL with query params for display
#' @noRd
build_display_url <- function(url, params) {
  params <- Filter(Negate(is.null), params)
  if (length(params) == 0) return(url)
  query <- paste0(
    names(params), "=", vapply(params, as.character, character(1)),
    collapse = "&"
  )
  paste0(url, "?", query)
}

# -- Base URLs -----------------------------------------------------------------

#' @noRd
siconfi_base_url <- function() {
  "https://apidatalake.tesouro.gov.br/ords/siconfi/tt"
}

#' @noRd
custos_base_url <- function() {
  "https://apidatalake.tesouro.gov.br/ords/custos/tt"
}

#' @noRd
sadipem_base_url <- function() {
  "https://apidatalake.tesouro.gov.br/ords/sadipem/tt/"
}

#' @noRd
transferencias_base_url <- function() {
  "https://apiapex.tesouro.gov.br/aria/v1/transferencias_constitucionais/custom"
}

#' Base URL for the SIOPE API (OData)
#' @noRd
siope_base_url <- function() {
  "https://www.fnde.gov.br/olinda-ide/servico/DADOS_ABERTOS_SIOPE/versao/v1/odata"
}

# -- In-memory cache -----------------------------------------------------------

the_cache <- new.env(parent = emptyenv())

cache_key <- function(url, params) {
  parts <- c(url, sort(paste0(names(params), "=", params)))
  paste(parts, collapse = "|")
}

cache_get <- function(key) {
  if (exists(key, envir = the_cache)) {
    return(get(key, envir = the_cache))
  }
  NULL
}

cache_set <- function(key, value) {
  assign(key, value, envir = the_cache)
  invisible(value)
}

#' Clear the tesouror in-memory cache
#'
#' Removes **all** cached API responses stored during the current R session.
#' This applies to every API covered by the package: SICONFI, CUSTOS, SADIPEM,
#' and Transferencias Constitucionais. All cached responses share the same
#' in-memory store and are cleared together.
#'
#' @return Invisible `NULL`.
#' @export
#' @examples
#' tesouror_clear_cache()
tesouror_clear_cache <- function() {
  rm(list = ls(envir = the_cache), envir = the_cache)
  cli::cli_alert_info("Cache cleared (all APIs).")
  invisible(NULL)
}

# -- Request builder -----------------------------------------------------------

max_retries <- 5L
retry_wait <- 3L

#' Build and perform a single request to a Treasury API
#' @noRd
tnr_request <- function(url, params = list(), use_cache = TRUE,
                        api_name = "Treasury",
                        accept = "application/json",
                        verbose = FALSE) {
  params <- Filter(Negate(is.null), params)

  # Verbose: show full URL
  if (is_verbose(verbose)) {
    full_url <- build_display_url(url, params)
    cli::cli_alert_info("API call: {.url {full_url}}")
  }

  # Check cache
  if (use_cache) {
    key <- cache_key(url, params)
    cached <- cache_get(key)
    if (!is.null(cached)) return(cached)
  }

  req <- httr2::request(url) |>
    httr2::req_url_query(!!!params) |>
    httr2::req_headers(Accept = accept) |>
    httr2::req_error(is_error = function(resp) FALSE)

  # Retry loop — covers both connection failures AND retryable HTTP errors
  # (5xx server errors, 429 rate limiting)
  resp <- NULL
  last_error <- NULL
  last_status <- NULL

  for (attempt in seq_len(max_retries)) {
    last_error <- NULL
    last_status <- NULL

    resp <- tryCatch(
      httr2::req_perform(req),
      error = function(e) { last_error <<- e; NULL }
    )

    if (!is.null(resp)) {
      last_status <- httr2::resp_status(resp)
      # Success — break out
      if (last_status == 200L) break
      # Retryable server errors (504 timeout, 502 bad gateway, 503 unavailable, 429 rate limit)
      if (last_status %in% c(429L, 500L, 502L, 503L, 504L)) {
        if (attempt < max_retries) {
          wait <- retry_wait * attempt
          cli::cli_alert_warning(
            "HTTP {last_status} on attempt {attempt}/{max_retries}. Retrying in {wait}s..."
          )
          Sys.sleep(wait)
          resp <- NULL  # reset so we retry
          next
        }
        # Last attempt also failed with retryable status — fall through to error below
      } else {
        # Non-retryable HTTP error (400, 404, etc.) — break and report
        break
      }
    } else {
      # Connection failure
      if (attempt < max_retries) {
        wait <- retry_wait * attempt
        cli::cli_alert_warning(
          "Connection failed (attempt {attempt}/{max_retries}). Retrying in {wait}s..."
        )
        Sys.sleep(wait)
      }
    }
  }

  # All retries exhausted — connection failure
  if (is.null(resp)) {
    err_msg <- if (!is.null(last_error)) conditionMessage(last_error) else "Unknown error"
    hint <- if (grepl("HTTP/2|stream|PROTOCOL_ERROR", err_msg)) {
      "The server closed the connection unexpectedly (HTTP/2 protocol error)."
    } else if (grepl("resolve|DNS|getaddrinfo", err_msg, ignore.case = TRUE)) {
      "Could not resolve the API hostname. Check your internet connection."
    } else if (grepl("timed? ?out|timeout", err_msg, ignore.case = TRUE)) {
      "The request timed out. The API may be temporarily unavailable."
    } else if (grepl("connection refused|connrefused", err_msg, ignore.case = TRUE)) {
      "Connection refused by the server."
    } else if (grepl("SSL|certificate|TLS", err_msg, ignore.case = TRUE)) {
      "SSL/TLS error. There may be a network or certificate issue."
    } else {
      NULL
    }
    bullets <- c(
      "x" = "Failed to connect to the {api_name} API after {max_retries} attempts.",
      "i" = "URL: {.url {url}}",
      if (!is.null(hint)) c("!" = hint),
      "i" = "Original error: {err_msg}",
      "i" = "Try again later or check your internet connection."
    )
    cli::cli_abort(bullets, call = NULL)
  }

  # Check HTTP status (for non-retryable errors, or retryable ones that exhausted retries)
  status <- httr2::resp_status(resp)
  if (status != 200L) {
    # Try to extract error details from response body
    error_detail <- tryCatch({
      err_body <- httr2::resp_body_json(resp, simplifyVector = TRUE)
      msg <- err_body[["error"]][["message"]] %||%
             err_body[["message"]] %||%
             err_body[["error"]] %||% NULL
      if (is.character(msg)) msg else NULL
    }, error = function(e) NULL)

    retry_note <- if (attempt > 1L) {
      " (after {attempt} attempts)"
    } else {
      ""
    }

    hint <- if (status == 400L) {
      paste0(
        "Bad request. ",
        if (!is.null(error_detail)) {
          paste0("Server message: ", error_detail)
        } else {
          paste0(
            "If using filter, select, or orderby: check that column ",
            "names match the original API names (uppercase). ",
            "Use verbose = TRUE with max_rows = 1 to inspect valid column names."
          )
        }
      )
    } else if (status == 404L) {
      "The endpoint or entity was not found. Check your parameters."
    } else if (status %in% c(502L, 503L, 504L)) {
      "Server timeout. Try a smaller page_size or retry later."
    } else if (status >= 500L) {
      "Server error. The API may be temporarily unavailable."
    } else if (status == 429L) {
      "Rate limited. Wait a moment before retrying."
    } else {
      "Check your parameters and try again."
    }

    cli::cli_abort(c(
      "x" = paste0("{api_name} API returned HTTP status {.val {status}}", retry_note, "."),
      "i" = "URL: {.url {build_display_url(url, params)}}",
      "i" = hint
    ), call = NULL)
  }

  # Parse JSON
  body <- tryCatch(
    httr2::resp_body_json(resp, simplifyVector = TRUE),
    error = function(e) {
      cli::cli_abort(c(
        "x" = "Failed to parse the API response as JSON.",
        "i" = "URL: {.url {url}}",
        "i" = "Original error: {conditionMessage(e)}"
      ), call = NULL)
    }
  )

  if (use_cache) cache_set(key, body)
  body
}

# -- Pagination (ORDS-style) --------------------------------------------------

#' @noRd
ords_fetch_all <- function(base_url, endpoint, params = list(),
                           use_cache = TRUE, api_name = "Treasury",
                           verbose = FALSE, page_size = NULL,
                           max_rows = Inf) {
  all_items <- list()
  page <- 1L
  total_rows <- 0L
  url <- paste0(base_url, endpoint)

  # Always send limit to control page size.
  # Each API wrapper sets a safe default; user can override.
  if (!is.null(page_size)) {
    params[["limit"]] <- as.integer(page_size)
  }

  # If max_rows is smaller than limit, no point fetching more per page
  if (is.finite(max_rows) && !is.null(params[["limit"]])) {
    params[["limit"]] <- min(params[["limit"]], as.integer(max_rows))
  } else if (is.finite(max_rows) && is.null(params[["limit"]])) {
    params[["limit"]] <- as.integer(max_rows)
  }

  # -- First page --------------------------------------------------------------
  cli::cli_alert("Fetching {.field {api_name}{endpoint}} page {.val {1L}}...")
  body <- tnr_request(url, params, use_cache = use_cache,
                      api_name = api_name, verbose = verbose)
  items <- body[["items"]]

  if (is.null(items) || length(items) == 0) {
    cli::cli_alert_warning(
      "No data returned for {.field {api_name}{endpoint}}."
    )
    return(tibble::tibble())
  }

  all_items[[page]] <- items
  total_rows <- total_rows + NROW(items)
  has_more <- isTRUE(body[["hasMore"]])

  cli::cli_alert_success(
    "{.field {api_name}{endpoint}} | page {.val {page}} | {.val {total_rows}} rows"
  )

  # -- Subsequent pages --------------------------------------------------------
  while (has_more && total_rows < max_rows) {
    page <- page + 1L

    offset <- body[["offset"]]
    limit  <- body[["limit"]]
    if (is.null(offset) || is.null(limit)) break

    next_offset <- offset + limit
    next_params <- c(params, list(offset = next_offset))

    cli::cli_alert("Fetching {.field {api_name}{endpoint}} page {.val {page}}...")
    body <- tnr_request(url, next_params, use_cache = use_cache,
                        api_name = api_name, verbose = verbose)
    items <- body[["items"]]

    if (is.null(items) || length(items) == 0) break

    all_items[[page]] <- items
    total_rows <- total_rows + NROW(items)
    has_more <- isTRUE(body[["hasMore"]])

    cli::cli_alert_success(
      "{.field {api_name}{endpoint}} | page {.val {page}} | {.val {total_rows}} rows"
    )
  }

  # -- Assemble result ---------------------------------------------------------
  result <- tryCatch(
    dplyr::bind_rows(lapply(all_items, tibble::as_tibble)),
    error = function(e) {
      cli::cli_abort(c(
        "x" = "Failed to parse the {api_name} API response into a tibble.",
        "i" = "Endpoint: {.field {endpoint}}",
        "i" = "Original error: {conditionMessage(e)}"
      ), call = NULL)
    }
  )

  result <- tryCatch(
    dplyr::mutate(result, dplyr::across(dplyr::where(is.character), stringr::str_squish)),
    error = function(e) result
  )

  result <- janitor::clean_names(result)

  # Truncate to max_rows if needed
  if (is.finite(max_rows) && nrow(result) > max_rows) {
    result <- result[seq_len(max_rows), ]
    cli::cli_alert_success(
      "Done: {.val {nrow(result)}} rows (truncated to max_rows)."
    )
  } else {
    cli::cli_alert_success(
      "Done: {.val {nrow(result)}} rows total ({.val {page}} page{?s})."
    )
  }

  result
}

# -- Convenience wrappers per API ----------------------------------------------
# Each wrapper sets a safe default page_size for its API.
# SICONFI/SADIPEM: NULL (server default = 5000, fast).
# CUSTOS: 1000 (server default = 250 is too slow; 5000 causes HTTP 504).

#' @noRd
siconfi_fetch_all <- function(endpoint, params = list(), use_cache = TRUE,
                              verbose = FALSE, page_size = NULL,
                              max_rows = Inf) {
  ords_fetch_all(siconfi_base_url(), endpoint, params,
                 use_cache = use_cache, api_name = "SICONFI",
                 verbose = verbose, page_size = page_size,
                 max_rows = max_rows)
}

#' @noRd
custos_fetch_all <- function(endpoint, params = list(), use_cache = TRUE,
                             verbose = FALSE, page_size = 1000L,
                             max_rows = Inf) {
  ords_fetch_all(custos_base_url(), endpoint, params,
                 use_cache = use_cache, api_name = "CUSTOS",
                 verbose = verbose, page_size = page_size,
                 max_rows = max_rows)
}

#' @noRd
sadipem_fetch_all <- function(endpoint, params = list(), use_cache = TRUE,
                              verbose = FALSE, page_size = NULL,
                              max_rows = Inf) {
  ords_fetch_all(sadipem_base_url(), endpoint, params,
                 use_cache = use_cache, api_name = "SADIPEM",
                 verbose = verbose, page_size = page_size,
                 max_rows = max_rows)
}

# -- Transferencias fetch ------------------------------------------------------

#' @noRd
transferencias_fetch <- function(endpoint, params = list(),
                                 use_cache = TRUE, verbose = FALSE) {
  url <- paste0(transferencias_base_url(), endpoint)

  cli::cli_alert_info("Fetching {.field Transferencias{endpoint}}...")

  body <- tnr_request(url, params, use_cache = use_cache,
                      api_name = "Transferencias", accept = "*/*",
                      verbose = verbose)

  items <- if (is.data.frame(body)) {
    body
  } else if (!is.null(body[["registros"]])) {
    body[["registros"]]
  } else if (!is.null(body[["items"]])) {
    body[["items"]]
  } else {
    body
  }

  if (is.null(items) || length(items) == 0) {
    cli::cli_alert_warning(
      "No data returned for {.field Transferencias{endpoint}}."
    )
    return(tibble::tibble())
  }

  result <- tryCatch(
    tibble::as_tibble(items),
    error = function(e) {
      cli::cli_abort(c(
        "x" = "Failed to parse the Transferencias API response into a tibble.",
        "i" = "Endpoint: {.field {endpoint}}",
        "i" = "Original error: {conditionMessage(e)}"
      ), call = NULL)
    }
  )

  result <- tryCatch(
    dplyr::mutate(result, dplyr::across(dplyr::where(is.character), stringr::str_squish)),
    error = function(e) result
  )

  result <- janitor::clean_names(result)

  cli::cli_alert_success("Done: {.val {nrow(result)}} rows.")

  result
}

# -- SIOPE fetch (OData-style) ------------------------------------------------

#' Build an OData URL for the SIOPE API
#'
#' The SIOPE API uses an OData-style URL pattern:
#' `Resource(Param1=@Param1,Param2=@Param2)?@Param1=value&$format=json`
#'
#' @param resource Character. Resource name (e.g., "Dados_Gerais_Siope").
#' @param params Named list of query parameters.
#' @return Character. Full URL.
#' @noRd
siope_build_url <- function(resource, params) {
  # Build the segment: Resource(P1=@P1,P2=@P2)
  aliases <- paste0(names(params), "=@", names(params), collapse = ",")
  segment <- paste0(resource, "(", aliases, ")")

  # Build query string with @ prefixed aliases
  query_params <- stats::setNames(
    lapply(params, function(v) {
      if (is.character(v)) paste0("'", v, "'") else v
    }),
    paste0("@", names(params))
  )
  query_params[["$format"]] <- "json"

  url <- paste0(siope_base_url(), "/", segment)
  list(url = url, query = query_params)
}

#' Fetch data from the SIOPE API (FNDE/Olinda OData)
#'
#' @param resource Character. OData resource name.
#' @param params Named list of required parameters.
#' @param use_cache Logical.
#' @param verbose Logical.
#' @param max_rows Numeric.
#'
#' @return A tibble.
#' @noRd
siope_fetch <- function(resource, params = list(), use_cache = TRUE,
                        verbose = FALSE, page_size = 1000L,
                        max_rows = Inf, filter = NULL,
                        orderby = NULL, select = NULL) {
  built <- siope_build_url(resource, params)
  url <- built$url
  query <- built$query

  # OData query options
  if (!is.null(filter))  query[["$filter"]]  <- filter
  if (!is.null(orderby)) query[["$orderby"]] <- orderby
  if (!is.null(select))  query[["$select"]]  <- paste(select, collapse = ",")

  all_items <- list()
  page <- 1L
  total_rows <- 0L
  effective_top <- as.integer(page_size)

  # Cap page size at max_rows if smaller

  if (is.finite(max_rows) && max_rows < effective_top) {
    effective_top <- as.integer(max_rows)
  }

  query[["$top"]] <- effective_top

  # Helper: show URL in verbose mode
  show_url <- function() {
    if (is_verbose(verbose)) {
      display_q <- paste0(names(query), "=", query, collapse = "&")
      cli::cli_alert_info("API call: {.url {paste0(url, '?', display_q)}}")
    }
  }

  # -- First page --------------------------------------------------------------
  cli::cli_alert("Fetching {.field SIOPE/{resource}} page {.val {page}}...")
  show_url()

  body <- tnr_request(url, query, use_cache = use_cache,
                      api_name = "SIOPE")

  items <- body[["value"]]

  if (is.null(items) || length(items) == 0) {
    cli::cli_alert_warning("No data returned for {.field SIOPE/{resource}}.")
    return(tibble::tibble())
  }

  page_tbl <- siope_items_to_tibble(items, resource)
  all_items[[page]] <- page_tbl
  total_rows <- total_rows + nrow(page_tbl)

  cli::cli_alert_success(
    "{.field SIOPE/{resource}} | page {.val {page}} | {.val {total_rows}} rows"
  )

  # -- Subsequent pages --------------------------------------------------------
  # OData: if we got exactly $top rows, there might be more
  while (nrow(page_tbl) >= effective_top && total_rows < max_rows) {
    page <- page + 1L
    query[["$skip"]] <- total_rows

    # Adjust $top for last page
    if (is.finite(max_rows)) {
      remaining <- as.integer(max_rows - total_rows)
      query[["$top"]] <- min(effective_top, remaining)
    }

    cli::cli_alert("Fetching {.field SIOPE/{resource}} page {.val {page}}...")
    show_url()

    body <- tnr_request(url, query, use_cache = use_cache,
                        api_name = "SIOPE")
    items <- body[["value"]]

    if (is.null(items) || length(items) == 0) break

    page_tbl <- siope_items_to_tibble(items, resource)
    all_items[[page]] <- page_tbl
    total_rows <- total_rows + nrow(page_tbl)

    cli::cli_alert_success(
      "{.field SIOPE/{resource}} | page {.val {page}} | {.val {total_rows}} rows"
    )
  }

  # -- Assemble result ---------------------------------------------------------
  result <- tryCatch(
    dplyr::bind_rows(all_items),
    error = function(e) {
      cli::cli_abort(c(
        "x" = "Failed to assemble SIOPE pages into a tibble.",
        "i" = "Resource: {.field {resource}}",
        "i" = "Original error: {conditionMessage(e)}"
      ), call = NULL)
    }
  )

  result <- tryCatch(
    dplyr::mutate(result, dplyr::across(dplyr::where(is.character), stringr::str_squish)),
    error = function(e) result
  )

  result <- janitor::clean_names(result)

  # Final truncation
  if (is.finite(max_rows) && nrow(result) > max_rows) {
    result <- result[seq_len(max_rows), ]
    cli::cli_alert_success(
      "Done: {.val {nrow(result)}} rows (truncated to max_rows)."
    )
  } else {
    cli::cli_alert_success(
      "Done: {.val {nrow(result)}} rows total ({.val {page}} page{?s})."
    )
  }

  result
}

#' Parse OData items into a tibble with safe type handling
#'
#' OData responses often have mixed types across rows (NULL vs integer vs
#' character for the same field). This helper coerces everything to character
#' first, then converts numeric-looking columns back to numeric.
#'
#' @param items List or data.frame from OData `value`.
#' @param resource Character. Resource name (for error messages).
#' @return A tibble.
#' @noRd
siope_items_to_tibble <- function(items, resource) {
  tbl <- tryCatch({
    if (is.data.frame(items)) {
      tibble::as_tibble(items)
    } else {
      rows <- lapply(items, function(row) {
        lapply(row, function(v) if (is.null(v)) NA_character_ else as.character(v))
      })
      dplyr::bind_rows(lapply(rows, tibble::as_tibble))
    }
  }, error = function(e) {
    cli::cli_abort(c(
      "x" = "Failed to parse SIOPE response into a tibble.",
      "i" = "Resource: {.field {resource}}",
      "i" = "Original error: {conditionMessage(e)}"
    ), call = NULL)
  })

  # Convert numeric-looking character columns back to numeric
  tryCatch(
    dplyr::mutate(tbl, dplyr::across(
      dplyr::where(function(x) {
        is.character(x) && all(grepl("^-?[0-9]+(\\.[0-9]+)?$", x) | is.na(x))
      }),
      as.numeric
    )),
    error = function(e) tbl
  )
}
