# SIORG – Organizational Structure

## Overview

The [SIORG API](https://api.siorg.economia.gov.br/) provides the
official organizational structure of the Brazilian Federal Executive
Branch. SIORG codes identify ministries, agencies, departments, and
other organizational units.

**Why it matters for `tesouror`**: The CUSTOS API uses SIORG codes in
the `organizacao_n1`, `organizacao_n2`, and `organizacao_n3` parameters.
The SIORG functions serve as **dictionaries** to look up these codes.

## Looking up organization codes

### Step 1: List top-level organizations (N1)

``` r

library(tesouror)
library(dplyr)

# List all federal executive branch organizations
orgaos <- get_siorg_organizations(power_code = 1, sphere_code = 1)

# Key columns:
#   codigo_unidade     – SIORG code (use as organizacao_n1 in CUSTOS)
#   codigo_unidade_pai – parent unit code
#   nome               – organization name
#   sigla              – abbreviation
#   codigo_tipo_unidade – "orgao" or "entidade"
#   codigo_natureza_juridica – 1=Empresa Pública, 2=Fundação, 3=Adm.Direta, 4=Autarquia

# Find the Ministry of Education
mec <- orgaos |> filter(grepl("Educação", nome), codigo_tipo_unidade == "orgao")
mec |> select(codigo_unidade, nome, sigla)
# codigo_unidade = "244" → this is the org_level1 for CUSTOS
```

### Step 2: Browse sub-units (N2, N3)

The `codigo_unidade_pai` column lets you navigate the hierarchy. Units
whose `codigo_unidade_pai` matches the ministry’s code are direct
children (N2 level). Their children are N3.

``` r

# All organizations under MEC (direct children = N2)
mec_children <- orgaos |>
  filter(codigo_unidade_pai == "244") |>  # MEC's code
  select(codigo_unidade, nome, sigla, codigo_tipo_unidade)
mec_children
# Examples: INEP (249), FNDE (253), CAPES (478), etc.

# For deeper structure, use get_siorg_structure()
estrutura <- get_siorg_structure(unit_code = 244)
estrutura |> select(codigo_unidade, codigo_unidade_pai, nome, sigla)
```

### Step 3: Use in CUSTOS queries

SIORG returns plain codes like `"244"`, but the CUSTOS API expects
zero-padded 6-digit strings like `"000244"`. The package pads
automatically — just pass the SIORG code directly:

``` r

# Active staff costs for MEC — "244" is auto-padded to "000244"
custos_mec <- get_costs_active_staff(
  year = 2023,
  org_level1 = 244  # numeric or character, both work
)

# Drill down to INEP
custos_inep <- get_costs_active_staff(
  year = 2023,
  org_level1 = 244,
  org_level2 = 249  # auto-padded to "000249"
)
```

### Step 4: Get details of a single unit

``` r

# Full details for AGU (code 46)
agu <- get_siorg_unit(unit_code = 46)
agu |> select(codigo_unidade, nome, sigla, codigo_natureza_juridica)
```

## Functions

| Portuguese | English | Description |
|:---|:---|:---|
| [`get_siorg_orgaos()`](https://strategicprojects.github.io/tesouror/reference/get_siorg_orgaos.md) | [`get_siorg_organizations()`](https://strategicprojects.github.io/tesouror/reference/get_siorg_orgaos.md) | List organizations (organs + entities) |
| [`get_siorg_estrutura()`](https://strategicprojects.github.io/tesouror/reference/get_siorg_estrutura.md) | [`get_siorg_structure()`](https://strategicprojects.github.io/tesouror/reference/get_siorg_estrutura.md) | Get organizational structure tree |
| [`get_siorg_unidade()`](https://strategicprojects.github.io/tesouror/reference/get_siorg_unidade.md) | [`get_siorg_unit()`](https://strategicprojects.github.io/tesouror/reference/get_siorg_unidade.md) | Get details of a single unit |

## Parameter mapping

### `get_siorg_orgaos()` / `get_siorg_organizations()`

| Portuguese | English | Description |
|:---|:---|:---|
| `codigo_poder` | `power_code` | `1` = Executive, `2` = Legislative, `3` = Judiciary |
| `codigo_esfera` | `sphere_code` | `1` = Federal, `2` = State, `3` = Municipal |

### `get_siorg_estrutura()` / `get_siorg_structure()`

| Portuguese | English | Description |
|:---|:---|:---|
| `codigo_unidade` | `unit_code` | SIORG code of the unit (required) |
| `vinculados` | `include_linked` | `"SIM"` or `"NAO"` — include linked entities |

## SIORG codes in CUSTOS

The CUSTOS API uses SIORG codes as 6-digit zero-padded strings (e.g.,
`"000244"`). The package auto-pads plain codes, so you can pass `244`,
`"244"`, or `"000244"` — all work.

The CUSTOS response also includes `co_organizacao_n0` (the top-level
authority, e.g., Presidência da República = `"000026"`), which is not a
query parameter but appears in the results.

| CUSTOS parameter | How to find in SIORG | Example |
|:---|:---|:---|
| `organizacao_n1` / `org_level1` | Top-level org: `codigo_unidade` where `codigo_tipo_unidade == "orgao"` | `244` → auto-padded to `"000244"` (MEC) |
| `organizacao_n2` / `org_level2` | Child of N1: `codigo_unidade` where `codigo_unidade_pai == "<N1 code>"` | `249` → `"000249"` (INEP) |
| `organizacao_n3` / `org_level3` | Child of N2: use [`get_siorg_structure()`](https://strategicprojects.github.io/tesouror/reference/get_siorg_estrutura.md) for deeper levels | `40523` → `"040523"` |

## Response columns

Key columns returned by
[`get_siorg_orgaos()`](https://strategicprojects.github.io/tesouror/reference/get_siorg_orgaos.md)
/
[`get_siorg_organizations()`](https://strategicprojects.github.io/tesouror/reference/get_siorg_orgaos.md):

| Column | Description |
|:---|:---|
| `codigo_unidade` | SIORG code (use as `organizacao_n1/n2/n3` in CUSTOS) |
| `codigo_unidade_pai` | Parent unit’s SIORG code (for navigating the hierarchy) |
| `nome` | Full name of the organization |
| `sigla` | Abbreviation (e.g., `"MEC"`, `"INEP"`) |
| `codigo_tipo_unidade` | `"orgao"` or `"entidade"` |
| `codigo_natureza_juridica` | `1` = Empresa Pública, `2` = Fundação, `3` = Adm. Direta, `4` = Autarquia |
| `codigo_esfera` | `1` = Federal, `2` = State/District |
| `codigo_poder` | `1` = Executive, `2` = Legislative, `3` = Judiciary |
