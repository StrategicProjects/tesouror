test_that("rreo_layout() loads the bundled CSV with expected columns", {
  layout <- rreo_layout()
  expect_s3_class(layout, "tbl_df")
  expect_setequal(
    names(layout),
    c("topic", "regime", "first_year", "last_year", "co_esfera",
      "no_anexo", "conta_match", "cod_conta_match", "indicador")
  )
  expect_true(all(layout$first_year <= layout$last_year))
  expect_setequal(
    unique(layout$topic),
    c("previdencia", "rcl", "balanco", "resultado")
  )
  # exactly one matching key per rule
  expect_true(all(xor(nzchar(layout$conta_match),
                      nzchar(layout$cod_conta_match))))
})

test_that("rreo_normalize_columns extracts coluna_padrao and coluna_ano", {
  demo <- tibble::tibble(
    coluna = c(
      "DESPESAS LIQUIDADAS ATÉ O BIMESTRE / 2023",
      "DESPESAS LIQUIDADAS ATÉ O BIMESTRE/ 2023",
      "DESPESAS LIQUIDADAS ATÉ O BIMESTRE /2023",
      "DESPESAS LIQUIDADAS ATÉ O BIMESTRE",
      "INSCRITAS EM RESTOS A PAGAR NÃO PROCESSADOS EM 2023",
      "PREVISÃO INICIAL"
    )
  )
  out <- rreo_normalize_columns(demo)

  expect_equal(
    out$coluna_padrao,
    c(
      "DESPESAS LIQUIDADAS ATÉ O BIMESTRE",
      "DESPESAS LIQUIDADAS ATÉ O BIMESTRE",
      "DESPESAS LIQUIDADAS ATÉ O BIMESTRE",
      "DESPESAS LIQUIDADAS ATÉ O BIMESTRE",
      "INSCRITAS EM RESTOS A PAGAR NÃO PROCESSADOS",
      "PREVISÃO INICIAL"
    )
  )
  expect_equal(out$coluna_ano, c(2023L, 2023L, 2023L, NA_integer_, 2023L, NA_integer_))
})

test_that("rreo_normalize_columns aborts when coluna is missing", {
  expect_error(
    rreo_normalize_columns(tibble::tibble(x = 1)),
    "coluna"
  )
})

test_that("tidy_rreo matches RGPS rows across years despite label drift", {
  fixture <- tibble::tibble(
    exercicio = c(2019L, 2022L, 2023L, 2023L, 2019L),
    instituicao = "Uniao Federal",
    cod_ibge = 1,
    uf = "BR",
    conta = c(
      "Resultado Previdenciário RGPS (VII) = (III - VI)",   # 2019: matches rgps
      "Resultado Previdenciário RGPS (V) = (III - IV)",     # 2022: matches rgps (different roman)
      "Resultado Previdenciário RGPS (VII) = (III - VI)",   # 2023: matches rgps
      "RESULTADO PREVIDENCIÁRIO RPPS CIVIS (V) = (III - IV)", # 2023: matches civil
      "Resultado Previdenciário RGPS (VII) = (III - VI)"    # 2019 RGPS again
    ),
    coluna = c(
      "DESPESAS LIQUIDADAS ATÉ O BIMESTRE / 2019",
      "DESPESAS LIQUIDADAS ATÉ O BIMESTRE",
      "DESPESAS LIQUIDADAS ATÉ O BIMESTRE / 2023",
      "DESPESAS LIQUIDADAS ATÉ O BIMESTRE / 2023",
      "DESPESAS EMPENHADAS ATÉ O BIMESTRE/ 2018"
    ),
    valor = c(100, 200, 300, 50, 90)
  )

  rgps <- tidy_rreo(fixture, topic = "previdencia", regime = "rgps")

  expect_equal(nrow(rgps), 4L) # 3 RGPS rows + 1 RGPS row from year 2019 prev-year column
  expect_true(all(rgps$indicador == "resultado_previdenciario_rgps"))
  expect_setequal(rgps$exercicio, c(2019L, 2022L, 2023L))
  expect_true("coluna_padrao" %in% names(rgps))
  expect_setequal(
    unique(rgps$coluna_padrao),
    c("DESPESAS LIQUIDADAS ATÉ O BIMESTRE",
      "DESPESAS EMPENHADAS ATÉ O BIMESTRE")
  )

  # coluna_ano correctly tags previous-year row
  prev_year <- rgps[rgps$valor == 90, ]
  expect_equal(prev_year$coluna_ano, 2018L)
})

