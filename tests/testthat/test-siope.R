# tests/testthat/test-siope.R

# -- SIOPE base URL -----------------------------------------------------------

test_that("siope_base_url returns correct URL", {
  expect_match(
    tesouror:::siope_base_url(),
    "fnde.gov.br/olinda-ide/servico/DADOS_ABERTOS_SIOPE"
  )
})

# -- SIOPE URL builder --------------------------------------------------------

test_that("siope_build_url constructs OData URL correctly", {
  result <- tesouror:::siope_build_url(
    "Dados_Gerais_Siope",
    list(Ano_Consulta = 2023, Num_Peri = 6, Sig_UF = "PE")
  )

  expect_match(result$url, "Dados_Gerais_Siope\\(Ano_Consulta=@Ano_Consulta")
  expect_equal(result$query[["@Ano_Consulta"]], 2023)
  expect_equal(result$query[["@Num_Peri"]], 6)
  expect_equal(result$query[["@Sig_UF"]], "'PE'")
  expect_equal(result$query[["$format"]], "json")
})

test_that("siope_build_url quotes text params", {
  result <- tesouror:::siope_build_url(
    "Receita_Siope",
    list(Ano_Consulta = 2023, Num_Peri = 1, Sig_UF = "AC")
  )
  expect_equal(result$query[["@Sig_UF"]], "'AC'")
  expect_equal(result$query[["@Ano_Consulta"]], 2023)
})

# -- Parameter names ----------------------------------------------------------

test_that("SIOPE Portuguese functions have correct parameter names", {
  expect_named(
    formals(get_siope_dados_gerais),
    c("ano", "periodo", "uf", "use_cache", "verbose", "page_size", "max_rows",
      "filter", "orderby", "select")
  )
  expect_named(
    formals(get_siope_remuneracao),
    c("ano", "periodo", "mes", "uf", "use_cache", "verbose", "page_size",
      "max_rows", "filter", "orderby", "select")
  )
})

test_that("SIOPE English aliases have correct parameter names", {
  expect_named(
    formals(get_siope_general_data),
    c("year", "period", "state", "use_cache", "verbose", "page_size", "max_rows",
      "filter", "orderby", "select")
  )
  expect_named(
    formals(get_siope_compensation),
    c("year", "period", "month", "state", "use_cache", "verbose", "page_size",
      "max_rows", "filter", "orderby", "select")
  )
})

# -- Required params ----------------------------------------------------------

test_that("SIOPE functions reject missing required params", {
  expect_error(get_siope_dados_gerais(), "missing")
  expect_error(get_siope_general_data(), "missing")
  expect_error(get_siope_remuneracao(), "missing")
  expect_error(get_siope_compensation(), "missing")
})

test_that("SIOPE functions reject NA in required params", {
  expect_error(get_siope_dados_gerais(ano = NA, periodo = 6, uf = "PE"), "cannot be NA")
  expect_error(get_siope_remuneracao(ano = 2023, periodo = 6, mes = NA, uf = "PE"), "cannot be NA")
})

# -- All 8 PT functions exist -------------------------------------------------

test_that("All 8 SIOPE PT functions are exported", {
  expect_true(is.function(get_siope_dados_gerais))
  expect_true(is.function(get_siope_responsaveis))
  expect_true(is.function(get_siope_despesas))
  expect_true(is.function(get_siope_despesas_funcao))
  expect_true(is.function(get_siope_indicadores))
  expect_true(is.function(get_siope_info_complementares))
  expect_true(is.function(get_siope_receitas))
  expect_true(is.function(get_siope_remuneracao))
})

# -- All 8 EN functions exist -------------------------------------------------

test_that("All 8 SIOPE EN aliases are exported", {
  expect_true(is.function(get_siope_general_data))
  expect_true(is.function(get_siope_officials))
  expect_true(is.function(get_siope_expenses))
  expect_true(is.function(get_siope_expenses_by_function))
  expect_true(is.function(get_siope_indicators))
  expect_true(is.function(get_siope_supplementary))
  expect_true(is.function(get_siope_revenues))
  expect_true(is.function(get_siope_compensation))
})
