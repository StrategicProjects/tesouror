# Tests for the deprecated SICONFI name shims (issue #1).
# The old names must still work, emit a deprecation warning, and forward to
# their renamed replacements.

test_that("get_dca warns as deprecated and forwards to get_dca_ufs", {
  skip_if_no_httptest2()
  local_fast_retry()
  rec <- capture_url()

  expect_warning(
    httr2::with_mocked_responses(
      rec$mock,
      suppressMessages(get_dca(an_exercicio = 2022, id_ente = 17,
                               use_cache = FALSE))
    ),
    "deprecated"
  )
  expect_match(rec$urls()[1], "/ords/siconfi/tt/dca")
})

test_that("get_rreo warns as deprecated and still builds the rreo URL", {
  skip_if_no_httptest2()
  local_fast_retry()
  rec <- capture_url()

  expect_warning(
    httr2::with_mocked_responses(
      rec$mock,
      suppressMessages(get_rreo(
        an_exercicio = 2022, nr_periodo = 6,
        co_tipo_demonstrativo = "RREO", no_anexo = "RREO-Anexo 01",
        co_esfera = "E", id_ente = 17, use_cache = FALSE
      ))
    ),
    "deprecated"
  )
  expect_match(rec$urls()[1], "/ords/siconfi/tt/rreo")
})

test_that("all renamed replacements are exported and callable", {
  new_names <- c(
    "get_dca_ufs", "get_annual_accounts_ufs",
    "get_dca_municipios", "get_annual_accounts_municipalities",
    "get_rreo_ufs", "get_budget_report_ufs",
    "get_rreo_municipios", "get_budget_report_municipalities",
    "get_rgf_ufs", "get_fiscal_report_ufs",
    "get_rgf_municipios", "get_fiscal_report_municipalities"
  )
  for (nm in new_names) {
    expect_true(is.function(get(nm, envir = asNamespace("tesouror"))),
                info = nm)
  }
})
