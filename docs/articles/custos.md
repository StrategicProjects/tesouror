# CUSTOS API – Federal government costs

## About

The CUSTOS API (`https://apidatalake.tesouro.gov.br/docs/custos/`)
provides cost data from the Federal Government Cost Portal (Portal de
Custos do Governo Federal). It breaks down costs into six categories:
active staff, retired staff, pensioners, depreciation, transfers, and
other costs.

All parameters in this API are **optional** — you can call any function
without arguments to retrieve the full dataset.

## Performance warning

> **The CUSTOS API is slow.** Its server default is only 250 rows per
> page (the package increases this to 1000), but unfiltered queries can
> still return hundreds of thousands of rows across many pages, with
> frequent HTTP 504 timeouts. **Always filter your queries** by at
> least:
>
> - `year` + `month` (reduce time range)
> - `org_level1` + `org_level2` (reduce to a specific organization)
> - `legal_nature` (reduce to a legal nature category)
> - `max_rows` (set a hard cap for testing)
>
> The package retries automatically on 504 errors (up to 5 times with
> progressive backoff), but narrower filters prevent them in the first
> place.

## Available functions

| Portuguese | English | Description |
|:---|:---|:---|
| [`get_custos_pessoal_ativo()`](https://strategicprojects.github.io/tesouror/reference/get_custos_pessoal_ativo.md) | [`get_costs_active_staff()`](https://strategicprojects.github.io/tesouror/reference/get_custos_pessoal_ativo.md) | Active staff costs |
| [`get_custos_pessoal_inativo()`](https://strategicprojects.github.io/tesouror/reference/get_custos_pessoal_inativo.md) | [`get_costs_retired_staff()`](https://strategicprojects.github.io/tesouror/reference/get_custos_pessoal_inativo.md) | Retired staff costs |
| [`get_custos_pensionistas()`](https://strategicprojects.github.io/tesouror/reference/get_custos_pensionistas.md) | [`get_costs_pensioners()`](https://strategicprojects.github.io/tesouror/reference/get_custos_pensionistas.md) | Pensioner costs |
| [`get_custos_demais()`](https://strategicprojects.github.io/tesouror/reference/get_custos_demais.md) | [`get_costs_other()`](https://strategicprojects.github.io/tesouror/reference/get_custos_demais.md) | Other costs |
| [`get_custos_depreciacao()`](https://strategicprojects.github.io/tesouror/reference/get_custos_depreciacao.md) | [`get_costs_depreciation()`](https://strategicprojects.github.io/tesouror/reference/get_custos_depreciacao.md) | Depreciation costs |
| [`get_custos_transferencias()`](https://strategicprojects.github.io/tesouror/reference/get_custos_transferencias.md) | [`get_costs_transfers()`](https://strategicprojects.github.io/tesouror/reference/get_custos_transferencias.md) | Transfer costs |

## Parameter mapping

All six functions share the same optional filters:

| Portuguese (API) | English | Description |
|:---|:---|:---|
| `ano` | `year` | Year of the record |
| `mes` | `month` | Month (1-12) |
| `natureza_juridica` | `legal_nature` | Legal nature: 1=Public Company, 2=Foundation, 3=Direct Admin, 4=Autarchy, 6=Mixed Economy |
| `organizacao_n1` | `org_level1` | Top-level SIORG code (Ministry). See [`get_siorg_orgaos()`](https://strategicprojects.github.io/tesouror/reference/get_siorg_orgaos.md). Auto-padded. |
| `organizacao_n2` | `org_level2` | Second-level SIORG code. See [`get_siorg_estrutura()`](https://strategicprojects.github.io/tesouror/reference/get_siorg_estrutura.md). Auto-padded. |
| `organizacao_n3` | `org_level3` | Third-level SIORG code. See [`get_siorg_estrutura()`](https://strategicprojects.github.io/tesouror/reference/get_siorg_estrutura.md). Auto-padded. |

SIORG codes are automatically zero-padded: you can pass `244`, `"244"`,
or `"000244"` — all produce the same query.

## Examples

``` r

library(tesouror)
library(dplyr)

# Step 1: Look up SIORG codes for the organization you want
orgaos <- get_siorg_organizations(power_code = 1, sphere_code = 1)
mec <- orgaos |> filter(sigla == "MEC")          # code 244
inep <- orgaos |> filter(sigla == "INEP")         # code 249

# Step 2: Query CUSTOS with org filters (much faster than unfiltered!)
# Active staff costs for INEP, all months of 2023
ativos_inep <- get_costs_active_staff(
  year = 2023,
  org_level1 = 244,     # MEC — auto-padded to "000244"
  org_level2 = 249      # INEP — auto-padded to "000249"
)

# Pensioner costs for INEP, June 2023 only
pensionistas_inep <- get_costs_pensioners(
  year = 2023, month = 6,
  org_level1 = 244,
  org_level2 = 249
)

# Quick test: just grab the first 100 rows
sample <- get_costs_active_staff(
  year = 2023, month = 6,
  legal_nature = 3,
  max_rows = 100
)
```

### Response columns

The CUSTOS API returns organization hierarchy down to 6 levels:

| Column | Description |
|:---|:---|
| `co_organizacao_n0` / `ds_organizacao_n0` | Top authority (e.g., Presidência) |
| `co_organizacao_n1` / `ds_organizacao_n1` | Ministry level |
| `co_organizacao_n2` / `ds_organizacao_n2` | Entity/secretariat |
| `co_organizacao_n3` / `ds_organizacao_n3` | Department |
| `co_organizacao_n4` to `n6` | Deeper sub-units (`"-9"` = not applicable) |
| `an_lanc` / `me_lanc` | Year and month of the accounting entry |
| `ds_area_atuacao` | Area: `"FINALISTICA"` or `"SUPORTE"` |
| `ds_escolaridade` | Education level of the staff member |
| `ds_faixa_etaria` | Age range |
| `in_sexo` | Sex: `"F"` or `"M"` |
| `in_forca_trabalho` | Workforce count |
| `va_custo_de_pessoal` | Cost value (R\$) |
