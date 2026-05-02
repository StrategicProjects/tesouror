# Get MSC equity/asset accounts data

Retrieves equity and asset accounts data (classes 1 to 4) from the
Accounting Balances Matrix (MSC).

## Usage

``` r
get_msc_patrimonial(
  id_ente,
  an_referencia,
  me_referencia,
  co_tipo_matriz,
  classe_conta,
  id_tv,
  use_cache = TRUE,
  verbose = FALSE,
  page_size = NULL,
  max_rows = Inf
)

get_msc_equity(entity_id, year, month, matrix_type, account_class,
  value_type, use_cache = TRUE, verbose = FALSE,
  page_size = NULL, max_rows = Inf)
```

## Arguments

- id_ente:

  Integer. IBGE code of the entity. **Required**.

- an_referencia:

  Integer. Reference year. **Required**.

- me_referencia:

  Integer. Reference month (1-12). **Required**.

- co_tipo_matriz:

  Character. Matrix type: `"MSCC"` (monthly aggregate) or `"MSCE"`
  (annual closing). **Required**.

- classe_conta:

  Integer. Account class: `1`, `2`, `3`, or `4`. **Required**.

- id_tv:

  Character. Value type: `"beginning_balance"`, `"ending_balance"`, or
  `"period_change"`. **Required**.

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

  Integer. Reference year. **Required**. Maps to `an_referencia`.

- month:

  Integer. Reference month (1-12). **Required**. Maps to
  `me_referencia`.

- matrix_type:

  Character. Matrix type: `"MSCC"` (monthly aggregate) or `"MSCE"`
  (annual closing). **Required**. Maps to `co_tipo_matriz`.

- account_class:

  Integer. Account class: `1`, `2`, `3`, or `4`. **Required**. Maps to
  `classe_conta`.

- value_type:

  Character. Value type: `"beginning_balance"`, `"ending_balance"`, or
  `"period_change"`. **Required**. Maps to `id_tv`.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with MSC
equity/asset account data.

## Details

`get_msc_equity()` is an English alias for `get_msc_patrimonial()`.

## See also

Other SICONFI:
[`get_anexos()`](https://strategicprojects.github.io/tesouror/reference/get_anexos.md),
[`get_dca()`](https://strategicprojects.github.io/tesouror/reference/get_dca.md),
[`get_dca_for_state()`](https://strategicprojects.github.io/tesouror/reference/get_dca_for_state.md),
[`get_entes()`](https://strategicprojects.github.io/tesouror/reference/get_entes.md),
[`get_extrato()`](https://strategicprojects.github.io/tesouror/reference/get_extrato.md),
[`get_msc_controle()`](https://strategicprojects.github.io/tesouror/reference/get_msc_controle.md),
[`get_msc_orcamentaria()`](https://strategicprojects.github.io/tesouror/reference/get_msc_orcamentaria.md),
[`get_rgf()`](https://strategicprojects.github.io/tesouror/reference/get_rgf.md),
[`get_rgf_for_state()`](https://strategicprojects.github.io/tesouror/reference/get_rgf_for_state.md),
[`get_rreo()`](https://strategicprojects.github.io/tesouror/reference/get_rreo.md),
[`get_rreo_for_state()`](https://strategicprojects.github.io/tesouror/reference/get_rreo_for_state.md)

## Examples

``` r
if (FALSE) { # \dontrun{
msc_pat <- get_msc_patrimonial(
  id_ente = 17, an_referencia = 2022, me_referencia = 12,
  co_tipo_matriz = "MSCC", classe_conta = 1,
  id_tv = "ending_balance"
)
} # }
```
