# Get Budget Execution Summary Report data (RREO)

Retrieves data from the Budget Execution Summary Report (RREO) for
specific filtering criteria. The RREO is published bimonthly and
contains information about revenues, expenses, and other budgetary data.

## Usage

``` r
get_rreo(
  an_exercicio,
  nr_periodo,
  co_tipo_demonstrativo,
  no_anexo,
  co_esfera,
  id_ente,
  use_cache = TRUE,
  verbose = FALSE,
  page_size = NULL,
  max_rows = Inf
)

get_budget_report(fiscal_year, period, report_type, appendix,
  sphere, entity_id, use_cache = TRUE, verbose = FALSE,
  page_size = NULL, max_rows = Inf)
```

## Arguments

- an_exercicio:

  Integer. Fiscal year (e.g., `2022`). **Required**.

- nr_periodo:

  Integer. Bimester number (1-6). **Required**.

- co_tipo_demonstrativo:

  Character. Report type: `"RREO"` or `"RREO Simplificado"`.
  **Required**. Note: `"RREO Simplificado"` applies only to
  municipalities with fewer than 50,000 inhabitants that opted for
  simplified reporting.

- no_anexo:

  Character. Appendix name (e.g., `"RREO-Anexo 01"`). **Required**.

- co_esfera:

  Character. Government sphere: `"M"` (municipalities), `"E"` (states),
  or `"U"` (union). **Required**.

- id_ente:

  Integer. IBGE code of the entity. **Required**.

- use_cache:

  Logical. If `TRUE` (default), uses an in-memory cache.

- verbose:

  Logical. If `TRUE`, prints the full API URL being called. Useful for
  debugging or testing in a browser. Defaults to
  `getOption("tesouror.verbose", FALSE)`.

- page_size:

  Integer or `NULL`. Number of rows per API page. If `NULL` (default),
  uses the API server default (5000 for SICONFI/SADIPEM).

- max_rows:

  Numeric. Maximum number of rows to return. Defaults to `Inf` (all
  rows). Useful for quick tests with large datasets (e.g.,
  `max_rows = 100`).

- fiscal_year:

  Integer. Fiscal year (e.g., `2022`). **Required**. Maps to
  `an_exercicio`.

- period:

  Integer. Bimester number (1-6). **Required**. Maps to `nr_periodo`.

- report_type:

  Character. Report type: `"RREO"` or `"RREO Simplificado"`.
  **Required**. Maps to `co_tipo_demonstrativo`.

- appendix:

  Character. Appendix name (e.g., `"RREO-Anexo 01"`). **Required**. Maps
  to `no_anexo`.

- sphere:

  Character. Government sphere: `"M"` (municipalities), `"E"` (states),
  or `"U"` (union). **Required**. Maps to `co_esfera`.

- entity_id:

  Integer. IBGE code of the entity. **Required**. Maps to `id_ente`.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with RREO
data including columns such as `exercicio`, `demonstrativo`, `periodo`,
`periodicidade`, `instituicao`, `cod_ibge`, `uf`, `populacao`, `anexo`,
`rotulo`, `coluna`, `cod_conta`, `conta`, and `valor`.

## Details

`get_budget_report()` is an English-parameter alias for this function.

## See also

Other SICONFI:
[`get_anexos()`](https://strategicprojects.github.io/tesouror/reference/get_anexos.md),
[`get_dca()`](https://strategicprojects.github.io/tesouror/reference/get_dca.md),
[`get_dca_for_state()`](https://strategicprojects.github.io/tesouror/reference/get_dca_for_state.md),
[`get_entes()`](https://strategicprojects.github.io/tesouror/reference/get_entes.md),
[`get_extrato()`](https://strategicprojects.github.io/tesouror/reference/get_extrato.md),
[`get_msc_controle()`](https://strategicprojects.github.io/tesouror/reference/get_msc_controle.md),
[`get_msc_orcamentaria()`](https://strategicprojects.github.io/tesouror/reference/get_msc_orcamentaria.md),
[`get_msc_patrimonial()`](https://strategicprojects.github.io/tesouror/reference/get_msc_patrimonial.md),
[`get_rgf()`](https://strategicprojects.github.io/tesouror/reference/get_rgf.md),
[`get_rgf_for_state()`](https://strategicprojects.github.io/tesouror/reference/get_rgf_for_state.md),
[`get_rreo_for_state()`](https://strategicprojects.github.io/tesouror/reference/get_rreo_for_state.md)

## Examples

``` r
if (FALSE) { # \dontrun{
rreo <- get_rreo(
  an_exercicio = 2022, nr_periodo = 6,
  co_tipo_demonstrativo = "RREO",
  no_anexo = "RREO-Anexo 01",
  co_esfera = "E", id_ente = 17
)
} # }
```
