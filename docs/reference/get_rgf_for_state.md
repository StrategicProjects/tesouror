# Get RGF data for all municipalities of a Brazilian state

Fetches RGF data for every municipality of `state_uf`, looping over
[`get_rgf()`](https://strategicprojects.github.io/tesouror/reference/get_rgf.md)
with fault tolerance. See
[`get_rreo_for_state()`](https://strategicprojects.github.io/tesouror/reference/get_rreo_for_state.md)
for the rationale and behaviour of `on_error`.

## Usage

``` r
get_rgf_for_state(
  state_uf,
  an_exercicio,
  in_periodicidade,
  nr_periodo,
  co_tipo_demonstrativo,
  no_anexo,
  co_poder,
  include_capital = TRUE,
  on_error = c("warn", "stop", "silent"),
  use_cache = TRUE,
  verbose = FALSE,
  page_size = NULL,
  max_rows = Inf
)

get_fiscal_report_for_state(state_uf, fiscal_year, periodicity,
  period, report_type, appendix, branch,
  include_capital = TRUE, on_error = c("warn", "stop", "silent"),
  use_cache = TRUE, verbose = FALSE,
  page_size = NULL, max_rows = Inf)
```

## Arguments

- state_uf:

  Character. Two-letter UF code (e.g., `"PE"`). **Required**.

- an_exercicio:

  Integer. Fiscal year. **Required**.

- in_periodicidade:

  Character. `"Q"` (four-monthly) or `"S"` (semi-annual). **Required**.

- nr_periodo:

  Integer. Period number. **Required**.

- co_tipo_demonstrativo:

  Character. `"RGF"` or `"RGF Simplificado"`. **Required**.

- no_anexo:

  Character. Appendix name (e.g., `"RGF-Anexo 01"`). **Required**.

- co_poder:

  Character. Government branch: `"E"`, `"L"`, `"J"`, `"M"`, `"D"`.
  **Required**.

- include_capital:

  Logical. Include the state capital? Defaults to `TRUE`.

- on_error:

  Character. `"warn"` (default), `"stop"`, or `"silent"`.

- use_cache:

  Logical.

- verbose:

  Logical.

- page_size:

  Integer or `NULL`.

- max_rows:

  Numeric.

- fiscal_year:

  Integer. Fiscal year. **Required**. Maps to `an_exercicio`.

- periodicity:

  Character. `"Q"` or `"S"`. **Required**. Maps to `in_periodicidade`.

- period:

  Integer. Period number. **Required**. Maps to `nr_periodo`.

- report_type:

  Character. `"RGF"` or `"RGF Simplificado"`. **Required**. Maps to
  `co_tipo_demonstrativo`.

- appendix:

  Character. Appendix name. **Required**. Maps to `no_anexo`.

- branch:

  Character. Government branch. **Required**. Maps to `co_poder`.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with all
successful RGF rows. If any call failed, has an attribute `"failed"`.

## Details

`get_fiscal_report_for_state()` is an English-parameter alias.

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
[`get_rreo()`](https://strategicprojects.github.io/tesouror/reference/get_rreo.md),
[`get_rreo_for_state()`](https://strategicprojects.github.io/tesouror/reference/get_rreo_for_state.md)

## Examples

``` r
if (FALSE) { # \dontrun{
rgf_pe <- get_rgf_for_state(
  state_uf = "PE", an_exercicio = 2022,
  in_periodicidade = "Q", nr_periodo = 3,
  co_tipo_demonstrativo = "RGF", no_anexo = "RGF-Anexo 01",
  co_poder = "E"
)
} # }
```
