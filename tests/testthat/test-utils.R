test_that("cache_key creates deterministic keys", {
  k1 <- cache_key("http://example.com", list(a = 1, b = 2))
  k2 <- cache_key("http://example.com", list(b = 2, a = 1))
  expect_equal(k1, k2)
})

test_that("cache_get returns NULL for missing keys", {
  expect_null(cache_get("nonexistent_key_12345"))
})

test_that("cache_set and cache_get round-trip", {
  cache_set("test_key_abc", list(x = 42))
  result <- cache_get("test_key_abc")
  expect_equal(result, list(x = 42))
  rm("test_key_abc", envir = the_cache)
})

test_that("tesouror_clear_cache empties the cache", {
  cache_set("temp_key_1", "value1")
  cache_set("temp_key_2", "value2")
  expect_false(length(ls(envir = the_cache)) == 0)
  suppressMessages(tesouror_clear_cache())
  expect_equal(length(ls(envir = the_cache)), 0)
})


test_that("base URLs return expected values", {
  expect_equal(
    siconfi_base_url(),
    "https://apidatalake.tesouro.gov.br/ords/siconfi/tt"
  )

  expect_equal(
    custos_base_url(),
    "https://apidatalake.tesouro.gov.br/ords/custos/tt"
  )

  expect_equal(
    sadipem_base_url(),
    "https://apidatalake.tesouro.gov.br/ords/sadipem/tt/"
  )

  expect_match(transferencias_base_url(), "transferencias_constitucionais")

  expect_equal(
    siorg_base_url(),
    "https://estruturaorganizacional.dados.gov.br"
  )
})

# -- check_required NA validation ---------------------------------------------

test_that("check_required catches NA values", {
  expect_error(get_dca(an_exercicio = NA, id_ente = 17), "cannot be NA")
  expect_error(get_dca(an_exercicio = 2022, id_ente = NA), "cannot be NA")
})
