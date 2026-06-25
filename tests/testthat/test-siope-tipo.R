# Tests for the SIOPE `tipo`/`type` convenience filter (issue #2).

test_that("siope_tipo_filter maps friendly state synonyms to DS_TIPO", {
  expect_equal(siope_tipo_filter("estado"), "DS_TIPO eq 'Estado'")
  expect_equal(siope_tipo_filter("Estado"), "DS_TIPO eq 'Estado'")
  expect_equal(siope_tipo_filter("UF"), "DS_TIPO eq 'Estado'")
  expect_equal(siope_tipo_filter("state"), "DS_TIPO eq 'Estado'")
})

test_that("siope_tipo_filter maps municipality synonyms (accent-insensitive)", {
  muni <- "DS_TIPO eq 'Município'"
  expect_equal(siope_tipo_filter("municipio"), muni)
  expect_equal(siope_tipo_filter("Município"), muni)
  expect_equal(siope_tipo_filter("municipios"), muni)
  expect_equal(siope_tipo_filter("municipality"), muni)
  expect_equal(siope_tipo_filter("municipalities"), muni)
})

test_that("siope_tipo_filter returns the filter unchanged when tipo is NULL", {
  expect_null(siope_tipo_filter(NULL))
  expect_equal(siope_tipo_filter(NULL, "NOM_MUNI eq 'Recife'"),
               "NOM_MUNI eq 'Recife'")
})

test_that("siope_tipo_filter combines with an existing filter via 'and'", {
  expect_equal(
    siope_tipo_filter("estado", "NUM_POPU gt 100000"),
    "(NUM_POPU gt 100000) and DS_TIPO eq 'Estado'"
  )
})

test_that("siope_tipo_filter aborts on an unknown tipo", {
  expect_error(siope_tipo_filter("foobar"), "tipo")
})

test_that("get_siope_dados_gerais sends the DS_TIPO filter to the server", {
  skip_if_no_httptest2()
  local_fast_retry()
  rec <- capture_url(function() mock_json_response(body = list(value = list())))

  httr2::with_mocked_responses(
    rec$mock,
    suppressMessages(get_siope_dados_gerais(
      ano = 2023, periodo = 6, uf = "PE", tipo = "estado", use_cache = FALSE
    ))
  )

  url <- rec$urls()[1]
  expect_match(url, "DS_TIPO")
  expect_match(url, "Estado")
})

test_that("get_siope_general_data forwards `type` to `tipo`", {
  skip_if_no_httptest2()
  local_fast_retry()
  rec <- capture_url(function() mock_json_response(body = list(value = list())))

  httr2::with_mocked_responses(
    rec$mock,
    suppressMessages(get_siope_general_data(
      year = 2023, period = 6, state = "PE", type = "municipality",
      use_cache = FALSE
    ))
  )

  expect_match(rec$urls()[1], "DS_TIPO")
})
