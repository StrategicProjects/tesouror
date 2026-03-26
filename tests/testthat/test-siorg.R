# -- SIORG alias existence ----------------------------------------------------

test_that("SIORG Portuguese functions exist", {
  expect_true(is.function(get_siorg_orgaos))
  expect_true(is.function(get_siorg_estrutura))
  expect_true(is.function(get_siorg_unidade))
})

test_that("SIORG English aliases exist", {
  expect_true(is.function(get_siorg_organizations))
  expect_true(is.function(get_siorg_structure))
  expect_true(is.function(get_siorg_unit))
})

# -- Parameter validation -----------------------------------------------------

test_that("SIORG functions requiring codigo_unidade fail without it", {
  expect_error(get_siorg_estrutura(), "Missing required")
  expect_error(get_siorg_unidade(), "Missing required")
})

test_that("SIORG English aliases report English param names", {
  expect_error(get_siorg_structure(), "unit_code")
  expect_error(get_siorg_unit(), "unit_code")
})

# -- Parameter names ----------------------------------------------------------

test_that("SIORG English aliases use English parameter names", {
  expect_named(
    formals(get_siorg_organizations),
    c("power_code", "sphere_code", "use_cache", "verbose")
  )
  expect_named(
    formals(get_siorg_structure),
    c("unit_code", "include_linked", "use_cache", "verbose")
  )
  expect_named(
    formals(get_siorg_unit),
    c("unit_code", "use_cache", "verbose")
  )
})

# -- extract_siorg_code -------------------------------------------------------

test_that("extract_siorg_code extracts code from URI", {
  uri <- "https://estruturaorganizacional.dados.gov.br/id/unidade-organizacional/46"
  expect_equal(extract_siorg_code(uri), "46")
})

test_that("extract_siorg_code handles NA", {
  expect_equal(extract_siorg_code(NA), NA_character_)
})

# -- pad_siorg_code -----------------------------------------------------------

test_that("pad_siorg_code pads numeric to 6 digits", {
  expect_equal(pad_siorg_code(244), "000244")
  expect_equal(pad_siorg_code(26), "000026")
})

test_that("pad_siorg_code pads character to 6 digits", {
  expect_equal(pad_siorg_code("244"), "000244")
  expect_equal(pad_siorg_code("000244"), "000244")
})

test_that("pad_siorg_code returns NULL for NULL", {
  expect_null(pad_siorg_code(NULL))
})
