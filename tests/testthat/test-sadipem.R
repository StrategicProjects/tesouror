# -- SADIPEM alias existence ---------------------------------------------------

test_that("SADIPEM Portuguese functions exist", {
  expect_true(is.function(get_pvl))
  expect_true(is.function(get_pvl_tramitacao))
  expect_true(is.function(get_opc_cronograma_liberacoes))
  expect_true(is.function(get_opc_cronograma_pagamentos))
  expect_true(is.function(get_opc_taxa_cambio))
  expect_true(is.function(get_res_cdp))
  expect_true(is.function(get_res_cronograma_pagamentos))
})

test_that("SADIPEM English aliases exist", {
  expect_true(is.function(get_debt_requests))
  expect_true(is.function(get_pvl_status))
  expect_true(is.function(get_credit_release_schedule))
  expect_true(is.function(get_credit_payment_schedule))
  expect_true(is.function(get_credit_exchange_rate))
  expect_true(is.function(get_debt_capacity))
  expect_true(is.function(get_debt_payment_schedule))
})

# -- SADIPEM parameter validation ---------------------------------------------

test_that("SADIPEM functions requiring id_pleito fail without it", {
  expect_error(get_pvl_tramitacao(), "Missing required")
  expect_error(get_opc_cronograma_liberacoes(), "Missing required")
  expect_error(get_opc_cronograma_pagamentos(), "Missing required")
  expect_error(get_opc_taxa_cambio(), "Missing required")
  expect_error(get_res_cdp(), "Missing required")
  expect_error(get_res_cronograma_pagamentos(), "Missing required")
})

test_that("SADIPEM English aliases report English param names", {
  expect_error(get_pvl_status(), "request_id")
  expect_error(get_credit_release_schedule(), "request_id")
  expect_error(get_debt_capacity(), "request_id")
})

# -- SADIPEM parameter names --------------------------------------------------

test_that("SADIPEM English aliases use English parameter names", {
  expect_named(
    formals(get_debt_requests),
    c("state", "entity_type", "entity_id", "use_cache", "verbose",
      "page_size", "max_rows")
  )
  expect_named(
    formals(get_pvl_status),
    c("request_id", "use_cache", "verbose", "page_size", "max_rows")
  )
})

# -- NA validation ------------------------------------------------------------

test_that("SADIPEM functions reject NA in required params", {
  expect_error(get_pvl_tramitacao(id_pleito = NA), "cannot be NA")
  expect_error(get_pvl_status(request_id = NA), "cannot be NA")
  expect_error(get_res_cdp(id_pleito = NA), "cannot be NA")
})
