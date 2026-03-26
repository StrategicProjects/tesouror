# Get credit operation exchange rate data

Retrieves exchange rate data for credit operations linked to a PVL
request. The `id_pleito` can be obtained from
[`get_pvl()`](https://strategicprojects.github.io/tesouror/reference/get_pvl.md).

## Usage

``` r
get_opc_taxa_cambio(
  id_pleito,
  use_cache = TRUE,
  verbose = FALSE,
  page_size = NULL,
  max_rows = Inf
)

get_credit_exchange_rate(request_id, use_cache = TRUE, verbose = FALSE,
  page_size = NULL, max_rows = Inf)
```

## Arguments

- id_pleito:

  Integer. Database ID from
  [`get_pvl()`](https://strategicprojects.github.io/tesouror/reference/get_pvl.md).
  **Required**.

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

- request_id:

  Integer. Database ID of the PVL request. Obtain from the `id_pleito`
  column of
  [`get_pvl()`](https://strategicprojects.github.io/tesouror/reference/get_pvl.md)
  results. **Required**. Maps to `id_pleito`.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
exchange rate data.

## Details

`get_credit_exchange_rate()` is an English alias.

## See also

Other SADIPEM:
[`get_opc_cronograma_liberacoes()`](https://strategicprojects.github.io/tesouror/reference/get_opc_cronograma_liberacoes.md),
[`get_opc_cronograma_pagamentos()`](https://strategicprojects.github.io/tesouror/reference/get_opc_cronograma_pagamentos.md),
[`get_pvl()`](https://strategicprojects.github.io/tesouror/reference/get_pvl.md),
[`get_pvl_tramitacao()`](https://strategicprojects.github.io/tesouror/reference/get_pvl_tramitacao.md),
[`get_res_cdp()`](https://strategicprojects.github.io/tesouror/reference/get_res_cdp.md),
[`get_res_cronograma_pagamentos()`](https://strategicprojects.github.io/tesouror/reference/get_res_cronograma_pagamentos.md)

## Examples

``` r
if (FALSE) { # \dontrun{
cambio <- get_opc_taxa_cambio(id_pleito = 40353)
} # }
```
