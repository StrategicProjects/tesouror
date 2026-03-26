# -- Transferencias alias existence --------------------------------------------

test_that("Transferencias Portuguese functions exist", {
  expect_true(is.function(get_tc_transferencias))
  expect_true(is.function(get_tc_estados))
  expect_true(is.function(get_tc_municipios))
  expect_true(is.function(get_tc_por_estados))
  expect_true(is.function(get_tc_por_estados_detalhe))
  expect_true(is.function(get_tc_por_municipio))
  expect_true(is.function(get_tc_por_municipio_detalhe))
})

test_that("Transferencias English aliases exist", {
  expect_true(is.function(get_tc_transfer_types))
  expect_true(is.function(get_tc_states))
  expect_true(is.function(get_tc_municipalities))
  expect_true(is.function(get_tc_by_state))
  expect_true(is.function(get_tc_by_state_detail))
  expect_true(is.function(get_tc_by_municipality))
  expect_true(is.function(get_tc_by_municipality_detail))
})

# -- Transferencias parameter names -------------------------------------------

test_that("English aliases use state_code (not state)", {
  expect_named(
    formals(get_tc_by_state),
    c("state_code", "year", "month", "transfer_type", "detailed", "use_cache",
      "verbose")
  )
  expect_named(
    formals(get_tc_by_state_detail),
    c("state_code", "year", "month", "transfer_type", "use_cache", "verbose")
  )
  expect_named(
    formals(get_tc_by_municipality),
    c("state_code", "municipality", "year", "month",
      "transfer_type", "detailed", "use_cache", "verbose")
  )
  expect_named(
    formals(get_tc_by_municipality_detail),
    c("state_code", "municipality", "year", "month",
      "transfer_type", "use_cache", "verbose")
  )
  expect_named(
    formals(get_tc_municipalities),
    c("name", "state_code", "use_cache", "verbose")
  )
})

# -- collapse_param -----------------------------------------------------------

test_that("collapse_param handles NULL", {
  expect_null(collapse_param(NULL))
})

test_that("collapse_param collapses vectors to colon-separated strings", {
  expect_equal(collapse_param(c(1, 2, 3)), "1:2:3")
  expect_equal(collapse_param(c("PE", "AL")), "PE:AL")
})

test_that("collapse_param passes through single values", {
  expect_equal(collapse_param(42), "42")
  expect_equal(collapse_param("1:2:3"), "1:2:3")
})
