# Get delivery status extract

Retrieves the extract of report deliveries for a given entity and
reference year. Useful for checking which reports have been submitted
and their status (approved, rectified, etc.).

## Usage

``` r
get_extrato(
  id_ente,
  an_referencia,
  use_cache = TRUE,
  verbose = FALSE,
  page_size = NULL,
  max_rows = Inf
)

get_delivery_status(entity_id, year, use_cache = TRUE, verbose = FALSE,
  page_size = NULL, max_rows = Inf)
```

## Arguments

- id_ente:

  Integer. IBGE code of the entity. **Required**.

- an_referencia:

  Integer. Reference year (e.g., `2022`). **Required**.

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

- entity_id:

  Integer. IBGE code of the entity. **Required**. Maps to `id_ente`.

- year:

  Integer. Reference year (e.g., `2022`). **Required**. Maps to
  `an_referencia`.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
delivery status data including columns such as `exercicio`, `cod_ibge`,
`instituicao`, `entregavel`, `periodo`, `periodicidade`,
`status_relatorio`, `data_status`, `forma_envio`, and `tipo_relatorio`.

## Details

`get_delivery_status()` is an English alias for `get_extrato()`.

## See also

Other SICONFI:
[`get_anexos()`](https://strategicprojects.github.io/tesouror/reference/get_anexos.md),
[`get_dca()`](https://strategicprojects.github.io/tesouror/reference/get_dca.md),
[`get_entes()`](https://strategicprojects.github.io/tesouror/reference/get_entes.md),
[`get_msc_controle()`](https://strategicprojects.github.io/tesouror/reference/get_msc_controle.md),
[`get_msc_orcamentaria()`](https://strategicprojects.github.io/tesouror/reference/get_msc_orcamentaria.md),
[`get_msc_patrimonial()`](https://strategicprojects.github.io/tesouror/reference/get_msc_patrimonial.md),
[`get_rgf()`](https://strategicprojects.github.io/tesouror/reference/get_rgf.md),
[`get_rreo()`](https://strategicprojects.github.io/tesouror/reference/get_rreo.md)

## Examples

``` r
if (FALSE) { # \dontrun{
extrato <- get_extrato(id_ente = 17, an_referencia = 2022)
} # }
```
