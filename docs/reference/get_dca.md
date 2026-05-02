# Get annual accounts data (DCA)

Retrieves data from the Annual Accounts Declaration (DCA) or the legacy
QDCC for a specific entity and fiscal year.

## Usage

``` r
get_dca(
  an_exercicio,
  id_ente,
  no_anexo = NULL,
  use_cache = TRUE,
  verbose = FALSE,
  page_size = NULL,
  max_rows = Inf
)

get_annual_accounts(fiscal_year, entity_id, appendix = NULL,
  use_cache = TRUE, verbose = FALSE,
  page_size = NULL, max_rows = Inf)
```

## Arguments

- an_exercicio:

  Integer. Fiscal year (e.g., `2022`). **Required**.

- id_ente:

  Integer. IBGE code of the entity. **Required**.

- no_anexo:

  Character. Appendix name filter (e.g., `"DCA-Anexo I-AB"`). Optional.

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

- entity_id:

  Integer. IBGE code of the entity. **Required**. Maps to `id_ente`.

- appendix:

  Character. Appendix name filter (e.g., `"DCA-Anexo I-AB"`). Optional.
  Maps to `no_anexo`.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
DCA/QDCC data including columns such as `exercicio`, `instituicao`,
`cod_ibge`, `uf`, `anexo`, `rotulo`, `coluna`, `cod_conta`, `conta`,
`valor`, and `populacao`.

## Details

`get_annual_accounts()` is an English alias for `get_dca()`.

## See also

Other SICONFI:
[`get_anexos()`](https://strategicprojects.github.io/tesouror/reference/get_anexos.md),
[`get_dca_for_state()`](https://strategicprojects.github.io/tesouror/reference/get_dca_for_state.md),
[`get_entes()`](https://strategicprojects.github.io/tesouror/reference/get_entes.md),
[`get_extrato()`](https://strategicprojects.github.io/tesouror/reference/get_extrato.md),
[`get_msc_controle()`](https://strategicprojects.github.io/tesouror/reference/get_msc_controle.md),
[`get_msc_orcamentaria()`](https://strategicprojects.github.io/tesouror/reference/get_msc_orcamentaria.md),
[`get_msc_patrimonial()`](https://strategicprojects.github.io/tesouror/reference/get_msc_patrimonial.md),
[`get_rgf()`](https://strategicprojects.github.io/tesouror/reference/get_rgf.md),
[`get_rgf_for_state()`](https://strategicprojects.github.io/tesouror/reference/get_rgf_for_state.md),
[`get_rreo()`](https://strategicprojects.github.io/tesouror/reference/get_rreo.md),
[`get_rreo_for_state()`](https://strategicprojects.github.io/tesouror/reference/get_rreo_for_state.md)

## Examples

``` r
if (FALSE) { # \dontrun{
dca <- get_dca(an_exercicio = 2022, id_ente = 17)
} # }
```
