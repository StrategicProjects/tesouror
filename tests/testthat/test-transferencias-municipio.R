# Municipal Transferencias endpoints: lower-case parameter names, singular
# p_municipio, and pagination (page/pageSize) — the server contract since 2026-09.

page_response <- function(rows) {
  httr2::response_json(status_code = 200L, body = list(
    `next` = "https://apiapex.tesouro.gov.br/aria/v1/x?page=99",
    pageSize = 2L, registros = rows, page = 1L, status = "ok"
  ))
}

reg <- function(mun, valor, transf = "FPM") {
  list(UF = "PE", ANO = "2024", TRANSFERENCIA = transf, codigo_siafi = 2531L,
       CO_IBGE = mun, MES = "01", MUNICIPIO = "Recife", VALOR = valor)
}

test_that("get_tc_por_municipio sends lower-case names, singular p_municipio and pageSize", {
  skip_if_no_httptest2()
  local_fast_retry()
  rec <- capture_url(function() page_response(list()))

  httr2::with_mocked_responses(
    rec$mock,
    suppressMessages(get_tc_por_municipio(p_estado = 16, p_municipio = c(2531, 2600054),
                                          p_ano = 2024, p_mes = 1, p_transferencia = 3,
                                          page_size = 500, use_cache = FALSE))
  )
  url <- rec$urls()[1]
  expect_match(url, "/transferencias_constitucionais/custom/por_estado_municipio")
  expect_match(url, "p_estado=16")
  expect_match(url, "p_municipio=2531(:|%3A)2600054")
  expect_match(url, "p_ano=2024")
  expect_match(url, "p_mes=1")
  expect_match(url, "p_transferencia=3")
  expect_match(url, "page=1")
  expect_match(url, "pageSize=500")
  expect_false(grepl("P_ESTADO|P_MUNICIPIOS", url))
})

test_that("pagination stacks pages and stops on a short page", {
  skip_if_no_httptest2()
  local_fast_retry()
  calls <- 0L
  mock <- function(req) {
    calls <<- calls + 1L
    page <- as.integer(sub(".*[?&]page=(\\d+).*", "\\1", req$url))
    if (page == 1L) page_response(list(reg(2611606L, 10), reg(2600054L, 20)))
    else if (page == 2L) page_response(list(reg(2600104L, 30)))
    else page_response(list())
  }
  x <- httr2::with_mocked_responses(
    mock,
    suppressMessages(get_tc_by_municipality(state_code = 16, year = 2024, month = 1,
                                            page_size = 2, use_cache = FALSE))
  )
  expect_s3_class(x, "tbl_df")
  expect_equal(nrow(x), 3L)
  expect_equal(calls, 2L)              # page 2 was short, so no page 3
  expect_true(all(c("uf", "ano", "transferencia", "co_ibge", "valor") %in% names(x)))
  expect_equal(x$valor, c(10, 20, 30))
  expect_null(attr(x, "partial"))
})

test_that("pagination requests the next page when a page is full and stops on empty", {
  skip_if_no_httptest2()
  local_fast_retry()
  calls <- 0L
  mock <- function(req) {
    calls <<- calls + 1L
    page <- as.integer(sub(".*[?&]page=(\\d+).*", "\\1", req$url))
    if (page <= 2L) page_response(list(reg(1L, 1), reg(2L, 2))) else page_response(list())
  }
  x <- httr2::with_mocked_responses(
    mock,
    suppressMessages(get_tc_por_municipio(p_estado = 16, page_size = 2, use_cache = FALSE))
  )
  expect_equal(nrow(x), 4L)
  expect_equal(calls, 3L)
})

test_that("max_rows stops early", {
  skip_if_no_httptest2()
  local_fast_retry()
  mock <- function(req) page_response(list(reg(1L, 1), reg(2L, 2)))
  x <- httr2::with_mocked_responses(
    mock,
    suppressMessages(get_tc_por_municipio(p_estado = 16, page_size = 2, max_rows = 3, use_cache = FALSE))
  )
  expect_equal(nrow(x), 3L)
})

test_that("a failure after the first page returns a partial result", {
  skip_if_no_httptest2()
  local_fast_retry()
  mock <- function(req) {
    page <- as.integer(sub(".*[?&]page=(\\d+).*", "\\1", req$url))
    if (page == 1L) page_response(list(reg(1L, 1), reg(2L, 2))) else mock_error_response(504L)
  }
  x <- httr2::with_mocked_responses(
    mock,
    suppressMessages(get_tc_por_municipio(p_estado = 16, page_size = 2, use_cache = FALSE))
  )
  expect_equal(nrow(x), 2L)
  expect_true(isTRUE(attr(x, "partial")))
  expect_type(attr(x, "last_page_error"), "character")
})

test_that("an empty first page returns an empty tibble", {
  skip_if_no_httptest2()
  local_fast_retry()
  x <- httr2::with_mocked_responses(
    function(req) page_response(list()),
    suppressMessages(get_tc_por_municipio(p_estado = 16, p_ano = 1990, use_cache = FALSE))
  )
  expect_equal(nrow(x), 0L)
})

test_that("the _detalhe endpoint keeps upper-case names and plural P_MUNICIPIOS, unpaginated", {
  skip_if_no_httptest2()
  local_fast_retry()
  rec <- capture_url(function() mock_json_response(body = list(registros = list(
    list(AN_DISTRIBUICAO = "2024", TOTAL = 1, CO_SIAFI = 2531L, VA_PRIMEIRO_DEC = 1,
         NO_MUNICIPIO = "Recife", VA_TERCEIRO_DEC = 0, CO_IBGE = 2611606L,
         ME_DISTRIBUICAO = "01", SG_DETALHE = "FPM", SG_UF = "PE", VA_SEGUNDO_DEC = 0)
  ), status = "ok")))
  x <- httr2::with_mocked_responses(
    rec$mock,
    suppressMessages(get_tc_by_municipality_detail(state_code = 16, municipality = c(2531, 2631),
                                                   year = 2024, month = 1, transfer_type = 3,
                                                   use_cache = FALSE))
  )
  url <- rec$urls()[1]
  expect_match(url, "/por_estado_municipio_detalhe")
  expect_match(url, "P_ESTADO=16")
  expect_match(url, "P_MUNICIPIOS=2531(:|%3A)2631")
  expect_match(url, "P_ANO=2024")
  expect_match(url, "P_TRANSFERENCIA=3")
  expect_false(grepl("page=|pageSize=", url))
  expect_equal(length(rec$urls()), 1L)
  expect_true(all(c("sg_detalhe", "va_primeiro_dec", "total") %in% names(x)))
})
