# -- CUSTOS alias existence ----------------------------------------------------

test_that("CUSTOS Portuguese functions exist", {
  expect_true(is.function(get_custos_pessoal_ativo))
  expect_true(is.function(get_custos_pessoal_inativo))
  expect_true(is.function(get_custos_pensionistas))
  expect_true(is.function(get_custos_demais))
  expect_true(is.function(get_custos_depreciacao))
  expect_true(is.function(get_custos_transferencias))
})

test_that("CUSTOS English aliases exist", {
  expect_true(is.function(get_costs_active_staff))
  expect_true(is.function(get_costs_retired_staff))
  expect_true(is.function(get_costs_pensioners))
  expect_true(is.function(get_costs_other))
  expect_true(is.function(get_costs_depreciation))
  expect_true(is.function(get_costs_transfers))
})

# -- CUSTOS parameter names ---------------------------------------------------

test_that("CUSTOS English aliases use English parameter names", {
  expect_named(
    formals(get_costs_active_staff),
    c("year", "month", "legal_nature", "org_level1",
      "org_level2", "org_level3", "use_cache", "verbose",
      "page_size", "max_rows")
  )
})

test_that("CUSTOS Portuguese functions use Portuguese parameter names", {
  expect_named(
    formals(get_custos_pessoal_ativo),
    c("ano", "mes", "natureza_juridica", "organizacao_n1",
      "organizacao_n2", "organizacao_n3", "use_cache", "verbose",
      "page_size", "max_rows")
  )
})

# -- All CUSTOS params are optional (no required errors) ----------------------

test_that("CUSTOS functions accept no arguments (all optional)", {
  # These should NOT error on missing params -- they'll only error on

  # network, which we're not testing here. We just verify no
  # "Missing required" error is raised.
  expect_no_error(formals(get_custos_pessoal_ativo))
  expect_no_error(formals(get_custos_demais))
})