test_that("tidy_rreo without regime returns all matching regimes", {
  fixture <- tibble::tibble(
    exercicio = c(2023L, 2023L),
    conta = c(
      "Resultado Previdenciário RGPS (VII) = (III - VI)",
      "RESULTADO PREVIDENCIÁRIO RPPS CIVIS (V) = (III - IV)"
    ),
    coluna = "DESPESAS LIQUIDADAS ATÉ O BIMESTRE / 2023",
    valor = c(10, 20)
  )

  out <- tidy_rreo(fixture, topic = "previdencia")
  expect_setequal(out$regime, c("rgps", "civil_rpps"))
})

test_that("tidy_rreo aborts on unknown topic and warns when nothing matches", {
  fixture <- tibble::tibble(
    exercicio = 2023L,
    conta = "Resultado Previdenciário RGPS (VII)",
    coluna = "DESPESAS LIQUIDADAS",
    valor = 1
  )

  expect_error(
    tidy_rreo(fixture, topic = "inexistente"),
    "No layout entry"
  )

  fixture_no_match <- tibble::tibble(
    exercicio = 2023L, conta = "OUTRA CONTA QUALQUER",
    coluna = "DESPESAS LIQUIDADAS", valor = 1
  )
  out <- suppressMessages(
    tidy_rreo(fixture_no_match, topic = "previdencia")
  )
  expect_equal(nrow(out), 0L)
})

test_that("tidy_rreo matches RCL rows across years, spheres and label drift", {
  fixture <- tibble::tibble(
    exercicio = c(2015L, 2024L, 2024L, 2024L, 2019L),
    uf = c("BR", "PE", "PE", "PE", "PE"),
    anexo = "RREO-Anexo 03",
    conta = c(
      "RECEITA CORRENTE LÍQUIDA (III) = (I - II)",            # 2015 União
      "RECEITA CORRENTE LÍQUIDA (III) = (I - II)",            # 2024 state
      # 2024 drifted Roman numerals (was "(VII) = (V - VI)" before)
      "RECEITA CORRENTE LÍQUIDA AJUSTADA PARA CÁLCULO DOS LIMITES DA DESPESA COM PESSOAL (IX) = (V - VI - VII - VIII)",
      "RECEITA CORRENTE LÍQUIDA AJUSTADA PARA CÁLCULO DOS LIMITES DE ENDIVIDAMENTO (V) = (III - IV)",
      # 2019: adjusted RCL did not exist yet -> must NOT match (first_year 2020)
      "RECEITA CORRENTE LÍQUIDA AJUSTADA PARA CÁLCULO DOS LIMITES DE ENDIVIDAMENTO (V) = (III - IV)"
    ),
    coluna = "TOTAL (ÚLTIMOS 12 MESES)",
    valor = c(100, 200, 300, 400, 500)
  )

  out <- tidy_rreo(fixture, topic = "rcl")
  expect_equal(nrow(out), 4L)
  expect_setequal(
    out$indicador,
    c("receita_corrente_liquida", "rcl_ajustada_pessoal",
      "rcl_ajustada_endividamento")
  )
  expect_false(500 %in% out$valor)

  total <- tidy_rreo(fixture, topic = "rcl", regime = "total")
  expect_equal(total$valor, c(100, 200))
})

test_that("tidy_rreo ignores Anexo 14 duplicates when anexo is present", {
  fixture <- tibble::tibble(
    exercicio = 2024L,
    anexo = c("RREO-Anexo 03", "RREO-Anexo 14"),
    conta = "RECEITA CORRENTE LÍQUIDA (III) = (I - II)",
    coluna = "TOTAL (ÚLTIMOS 12 MESES)",
    valor = c(100, 100)
  )

  out <- tidy_rreo(fixture, topic = "rcl")
  expect_equal(nrow(out), 1L)
  expect_equal(out$anexo, "RREO-Anexo 03")

  # without the anexo column the guard is skipped (backward compatible)
  out_no_anexo <- tidy_rreo(dplyr::select(fixture, -anexo), topic = "rcl")
  expect_equal(nrow(out_no_anexo), 2L)
})

