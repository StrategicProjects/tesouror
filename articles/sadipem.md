# SADIPEM API – Public debt & credit operations

## About

The SADIPEM API (`https://apidatalake.tesouro.gov.br/docs/sadipem/`)
provides data on Public Debt Verification Letters (PVL) — the process by
which subnational entities (states and municipalities) request
authorization for credit operations and debt management from the
National Treasury.

## Available functions

| Portuguese                                                                                                                   | English                                                                                                                    | Description                    |
|:-----------------------------------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------|:-------------------------------|
| [`get_pvl()`](https://strategicprojects.github.io/tesouror/reference/get_pvl.md)                                             | [`get_debt_requests()`](https://strategicprojects.github.io/tesouror/reference/get_pvl.md)                                 | Search PVL requests            |
| [`get_pvl_tramitacao()`](https://strategicprojects.github.io/tesouror/reference/get_pvl_tramitacao.md)                       | [`get_pvl_status()`](https://strategicprojects.github.io/tesouror/reference/get_pvl_tramitacao.md)                         | Approved PVL processing status |
| [`get_opc_cronograma_liberacoes()`](https://strategicprojects.github.io/tesouror/reference/get_opc_cronograma_liberacoes.md) | [`get_credit_release_schedule()`](https://strategicprojects.github.io/tesouror/reference/get_opc_cronograma_liberacoes.md) | Credit release schedule        |
| [`get_opc_cronograma_pagamentos()`](https://strategicprojects.github.io/tesouror/reference/get_opc_cronograma_pagamentos.md) | [`get_credit_payment_schedule()`](https://strategicprojects.github.io/tesouror/reference/get_opc_cronograma_pagamentos.md) | Credit payment schedule        |
| [`get_opc_taxa_cambio()`](https://strategicprojects.github.io/tesouror/reference/get_opc_taxa_cambio.md)                     | [`get_credit_exchange_rate()`](https://strategicprojects.github.io/tesouror/reference/get_opc_taxa_cambio.md)              | Exchange rate data             |
| [`get_res_cdp()`](https://strategicprojects.github.io/tesouror/reference/get_res_cdp.md)                                     | [`get_debt_capacity()`](https://strategicprojects.github.io/tesouror/reference/get_res_cdp.md)                             | Debt capacity result (CDP)     |
| [`get_res_cronograma_pagamentos()`](https://strategicprojects.github.io/tesouror/reference/get_res_cronograma_pagamentos.md) | [`get_debt_payment_schedule()`](https://strategicprojects.github.io/tesouror/reference/get_res_cronograma_pagamentos.md)   | Debt payment schedule result   |

## Typical workflow

The usual workflow is to first search for PVL requests, then use the
`id_pleito` value from the results to fetch detailed information.

**Important**: `id_pleito` is a database ID (e.g., `40353`), not a row
number. Use `pvl$id_pleito[1]` to get the value from the first row, not
`pvl$id_pleito[40353]` (which tries to access row 40,353).

``` r
library(tesouror)
library(dplyr)

# Step 1: Search PVLs for Pernambuco
pvl_pe <- get_debt_requests(state = "PE")

# Step 2: Pick an id_pleito VALUE from the results
id <- pvl_pe$id_pleito[1]

# Step 3: Get details using that id_pleito
pagamentos <- get_credit_payment_schedule(request_id = id)
cdp <- get_debt_capacity(request_id = id)
```

### PVL processing status

The
[`get_pvl_status()`](https://strategicprojects.github.io/tesouror/reference/get_pvl_tramitacao.md)
/
[`get_pvl_tramitacao()`](https://strategicprojects.github.io/tesouror/reference/get_pvl_tramitacao.md)
function **only returns data for approved (deferred) non-credit
operation PVLs**. Filter by `status == "Deferido"` first:

``` r
pvl_deferidos <- pvl_pe |> filter(status == "Deferido")
if (nrow(pvl_deferidos) > 0) {
  status <- get_pvl_status(request_id = pvl_deferidos$id_pleito[1])
}
```

## Parameter mapping

### `get_pvl()` / `get_debt_requests()`

| Portuguese         | English       | Description               |
|:-------------------|:--------------|:--------------------------|
| `uf`               | `state`       | State abbreviation        |
| `tipo_interessado` | `entity_type` | Type of requesting entity |
| `id_ente`          | `entity_id`   | IBGE entity code          |

### Detail functions

All detail functions (`get_pvl_tramitacao`, `get_opc_*`, `get_res_*`)
require a single parameter:

| Portuguese  | English      | Description                    |
|:------------|:-------------|:-------------------------------|
| `id_pleito` | `request_id` | Database ID of the PVL request |
