# Tidy a RREO tibble by topic, reconciling layout drift across years

Filters a long RREO tibble (typically produced by
[`get_rreo_ufs()`](https://strategicprojects.github.io/tesouror/reference/get_rreo_ufs.md))
down to the rows that match a known indicator for `topic` (and
optionally `regime`), using the rules in
[`rreo_layout()`](https://strategicprojects.github.io/tesouror/reference/rreo_layout.md).
Account labels are matched on a year-stable, accent-folded key (Roman
numerals and formula text are stripped before comparison), so the same
call returns a coherent series across years even when SICONFI relabelled
the appendix or account.

## Usage

``` r
tidy_rreo(data, topic, regime = NULL)
```

## Arguments

- data:

  A tibble returned by
  [`get_rreo_ufs()`](https://strategicprojects.github.io/tesouror/reference/get_rreo_ufs.md)
  or
  [`get_rreo_municipios()`](https://strategicprojects.github.io/tesouror/reference/get_rreo_municipios.md),
  with at least the columns `exercicio`, `conta`, `coluna`, `valor`.

- topic:

  Character. Topic name (e.g., `"previdencia"`). See
  [`rreo_layout()`](https://strategicprojects.github.io/tesouror/reference/rreo_layout.md)
  for the supported set.

- regime:

  Optional character. Filter to a subset of regimes within `topic`
  (e.g., `"rgps"`, `"rpps"`). When `NULL` (default) all regimes are
  kept.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with the
matched rows, plus extra columns:

- `indicador`: stable indicator name (e.g.,
  `"resultado_previdenciario_rgps"`).

- `regime`: matched regime.

- `coluna_padrao`, `coluna_ano`: see
  [`rreo_normalize_columns()`](https://strategicprojects.github.io/tesouror/reference/rreo_normalize_columns.md).

## Details

Currently supported topics:

- `"previdencia"` — federal previdência (RGPS, RPPS civis, FCDF,
  militares inativos) for the União sphere. Anexos 04.1 / 04.2 / 04.3 /
  04.4 of the RREO; the layout knows that the RGPS appendix moved from
  04.3 (up to 2022) to 04.4 (2023+) and that civis/FCDF moved from 04.1
  (up to 2022) to 04.2 (2023+).

- `"rcl"` — Receita Corrente Líquida (Anexo 03), all spheres. Regimes:
  `"total"` (2015+, União/states/municipalities) and, for states and
  municipalities from 2020 onwards, `"ajustada_endividamento"` and
  `"ajustada_pessoal"` (the adjusted RCL used for the debt and personnel
  spending limits; the União does not publish them, and the Roman
  numerals in their labels drifted in 2024 — the match key absorbs
  that).

- `"balanco"` — Balanço Orçamentário (Anexo 01), all spheres, 2015+.
  Matched on `cod_conta`, which stays stable across the 2020 relabeling
  (`"TOTAL"` became `"TOTAL DAS RECEITAS"` etc.) and disambiguates
  labels that repeat on both sides of the statement. Regimes:
  `"receitas"` and `"despesas"` (the subtotals excluding refinancing
  operations, the stable headline across eras), `"receitas_correntes"`,
  `"receitas_capital"`, `"despesas_correntes"`, `"despesas_capital"`
  (main-budget categories; intra-budget rows carry their own codes and
  are not lumped in), `"superavit"` and `"deficit"` (each present only
  in the years the entity had one).

- `"resultado"` — Resultado Primário e Nominal (Anexo 06), all spheres.
  Matched on `cod_conta`: the 2023 state/municipal reform split the
  primary result into `(COM RPPS)` and `(SEM RPPS)` variants whose
  labels collapse to the same cleaned text. Regimes: `"primario"` (the
  headline above-the-line series: União 2015+, states/municipalities
  2015-2022), `"primario_com_rpps"` / `"primario_sem_rpps"` (its
  state/municipal successors, 2023+), `"primario_abaixo"` (+
  `"primario_abaixo_sem_rpps"`), `"nominal"` (2018+; before 2018 the
  nominal result lived in the old Anexo 05 as a derived debt variation
  and is not covered), `"nominal_sem_rpps"`, `"nominal_abaixo"` (+
  `"nominal_abaixo_sem_rpps"`), and `"nominal_ajustado"` (+
  `"nominal_ajustado_sem_rpps"`).

Rules that match on `cod_conta` (see
[`rreo_layout()`](https://strategicprojects.github.io/tesouror/reference/rreo_layout.md))
require the input to carry that column; the raw SICONFI output always
does.

When the input has an `anexo` column (the raw SICONFI output always
does), rows only match the layout rule for their own appendix. This
avoids double counting with `RREO-Anexo 14` (the simplified statement),
which repeats the RCL accounts of Anexo 03 under the same labels —
relevant when you fetched the whole RREO without `no_anexo`. Inputs
without an `anexo` column skip this guard and match on account label and
year alone.

Pull requests adding new topics to `inst/extdata/rreo_layout.csv` are
welcome.

## See also

Other RREO tidy:
[`rreo_layout()`](https://strategicprojects.github.io/tesouror/reference/rreo_layout.md),
[`rreo_normalize_columns()`](https://strategicprojects.github.io/tesouror/reference/rreo_normalize_columns.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(dplyr)
rreo <- purrr::map_dfr(2019:2023, \(yr) {
  get_rreo_ufs(an_exercicio = yr, nr_periodo = 6,
               co_tipo_demonstrativo = "RREO",
               no_anexo = rreo_layout()$no_anexo[
                 rreo_layout()$topic == "previdencia" &
                 rreo_layout()$regime == "rgps" &
                 yr >= rreo_layout()$first_year &
                 yr <= rreo_layout()$last_year
               ][1],
               co_esfera = "U", id_ente = 1)
})
tidy_rreo(rreo, topic = "previdencia", regime = "rgps") |>
  filter(coluna_padrao == "DESPESAS LIQUIDADAS ATÉ O BIMESTRE",
         is.na(coluna_ano) | coluna_ano == exercicio) |>
  select(exercicio, indicador, valor)
} # }
```
