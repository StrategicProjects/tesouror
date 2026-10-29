# ============================================================================
# Build inst/extdata/rreo_layout.csv
#
# This script documents how the bundled layout reference table was assembled.
# It probes the live SICONFI API for federal RREO previdência data across a
# range of fiscal years and inspects the unique values of `coluna` and `conta`,
# which drift across years (see rsiconfi#4).
#
# Run with:
#   source("data-raw/rreo_layout.R")
# ============================================================================

devtools::load_all()

probe <- function(year, anexo) {
  res <- tryCatch(
    get_rreo(
      an_exercicio = year, nr_periodo = 6,
      co_tipo_demonstrativo = "RREO", no_anexo = anexo,
      co_esfera = "U", id_ente = 1, verbose = FALSE
    ),
    error = function(e) NULL
  )
  if (is.null(res) || nrow(res) == 0) return(invisible())
  cat("\n[", year, anexo, "] rows=", nrow(res), "\n", sep = "")
  cat("  conta (matching 'resultado'):\n")
  rc <- unique(res$conta[grepl("resultado", res$conta, ignore.case = TRUE)])
  for (x in rc) cat("    *", x, "\n")
}

# Run discovery to validate or extend rreo_layout.csv
for (yr in c(2019, 2020, 2021, 2022, 2023)) {
  for (an in c("RREO-Anexo 04.1", "RREO-Anexo 04.2",
               "RREO-Anexo 04.3 - RGPS", "RREO-Anexo 04.4 - RGPS")) {
    probe(yr, an)
  }
}

# Findings (2026-04):
#   * 2019-2022: anexo 04.1 carries Civis RPPS + FCDF; 04.3 carries RGPS.
#   * 2023+:     anexo 04.2 carries Civis RPPS + FCDF; 04.4 carries RGPS.
#   * Militares inativos always live in 04.2.
#   * Roman numerals in `conta` shift across years; we match on the stem
#     before the first `(` (see .clean_conta() in R/rreo_tidy.R).
#
# ----------------------------------------------------------------------------
# Topic "rcl" — Receita Corrente Líquida (Anexo 03)
# ----------------------------------------------------------------------------

probe_rcl <- function(year, id_ente) {
  res <- tryCatch(
    get_rreo_ufs(
      an_exercicio = year, nr_periodo = 6,
      co_tipo_demonstrativo = "RREO", no_anexo = "RREO-Anexo 03",
      id_ente = id_ente, verbose = FALSE
    ),
    error = function(e) NULL
  )
  if (is.null(res) || nrow(res) == 0) return(invisible())
  cat("\n[", year, " ente=", id_ente, "] rows=", nrow(res), "\n", sep = "")
  rc <- unique(res$conta[grepl("CORRENTE L", res$conta, ignore.case = TRUE)])
  for (x in rc) cat("    *", x, "\n")
}

# União (1), a state (PE = 26) and a municipality (Recife = 2611606)
for (yr in c(2015, 2019, 2020, 2024, 2025)) {
  for (ente in c(1, 26, 2611606)) probe_rcl(yr, ente)
}

# Findings (2026-10):
#   * "RECEITA CORRENTE LÍQUIDA (III) = (I - II)" exists for every year
#     (2015+) and every sphere; the appendix name "RREO-Anexo 03" never moved.
#   * The two adjusted-RCL accounts ("... AJUSTADA PARA CÁLCULO DOS LIMITES
#     DE ENDIVIDAMENTO" and "... DA DESPESA COM PESSOAL") appear from 2020
#     onwards and only for states and municipalities — the União does not
#     publish them. Their Roman numerals drifted in 2024
#     ("(VII) = (V - VI)" -> "(IX) = (V - VI - VII - VIII)"), which the
#     .clean_conta() match key absorbs.
#   * RREO-Anexo 14 (simplified statement) repeats all three RCL accounts
#     under the same labels, so tidy_rreo() also matches on the `anexo`
#     column when the input has one.
#
# The CSV inst/extdata/rreo_layout.csv is the single source of truth and is
# read at runtime by rreo_layout(). Edit it directly to add new topics.
