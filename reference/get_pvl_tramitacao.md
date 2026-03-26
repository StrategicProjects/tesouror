# Get PVL processing status (approved non-credit operations)

Retrieves processing status for PVL requests that were **approved
(deferred)** and involve **non-credit operations**. This endpoint only
returns data for PVLs with status `"Deferido"`. For most PVLs (e.g.,
archived, in progress, or credit operations), this will return an empty
tibble.

## Usage

``` r
get_pvl_tramitacao(
  id_pleito,
  use_cache = TRUE,
  verbose = FALSE,
  page_size = NULL,
  max_rows = Inf
)

get_pvl_status(request_id, use_cache = TRUE, verbose = FALSE,
  page_size = NULL, max_rows = Inf)
```

## Arguments

- id_pleito:

  Integer. Database ID of a **deferred** PVL request (from the
  `id_pleito` column of
  [`get_pvl()`](https://strategicprojects.github.io/tesouror/reference/get_pvl.md)).
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

  Integer. Database ID of a **deferred** PVL request. Obtain from the
  `id_pleito` column of
  [`get_pvl()`](https://strategicprojects.github.io/tesouror/reference/get_pvl.md)
  results, filtered by `status == "Deferido"`. **Required**. Maps to
  `id_pleito`.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with PVL
processing status data. Returns an empty tibble if the PVL is not an
approved non-credit operation.

## Details

To find PVLs that have data in this endpoint, filter by
`status == "Deferido"` in the results of
[`get_pvl()`](https://strategicprojects.github.io/tesouror/reference/get_pvl.md).

`get_pvl_status()` is an English alias.

## See also

Other SADIPEM:
[`get_opc_cronograma_liberacoes()`](https://strategicprojects.github.io/tesouror/reference/get_opc_cronograma_liberacoes.md),
[`get_opc_cronograma_pagamentos()`](https://strategicprojects.github.io/tesouror/reference/get_opc_cronograma_pagamentos.md),
[`get_opc_taxa_cambio()`](https://strategicprojects.github.io/tesouror/reference/get_opc_taxa_cambio.md),
[`get_pvl()`](https://strategicprojects.github.io/tesouror/reference/get_pvl.md),
[`get_res_cdp()`](https://strategicprojects.github.io/tesouror/reference/get_res_cdp.md),
[`get_res_cronograma_pagamentos()`](https://strategicprojects.github.io/tesouror/reference/get_res_cronograma_pagamentos.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Step 1: search PVLs and filter for approved ones
pvl_pe <- get_pvl(uf = "PE")
pvl_deferidos <- pvl_pe[pvl_pe$status == "Deferido", ]

# Step 2: pick an id_pleito from the APPROVED requests
id <- pvl_deferidos$id_pleito[1]

# Step 3: get processing status (only works for deferred PVLs)
status <- get_pvl_tramitacao(id_pleito = id)
} # }
```
