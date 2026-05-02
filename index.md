# tesouror

**tesouror** provides a unified R interface to the Brazilian National
Treasury (Tesouro Nacional) open data APIs. It covers five major data
sources:

| API | Data | Functions |
|:---|:---|:---|
| **SICONFI** | Fiscal reports (RREO, RGF, DCA, MSC), entities | [`get_rreo()`](https://strategicprojects.github.io/tesouror/reference/get_rreo.md), [`get_rgf()`](https://strategicprojects.github.io/tesouror/reference/get_rgf.md), [`get_dca()`](https://strategicprojects.github.io/tesouror/reference/get_dca.md), … |
| **CUSTOS** | Federal government costs | [`get_custos_pessoal_ativo()`](https://strategicprojects.github.io/tesouror/reference/get_custos_pessoal_ativo.md), … |
| **SADIPEM** | Public debt & credit operations (PVL) | [`get_pvl()`](https://strategicprojects.github.io/tesouror/reference/get_pvl.md), `get_opc_*()`, `get_res_*()` |
| **SIORG** | Federal organizational structure (dictionary for CUSTOS) | [`get_siorg_orgaos()`](https://strategicprojects.github.io/tesouror/reference/get_siorg_orgaos.md), [`get_siorg_estrutura()`](https://strategicprojects.github.io/tesouror/reference/get_siorg_estrutura.md) |
| **Transferências** | Constitutional transfers to states/municipalities | `get_tc_*()` |
| **SIOPE** | Education spending (FNDE/MEC) | [`get_siope_dados_gerais()`](https://strategicprojects.github.io/tesouror/reference/get_siope_dados_gerais.md), [`get_siope_despesas()`](https://strategicprojects.github.io/tesouror/reference/get_siope_despesas.md), … |

All functions return tidy tibbles and have both **Portuguese** (matching
API parameter names) and **English** aliases.

[TABLE]

## Installation

``` r

# From CRAN (when available):
install.packages("tesouror")

# Development version:
# remotes::install_github("StrategicProjects/tesouror")
```

## Quick start

``` r

library(tesouror)

# List government entities
entes <- get_entes()

# RREO for Tocantins
rreo <- get_budget_report(
  fiscal_year = 2022, period = 6, report_type = "RREO",
  appendix = "RREO-Anexo 01", sphere = "E", entity_id = 17
)

# Federal government active staff costs (always filter by org!)
custos <- get_costs_active_staff(
  year = 2023, org_level1 = 244, org_level2 = 249  # MEC > INEP
)

# Constitutional transfers (codes are Treasury-internal, NOT IBGE!)
estados <- get_tc_states()
pe <- estados$codigo[estados$nome == "Pernambuco"]
tc <- get_tc_by_state(state_code = pe, year = 2023)

# Public debt requests for PE
pvl <- get_debt_requests(state = "PE")

# SIORG: look up organization codes for CUSTOS queries
orgaos <- get_siorg_organizations(power_code = 1, sphere_code = 1)
# Use orgaos$codigo_unidade as org_level1 in get_costs_active_staff()

# SIOPE: education spending data
indicadores <- get_siope_indicators(year = 2023, period = 6, state = "PE")

# Clear the cache if needed
tesouror_clear_cache()
```

## Features

- **Bilingual**: Portuguese and English function/parameter names
- **Caching**: In-memory cache avoids repeated API calls
- **Pagination**: Automatic handling of multi-page responses with
  progress
- **`verbose` mode**: Print full API URLs for debugging
  (`verbose = TRUE` or `options(tesouror.verbose = TRUE)`)
- **`page_size` control**: Tune rows per page for speed vs. stability
- **Clean output**:
  [`janitor::clean_names()`](https://sfirke.github.io/janitor/reference/clean_names.html)
  ensures consistent snake_case columns
- **Friendly errors**: Retries with informative messages; NA validation
  on required params
- **Tidy output**: All results are tibbles

## Migrating from siconfir

`tesouror` is a superset of `siconfir`. All SICONFI functions work
exactly the same. The cache-clearing function is now
[`tesouror_clear_cache()`](https://strategicprojects.github.io/tesouror/reference/tesouror_clear_cache.md):

``` r

tesouror_clear_cache()
```

## Documentation

See the package website at
<https://strategicprojects.github.io/tesouror/> for full documentation
and vignettes.

## Architecture

![tesouror package architecture — 6 APIs, 80
functions](reference/figures/architecture.svg)

## API Reference

### SICONFI — Fiscal Reports

    https://apidatalake.tesouro.gov.br/ords/siconfi/tt/

Provides fiscal reports (RREO, RGF, DCA), accounting matrices (MSC), and
a government entity registry. Maintained by STN (Secretaria do Tesouro
Nacional).

| Detail            | Value                                         |
|:------------------|:----------------------------------------------|
| Pagination        | ORDS (`hasMore`/`offset`), automatic          |
| Default page size | Server default (5,000 rows)                   |
| Retries           | 5 attempts, progressive backoff (3s, 6s, 9s…) |
| `max_rows`        | Supported                                     |
| Functions         | 18 (9 PT + 9 EN)                              |

### CUSTOS — Federal Government Costs

    https://apidatalake.tesouro.gov.br/ords/custos/tt/

Cost data for active/retired staff, pensioners, depreciation, transfers,
and other costs. Broken down by organization hierarchy (SIORG codes) and
demographics.

| Detail | Value |
|:---|:---|
| Pagination | ORDS (`hasMore`/`offset`), automatic |
| Default page size | **1,000 rows** (server default of 250 is too slow; 5,000 causes timeouts) |
| Retries | 5 attempts, progressive backoff (3s, 6s, 9s…) |
| `max_rows` | Supported |
| SIORG code padding | Automatic (`244` → `"000244"`) |
| Functions | 12 (6 PT + 6 EN) |

> **Warning**: The CUSTOS API is slow. Always filter by
> `organizacao_n1` + `organizacao_n2` (or `org_level1` + `org_level2`)
> to avoid downloading hundreds of thousands of rows. Use `max_rows` for
> quick tests.

### SADIPEM — Public Debt

    https://apidatalake.tesouro.gov.br/ords/sadipem/tt/

Public debt verification letters (PVL), credit operations, payment
schedules, exchange rates, and debt capacity results.

| Detail            | Value                                |
|:------------------|:-------------------------------------|
| Pagination        | ORDS (`hasMore`/`offset`), automatic |
| Default page size | Server default (5,000 rows)          |
| Retries           | 5 attempts, progressive backoff      |
| `max_rows`        | Supported                            |
| Functions         | 14 (7 PT + 7 EN)                     |

### Transferências Constitucionais

    https://apiapex.tesouro.gov.br/aria/v1/transferencias_constitucionais/custom/

Constitutional transfers (FPE, FPM, FUNDEB, etc.) to states and
municipalities. Uses Treasury-internal codes (**not** IBGE codes) — use
the dictionary functions to look them up.

| Detail | Value |
|:---|:---|
| Pagination | None (single response) |
| Retries | 5 attempts, progressive backoff |
| Multi-value params | Accepts vectors (`c(1,2)`) or colon-separated strings (`"1:2"`) |
| Functions | 14 (7 PT + 7 EN) |

### SIORG — Organizational Structure

    https://estruturaorganizacional.dados.gov.br/

Federal organizational structure: ministries, autarchies, foundations,
and their internal hierarchy. Used as a dictionary to look up SIORG
codes for CUSTOS API queries.

| Detail     | Value                              |
|:-----------|:-----------------------------------|
| Pagination | None (single response, JSON-based) |
| Retries    | 5 attempts, progressive backoff    |
| Functions  | 6 (3 PT + 3 EN)                    |

### SIOPE — Education Spending

    https://www.fnde.gov.br/olinda-ide/servico/DADOS_ABERTOS_SIOPE/versao/v1/odata/

Education spending data from FNDE/MEC: revenues, expenses, indicators,
staff compensation, and declaration officials. Uses an OData-style API.

| Detail | Value |
|:---|:---|
| Pagination | OData (`$top`/`$skip`), automatic |
| Default page size | **1,000 rows** |
| Retries | 5 attempts, progressive backoff |
| `max_rows` | Supported |
| `filter` | OData `$filter` for server-side filtering (e.g., `"NOM_MUNI eq 'Recife'"`) |
| `orderby` | OData `$orderby` for server-side sorting |
| `select` | OData `$select` to choose specific columns |
| Functions | 16 (8 PT + 8 EN) |

> **Tip**: Use `filter` to narrow results on the server before
> downloading. Column names in `filter`/`select`/`orderby` must use the
> **original API names** (uppercase). Run a `max_rows = 1` query and
> `toupper(names(result))` to discover valid column names.

### Common features (all APIs)

| Feature | Details |
|:---|:---|
| **Caching** | In-memory per session. Clear with [`tesouror_clear_cache()`](https://strategicprojects.github.io/tesouror/reference/tesouror_clear_cache.md). |
| **Retries** | 5 attempts with progressive backoff (3s, 6s, 9s, 12s, 15s) on HTTP 500/502/503/504/429 and connection failures. HTTP 400/404 are **not** retried. |
| **`verbose` mode** | Per-call (`verbose = TRUE`) or global (`options(tesouror.verbose = TRUE)`). Prints full API URL for every request. |
| **Column cleaning** | [`janitor::clean_names()`](https://sfirke.github.io/janitor/reference/clean_names.html) applied to all responses (consistent snake_case). |
| **Bilingual** | Every function has Portuguese (API-native) and English-named aliases. |
| **Output** | Tidy tibbles with whitespace trimming. |
| **Error messages** | Friendly, actionable messages with URL and hints. HTTP 400 errors suggest checking column names. |

## License

MIT
