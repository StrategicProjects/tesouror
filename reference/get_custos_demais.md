# Get other cost data

Retrieves other (non-personnel) cost data for federal government
organizations. All parameters are optional filters.

## Usage

``` r
get_custos_demais(
  ano = NULL,
  mes = NULL,
  natureza_juridica = NULL,
  organizacao_n1 = NULL,
  organizacao_n2 = NULL,
  organizacao_n3 = NULL,
  use_cache = TRUE,
  verbose = FALSE,
  page_size = 1000L,
  max_rows = Inf
)

get_costs_other(year = NULL, month = NULL,
  legal_nature = NULL, org_level1 = NULL, org_level2 = NULL,
  org_level3 = NULL, use_cache = TRUE, verbose = FALSE,
  page_size = 1000, max_rows = Inf)
```

## Arguments

- ano:

  Integer. Year of the record. Optional.

- mes:

  Integer. Month of the record (1-12). Optional.

- natureza_juridica:

  Integer. Legal nature of the organization: `1` (Public Company), `2`
  (Public Foundation), `3` (Direct Administration), `4` (Autarchy), `6`
  (Mixed Economy Company). Optional.

- organizacao_n1:

  Character or integer. SIORG code for the top-level organization
  (Ministry level). Use
  [`get_siorg_orgaos()`](https://strategicprojects.github.io/tesouror/reference/get_siorg_orgaos.md)
  to look up codes. You can pass plain codes (e.g., `244`) — they are
  automatically zero-padded to the 6-digit format the API expects
  (`"000244"`). Optional.

- organizacao_n2:

  Character or integer. SIORG code for the second-level organization.
  Use
  [`get_siorg_estrutura()`](https://strategicprojects.github.io/tesouror/reference/get_siorg_estrutura.md)
  to browse sub-units. Automatically zero-padded. Optional.

- organizacao_n3:

  Character or integer. SIORG code for the third-level organization. Use
  [`get_siorg_estrutura()`](https://strategicprojects.github.io/tesouror/reference/get_siorg_estrutura.md)
  to browse sub-units. Automatically zero-padded. Optional.

- use_cache:

  Logical. If `TRUE` (default), uses an in-memory cache.

- verbose:

  Logical. If `TRUE`, prints the full API URL being called. Useful for
  debugging or testing in a browser. Defaults to `FALSE`.

- page_size:

  Integer. Number of rows per API page. Defaults to `1000` (the server
  default of 250 is too slow; 5000 may cause timeouts). Adjust as
  needed.

- max_rows:

  Numeric. Maximum number of rows to return. Defaults to `Inf` (all
  rows). Useful for quick tests with large datasets (e.g.,
  `max_rows = 100`).

- year:

  Integer. Year of the record. Optional. Maps to `ano`.

- month:

  Integer. Month of the record (1-12). Optional. Maps to `mes`.

- legal_nature:

  Integer. Legal nature of the organization: `1` (Public Company), `2`
  (Public Foundation), `3` (Direct Administration), `4` (Autarchy), `6`
  (Mixed Economy Company). Optional. Maps to `natureza_juridica`.

- org_level1:

  Character or integer. SIORG code for the top-level organization
  (Ministry level). Use
  [`get_siorg_organizations()`](https://strategicprojects.github.io/tesouror/reference/get_siorg_orgaos.md)
  to look up codes. Plain codes (e.g., `244`) are auto-padded to
  `"000244"`. Optional. Maps to `organizacao_n1`.

- org_level2:

  Character or integer. SIORG code (second level). Use
  [`get_siorg_structure()`](https://strategicprojects.github.io/tesouror/reference/get_siorg_estrutura.md)
  to browse sub-units. Auto-padded. Optional. Maps to `organizacao_n2`.

- org_level3:

  Character or integer. SIORG code (third level). Use
  [`get_siorg_structure()`](https://strategicprojects.github.io/tesouror/reference/get_siorg_estrutura.md)
  to browse sub-units. Auto-padded. Optional. Maps to `organizacao_n3`.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
other cost data.

## Details

`get_costs_other()` is an English alias.

## See also

Other CUSTOS:
[`get_custos_depreciacao()`](https://strategicprojects.github.io/tesouror/reference/get_custos_depreciacao.md),
[`get_custos_pensionistas()`](https://strategicprojects.github.io/tesouror/reference/get_custos_pensionistas.md),
[`get_custos_pessoal_ativo()`](https://strategicprojects.github.io/tesouror/reference/get_custos_pessoal_ativo.md),
[`get_custos_pessoal_inativo()`](https://strategicprojects.github.io/tesouror/reference/get_custos_pessoal_inativo.md),
[`get_custos_transferencias()`](https://strategicprojects.github.io/tesouror/reference/get_custos_transferencias.md)

## Examples

``` r
if (FALSE) { # \dontrun{
demais <- get_custos_demais(
  ano = 2023, mes = 6,
  organizacao_n1 = 244,  # MEC
  organizacao_n2 = 249   # INEP
)
} # }
```
