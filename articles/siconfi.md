# SICONFI API – Fiscal data

## About

The SICONFI API (`https://apidatalake.tesouro.gov.br/docs/siconfi/`)
provides fiscal data for all Brazilian states, municipalities, and the
Federal District. It includes budget execution reports (RREO), fiscal
management reports (RGF), annual accounts declarations (DCA), and
accounting balances matrices (MSC).

## Available functions

| Portuguese                                                                                                 | English                                                                                              | Description                          |
|:-----------------------------------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------|:-------------------------------------|
| [`get_entes()`](https://strategicprojects.github.io/tesouror/reference/get_entes.md)                       | [`get_entities()`](https://strategicprojects.github.io/tesouror/reference/get_entes.md)              | List of government entities          |
| [`get_anexos()`](https://strategicprojects.github.io/tesouror/reference/get_anexos.md)                     | [`get_annexes()`](https://strategicprojects.github.io/tesouror/reference/get_anexos.md)              | Report appendix reference table      |
| [`get_dca()`](https://strategicprojects.github.io/tesouror/reference/get_dca.md)                           | [`get_annual_accounts()`](https://strategicprojects.github.io/tesouror/reference/get_dca.md)         | Annual accounts (DCA)                |
| [`get_extrato()`](https://strategicprojects.github.io/tesouror/reference/get_extrato.md)                   | [`get_delivery_status()`](https://strategicprojects.github.io/tesouror/reference/get_extrato.md)     | Report delivery status               |
| [`get_rreo()`](https://strategicprojects.github.io/tesouror/reference/get_rreo.md)                         | [`get_budget_report()`](https://strategicprojects.github.io/tesouror/reference/get_rreo.md)          | Budget execution report (RREO)       |
| [`get_rgf()`](https://strategicprojects.github.io/tesouror/reference/get_rgf.md)                           | [`get_fiscal_report()`](https://strategicprojects.github.io/tesouror/reference/get_rgf.md)           | Fiscal management report (RGF)       |
| [`get_msc_patrimonial()`](https://strategicprojects.github.io/tesouror/reference/get_msc_patrimonial.md)   | [`get_msc_equity()`](https://strategicprojects.github.io/tesouror/reference/get_msc_patrimonial.md)  | MSC equity accounts (classes 1-4)    |
| [`get_msc_orcamentaria()`](https://strategicprojects.github.io/tesouror/reference/get_msc_orcamentaria.md) | [`get_msc_budget()`](https://strategicprojects.github.io/tesouror/reference/get_msc_orcamentaria.md) | MSC budgetary accounts (classes 5-6) |
| [`get_msc_controle()`](https://strategicprojects.github.io/tesouror/reference/get_msc_controle.md)         | [`get_msc_control()`](https://strategicprojects.github.io/tesouror/reference/get_msc_controle.md)    | MSC control accounts (classes 7-8)   |

## Parameter mapping

| Portuguese (API)        | English         | Description                 |
|:------------------------|:----------------|:----------------------------|
| `an_exercicio`          | `fiscal_year`   | Fiscal year                 |
| `id_ente`               | `entity_id`     | IBGE entity code            |
| `no_anexo`              | `appendix`      | Report appendix name        |
| `an_referencia`         | `year`          | Reference year              |
| `me_referencia`         | `month`         | Reference month             |
| `nr_periodo`            | `period`        | Period number               |
| `co_tipo_demonstrativo` | `report_type`   | Report type                 |
| `co_esfera`             | `sphere`        | Government sphere (M/E/U)   |
| `co_poder`              | `branch`        | Government branch           |
| `in_periodicidade`      | `periodicity`   | Periodicity (Q/S)           |
| `co_tipo_matriz`        | `matrix_type`   | MSC matrix type (MSCC/MSCE) |
| `classe_conta`          | `account_class` | Account class               |
| `id_tv`                 | `value_type`    | Value type                  |

## Examples

### Entity lookup

``` r
library(tesouror)
library(dplyr)

# All entities
entes <- get_entes()

# Filter states only
estados <- entes |> filter(esfera == "E")
```

### RREO – Budget Execution

``` r
# RREO Anexo 01 for Tocantins, 6th bimester of 2022
rreo <- get_budget_report(
  fiscal_year = 2022, period = 6,
  report_type = "RREO",
  appendix = "RREO-Anexo 01",
  sphere = "E", entity_id = 17
)
```

### RGF – Fiscal Management

``` r
# RGF Anexo 01 for the executive branch of Tocantins
rgf <- get_fiscal_report(
  fiscal_year = 2022, periodicity = "Q", period = 3,
  report_type = "RGF", appendix = "RGF-Anexo 01",
  sphere = "E", branch = "E", entity_id = 17
)
```

### DCA – Annual Accounts

``` r
dca <- get_annual_accounts(fiscal_year = 2022, entity_id = 17)
```

### MSC – Accounting Balances Matrix

``` r
# Equity accounts (class 1) for December 2022
msc <- get_msc_equity(
  entity_id = 17, year = 2022, month = 12,
  matrix_type = "MSCC", account_class = 1,
  value_type = "ending_balance"
)
```
