# Transferências Constitucionais API

## About

The Transferências Constitucionais API provides data on constitutional
transfers from the Federal Government to states and municipalities.
These transfers include FPE (Fundo de Participação dos Estados), FPM
(Fundo de Participação dos Municípios), FUNDEB, and other mandatory
transfers.

Base URL:
`https://apiapex.tesouro.gov.br/aria/v1/transferencias_constitucionais/custom`

## Available functions

All functions use the `get_tc_` prefix. All filter parameters use
**numeric codes**, not names or abbreviations. Use the lookup functions
(`get_tc_transferencias`, `get_tc_estados`, `get_tc_municipios`) to
obtain the codes. Multiple values are separated by colons (`:`) — e.g.,
`p_estado = "1:2"` for Acre and Alagoas.

| Portuguese                                                                                                                 | English                                                                                                                     | Description                        |
|:---------------------------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------|:-----------------------------------|
| [`get_tc_transferencias()`](https://strategicprojects.github.io/tesouror/reference/get_tc_transferencias.md)               | [`get_tc_transfer_types()`](https://strategicprojects.github.io/tesouror/reference/get_tc_transferencias.md)                | List transfer types and codes      |
| [`get_tc_estados()`](https://strategicprojects.github.io/tesouror/reference/get_tc_estados.md)                             | [`get_tc_states()`](https://strategicprojects.github.io/tesouror/reference/get_tc_estados.md)                               | List states and codes              |
| [`get_tc_municipios()`](https://strategicprojects.github.io/tesouror/reference/get_tc_municipios.md)                       | [`get_tc_municipalities()`](https://strategicprojects.github.io/tesouror/reference/get_tc_municipios.md)                    | Search municipalities              |
| [`get_tc_por_estados()`](https://strategicprojects.github.io/tesouror/reference/get_tc_por_estados.md)                     | [`get_tc_by_state()`](https://strategicprojects.github.io/tesouror/reference/get_tc_por_estados.md)                         | Transfers by state                 |
| [`get_tc_por_estados_detalhe()`](https://strategicprojects.github.io/tesouror/reference/get_tc_por_estados_detalhe.md)     | [`get_tc_by_state_detail()`](https://strategicprojects.github.io/tesouror/reference/get_tc_por_estados_detalhe.md)          | Detailed transfers by state        |
| [`get_tc_por_municipio()`](https://strategicprojects.github.io/tesouror/reference/get_tc_por_municipio.md)                 | [`get_tc_by_municipality()`](https://strategicprojects.github.io/tesouror/reference/get_tc_por_municipio.md)                | Transfers by municipality          |
| [`get_tc_por_municipio_detalhe()`](https://strategicprojects.github.io/tesouror/reference/get_tc_por_municipio_detalhe.md) | [`get_tc_by_municipality_detail()`](https://strategicprojects.github.io/tesouror/reference/get_tc_por_municipio_detalhe.md) | Detailed transfers by municipality |

## Examples

### Step 1: Lookup codes

All filter parameters use numeric codes internal to this API (they are
**not** IBGE codes). Always look up codes first.

``` r
library(tesouror)

# Transfer types — returns codigo + nome
tipos <- get_tc_transfer_types()
tipos
# e.g., codigo=10 nome="FUNDEB", codigo=14 nome="AJUSTE FUNDEB"

# State codes — returns codigo + nome
estados <- get_tc_states()
estados
# e.g., codigo=16 nome="Pernambuco" (NOT the IBGE code!)

# Municipality codes — filter by the state code from above
pe_code <- estados$codigo[estados$nome == "Pernambuco"]
mun_pe <- get_tc_municipalities(state_code = pe_code)
mun_pe
```

### State-level transfers

``` r
# Use the state code obtained from get_tc_states()
pe_code <- estados$codigo[estados$nome == "Pernambuco"]

# All transfers for Pernambuco in 2023
tc_pe <- get_tc_by_state(state_code = pe_code, year = 2023)

# FUNDEB + AJUSTE FUNDEB — pass a vector of transfer type codes
tc_fundeb <- get_tc_by_state(
  state_code = pe_code,
  year = 2023,
  transfer_type = c(10, 14)
)

# Multiple states, Jan-Mar 2023 — vectors work everywhere
ac_code <- estados$codigo[estados$nome == "Acre"]
al_code <- estados$codigo[estados$nome == "Alagoas"]
tc_multi <- get_tc_by_state(
  state_code = c(ac_code, al_code),
  year = 2023,
  month = 1:3
)

# Same query with detailed breakdown
tc_det <- get_tc_by_state_detail(
  state_code = c(ac_code, al_code),
  year = 2023,
  month = 1:3
)
```

### Municipality-level transfers

``` r
# Look up municipality codes
pe_code <- estados$codigo[estados$nome == "Pernambuco"]
mun_pe <- get_tc_municipalities(state_code = pe_code)
recife_code <- mun_pe$codigo[mun_pe$nome == "Recife"]

# All municipalities in Pernambuco in 2023
tc_mun <- get_tc_by_municipality(state_code = pe_code, year = 2023)

# Specific municipality: Recife
tc_recife <- get_tc_by_municipality_detail(
  state_code = pe_code,
  municipality = recife_code,
  year = 2023
)
```

## Parameter mapping

| Portuguese        | English         | Description                                                                                                                                            |
|:------------------|:----------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------|
| `p_estado`        | `state_code`    | Numeric state code(s) from [`get_tc_estados()`](https://strategicprojects.github.io/tesouror/reference/get_tc_estados.md) (Treasury code, NOT IBGE)    |
| `p_municipio`     | `municipality`  | Numeric municipality code(s) from [`get_tc_municipios()`](https://strategicprojects.github.io/tesouror/reference/get_tc_municipios.md) (Treasury code) |
| `p_ano`           | `year`          | Year(s)                                                                                                                                                |
| `p_mes`           | `month`         | Month(s)                                                                                                                                               |
| `p_transferencia` | `transfer_type` | Transfer type code(s) from [`get_tc_transferencias()`](https://strategicprojects.github.io/tesouror/reference/get_tc_transferencias.md)                |
| `p_sn_detalhar`   | `detailed`      | Include detail breakdown                                                                                                                               |
| `p_nome`          | `name`          | Municipality name search (partial match)                                                                                                               |
| `p_uf`            | `state_code`    | Numeric state code from [`get_tc_estados()`](https://strategicprojects.github.io/tesouror/reference/get_tc_estados.md) (for municipality lookup)       |

All multi-value parameters accept either a colon-separated string
(`"1:2:3"`) or an R vector (`c(1, 2, 3)`).
