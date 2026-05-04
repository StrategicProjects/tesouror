# Tidy a RREO tibble by topic, reconciling layout drift across years

Filters a long RREO tibble (typically produced by
[`get_rreo()`](https://strategicprojects.github.io/tesouror/reference/get_rreo.md))
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
  [`get_rreo()`](https://strategicprojects.github.io/tesouror/reference/get_rreo.md)
  or
  [`get_rreo_for_state()`](https://strategicprojects.github.io/tesouror/reference/get_rreo_for_state.md),
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
  get_rreo(an_exercicio = yr, nr_periodo = 6,
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
