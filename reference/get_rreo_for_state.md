# Get RREO data for all municipalities of a Brazilian state

Fetches RREO data for every municipality of `state_uf`, looping over
[`get_rreo()`](https://strategicprojects.github.io/tesouror/reference/get_rreo.md)
with fault tolerance: if an individual municipality call fails after all
retries, the failure is recorded and the loop continues. Failed calls
are returned in `attr(result, "failed")`.

## Usage

``` r
get_rreo_for_state(
  state_uf,
  an_exercicio,
  nr_periodo,
  co_tipo_demonstrativo,
  no_anexo,
  include_capital = TRUE,
  on_error = c("warn", "stop", "silent"),
  use_cache = TRUE,
  verbose = FALSE,
  page_size = NULL,
  max_rows = Inf
)

get_budget_report_for_state(state_uf, fiscal_year, period,
  report_type, appendix, include_capital = TRUE,
  on_error = c("warn", "stop", "silent"),
  use_cache = TRUE, verbose = FALSE,
  page_size = NULL, max_rows = Inf)
```

## Arguments

- state_uf:

  Character. Two-letter UF code (e.g., `"PE"`, `"ES"`). **Required**.

- an_exercicio:

  Integer. Fiscal year. **Required**.

- nr_periodo:

  Integer. Bimester (1-6). **Required**.

- co_tipo_demonstrativo:

  Character. `"RREO"` or `"RREO Simplificado"`. **Required**.

- no_anexo:

  Character. Appendix name (e.g., `"RREO-Anexo 01"`). **Required**.

- include_capital:

  Logical. Include the state capital? Defaults to `TRUE`.

- on_error:

  Character. One of `"warn"` (default — log and continue), `"stop"`
  (abort on first failure), or `"silent"` (record but no message).

- use_cache:

  Logical. If `TRUE` (default), uses the in-memory cache.

- verbose:

  Logical. If `TRUE`, prints the full API URL for each call.

- page_size:

  Integer or `NULL`. Rows per API page.

- max_rows:

  Numeric. Maximum rows per municipality call.

- fiscal_year:

  Integer. Fiscal year. **Required**. Maps to `an_exercicio`.

- period:

  Integer. Bimester (1-6). **Required**. Maps to `nr_periodo`.

- report_type:

  Character. `"RREO"` or `"RREO Simplificado"`. **Required**. Maps to
  `co_tipo_demonstrativo`.

- appendix:

  Character. Appendix name. **Required**. Maps to `no_anexo`.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with RREO
rows for all successful municipalities. If any call failed, has an
attribute `"failed"` (tibble with `iteration`, `id`, `error`).

## Details

This is the recommended way to assemble a state-wide panel: it handles
pagination per municipality, uses the cache, and surfaces partial
failures instead of aborting on the first error (see SICONFI behaviour
for entities that have not yet homologated a given report).

`get_budget_report_for_state()` is an English-parameter alias.

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
[`get_rreo()`](https://strategicprojects.github.io/tesouror/reference/get_rreo.md)

## Examples

``` r
if (FALSE) { # \dontrun{
rreo_es <- get_rreo_for_state(
  state_uf = "ES", an_exercicio = 2021, nr_periodo = 6,
  co_tipo_demonstrativo = "RREO", no_anexo = "RREO-Anexo 01"
)
attr(rreo_es, "failed")
} # }
```
