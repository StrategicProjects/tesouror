# Get DCA data for all municipalities of a Brazilian state

Fetches annual accounts (DCA) for every municipality of `state_uf`,
looping over
[`get_dca_ufs()`](https://strategicprojects.github.io/tesouror/reference/get_dca_ufs.md)
with fault tolerance. See
[`get_rreo_municipios()`](https://strategicprojects.github.io/tesouror/reference/get_rreo_municipios.md)
for the rationale and behaviour of `on_error`.

## Usage

``` r
get_dca_municipios(
  state_uf,
  an_exercicio,
  no_anexo = NULL,
  include_capital = TRUE,
  on_error = c("warn", "stop", "silent"),
  use_cache = TRUE,
  verbose = FALSE,
  page_size = NULL,
  max_rows = Inf
)

get_annual_accounts_municipalities(state_uf, fiscal_year, appendix = NULL,
  include_capital = TRUE, on_error = c("warn", "stop", "silent"),
  use_cache = TRUE, verbose = FALSE,
  page_size = NULL, max_rows = Inf)
```

## Arguments

- state_uf:

  Character. Two-letter UF code (e.g., `"PE"`). **Required**.

- an_exercicio:

  Integer. Fiscal year. **Required**.

- no_anexo:

  Character. Appendix name filter (e.g., `"DCA-Anexo I-AB"`). Optional.

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

- appendix:

  Character. Appendix name filter. Optional. Maps to `no_anexo`.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with all
successful DCA rows. If any call failed, has an attribute `"failed"`.

## Details

`get_annual_accounts_municipalities()` is an English-parameter alias.

Renamed in 0.3.0 from
[`get_dca_for_state()`](https://strategicprojects.github.io/tesouror/reference/tesouror-deprecated.md)
for clarity. The old name still works but is deprecated.

## See also

Other SICONFI:
[`get_anexos()`](https://strategicprojects.github.io/tesouror/reference/get_anexos.md),
[`get_dca_ufs()`](https://strategicprojects.github.io/tesouror/reference/get_dca_ufs.md),
[`get_entes()`](https://strategicprojects.github.io/tesouror/reference/get_entes.md),
[`get_extrato()`](https://strategicprojects.github.io/tesouror/reference/get_extrato.md),
[`get_msc_controle()`](https://strategicprojects.github.io/tesouror/reference/get_msc_controle.md),
[`get_msc_orcamentaria()`](https://strategicprojects.github.io/tesouror/reference/get_msc_orcamentaria.md),
[`get_msc_patrimonial()`](https://strategicprojects.github.io/tesouror/reference/get_msc_patrimonial.md),
[`get_rgf_municipios()`](https://strategicprojects.github.io/tesouror/reference/get_rgf_municipios.md),
[`get_rgf_ufs()`](https://strategicprojects.github.io/tesouror/reference/get_rgf_ufs.md),
[`get_rreo_municipios()`](https://strategicprojects.github.io/tesouror/reference/get_rreo_municipios.md),
[`get_rreo_ufs()`](https://strategicprojects.github.io/tesouror/reference/get_rreo_ufs.md)

## Examples

``` r
if (FALSE) { # \dontrun{
dca_pe <- get_dca_municipios(state_uf = "PE", an_exercicio = 2022)
} # }
```
