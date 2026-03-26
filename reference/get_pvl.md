# Get public debt verification requests (PVL)

Retrieves data from the Public Debt Verification Letters (PVL) system.
These are requests for approval of credit operations and debt by
subnational entities. Use the resulting `id_pleito` column to query
detail functions like
[`get_pvl_tramitacao()`](https://strategicprojects.github.io/tesouror/reference/get_pvl_tramitacao.md),
[`get_opc_cronograma_liberacoes()`](https://strategicprojects.github.io/tesouror/reference/get_opc_cronograma_liberacoes.md),
etc.

## Usage

``` r
get_pvl(
  uf = NULL,
  tipo_interessado = NULL,
  id_ente = NULL,
  use_cache = TRUE,
  verbose = FALSE,
  page_size = NULL,
  max_rows = Inf
)

get_debt_requests(state = NULL, entity_type = NULL,
  entity_id = NULL, use_cache = TRUE, verbose = FALSE,
  page_size = NULL, max_rows = Inf)
```

## Arguments

- uf:

  Character. State abbreviation (e.g., `"PE"`). Optional.

- tipo_interessado:

  Character. Type of requesting entity (e.g., `"Município"`,
  `"Estado"`). Optional.

- id_ente:

  Integer. IBGE code of the requesting entity. Optional.

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

- state:

  Character. State abbreviation (e.g., `"PE"`). Optional. Maps to `uf`.

- entity_type:

  Character. Type of requesting entity (e.g., `"Município"`,
  `"Estado"`). Optional. Maps to `tipo_interessado`.

- entity_id:

  Integer. IBGE code of the requesting entity. Optional. Maps to
  `id_ente`.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with PVL
data including `id_pleito`, `tipo_interessado`, `interessado`,
`cod_ibge`, `uf`, `status`, `tipo_operacao`, `finalidade`, `credor`,
`valor`, and more.

## Details

`get_debt_requests()` is an English alias.

## See also

Other SADIPEM:
[`get_opc_cronograma_liberacoes()`](https://strategicprojects.github.io/tesouror/reference/get_opc_cronograma_liberacoes.md),
[`get_opc_cronograma_pagamentos()`](https://strategicprojects.github.io/tesouror/reference/get_opc_cronograma_pagamentos.md),
[`get_opc_taxa_cambio()`](https://strategicprojects.github.io/tesouror/reference/get_opc_taxa_cambio.md),
[`get_pvl_tramitacao()`](https://strategicprojects.github.io/tesouror/reference/get_pvl_tramitacao.md),
[`get_res_cdp()`](https://strategicprojects.github.io/tesouror/reference/get_res_cdp.md),
[`get_res_cronograma_pagamentos()`](https://strategicprojects.github.io/tesouror/reference/get_res_cronograma_pagamentos.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Search all PVLs for Pernambuco
pvl_pe <- get_pvl(uf = "PE")

# Search by IBGE code (Recife)
pvl_recife <- get_pvl(id_ente = 2611606)

# Use id_pleito from results for detail queries:
id <- pvl_pe$id_pleito[1]
pagamentos <- get_opc_cronograma_pagamentos(id_pleito = id)
cdp <- get_res_cdp(id_pleito = id)

# For PVL processing status, filter approved PVLs first:
deferidos <- pvl_pe[pvl_pe$status == "Deferido", ]
if (nrow(deferidos) > 0) {
  status <- get_pvl_tramitacao(id_pleito = deferidos$id_pleito[1])
}
} # }
```