test_that("tidy_rreo matches balanco rows by cod_conta across the 2020 relabeling", {
  fixture <- tibble::tibble(
    exercicio = c(2015L, 2015L, 2015L, 2024L, 2024L, 2024L),
    anexo = "RREO-Anexo 01",
    conta = c(
      "SUBTOTAL DAS RECEITAS (III) = (I + II)",
      # old era: "TOTAL" appears on BOTH sides -> ambiguous label, not matched
      "TOTAL (VII) = (V + VI)",
      "TOTAL (XIV) = (XII + XIII)",
      "SUBTOTAL DAS RECEITAS (III) = (I + II)",
      "RECEITAS CORRENTES",
      "RECEITAS CORRENTES"
    ),
    cod_conta = c(
      "SubtotalDasReceitas", "TotalReceitas", "TotalDespesas",
      "SubtotalDasReceitas",
      # same label, different codes: main vs intra must not be lumped
      "ReceitasCorrentes", "ReceitasCorrentesIntra"
    ),
    coluna = "RECEITAS REALIZADAS ATÉ O BIMESTRE",
    valor = c(10, 11, 12, 20, 30, 31)
  )

  out <- tidy_rreo(fixture, topic = "balanco")
  expect_setequal(out$valor, c(10, 20, 30))
  expect_setequal(out$regime, c("receitas", "receitas_correntes"))

  receitas <- tidy_rreo(fixture, topic = "balanco", regime = "receitas")
  expect_equal(sort(receitas$exercicio), c(2015L, 2024L))
  expect_true(all(receitas$indicador == "receitas_subtotal"))
})

test_that("tidy_rreo separates resultado series whose labels collapse (2023+)", {
  fixture <- tibble::tibble(
    exercicio = c(2016L, 2016L, 2020L, 2024L, 2024L, 2024L),
    anexo = "RREO-Anexo 06",
    conta = c(
      "RESULTADO PRIMÁRIO (XIX) = (VII - XVIII)",            # E/M, era antiga
      "RESULTADO PRIMÁRIO DA UNIÃO (X) = (V - VI - VII)",    # União, era antiga
      "RESULTADO PRIMÁRIO - Acima da Linha (XXIV) = (...)",  # 2018-2022
      # 2023+: os dois rótulos viram "resultado primario" depois de limpos
      "RESULTADO PRIMÁRIO (COM RPPS) - Acima da Linha (XXXIV) = (...)",
      "RESULTADO PRIMÁRIO (SEM RPPS) - Acima da Linha (XXXV) = (...)",
      "RESULTADO NOMINAL (SEM RPPS) - Acima da Linha (XXXVIII) = (...)"
    ),
    cod_conta = c(
      "RREO6ResultadoPrimarioEstadosMunicipios",
      "RREO6ResultadoPrimarioDaUniao",
      "RREO6ResultadoPrimarioEstadosMunicipios",
      "ResultadoPrimarioComRPPSAcimaDaLinha",
      "ResultadoPrimarioSemRPPSAcimaDaLinha",
      "ResultadoNominalAcimaDaLinhaSemRPPS"
    ),
    coluna = "Até o Bimestre / 2024",
    valor = c(1, 2, 3, 40, 50, 60)
  )

  out <- tidy_rreo(fixture, topic = "resultado")
  expect_equal(nrow(out), 6L)

  primario <- tidy_rreo(fixture, topic = "resultado", regime = "primario")
  expect_setequal(primario$valor, c(1, 2, 3))
  expect_true(all(primario$indicador == "resultado_primario"))

  com <- tidy_rreo(fixture, topic = "resultado", regime = "primario_com_rpps")
  expect_equal(com$valor, 40)
  sem <- tidy_rreo(fixture, topic = "resultado", regime = "primario_sem_rpps")
  expect_equal(sem$valor, 50)
})

test_that("tidy_rreo aborts when a cod_conta topic gets data without cod_conta", {
  fixture <- tibble::tibble(
    exercicio = 2024L,
    conta = "SUBTOTAL DAS RECEITAS (III) = (I + II)",
    coluna = "RECEITAS REALIZADAS",
    valor = 1
  )
  expect_error(tidy_rreo(fixture, topic = "balanco"), "cod_conta")
})

test_that("tidy_rreo aborts when required columns are missing", {
  expect_error(
    tidy_rreo(tibble::tibble(exercicio = 1, conta = "x"), topic = "previdencia"),
    "missing required column"
  )
})
