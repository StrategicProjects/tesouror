# Get Fiscal Management Report data (RGF)

Retrieves data from the Fiscal Management Report (RGF) for specific
filtering criteria. The RGF contains information about personnel
expenses, debt, credit operations, and other fiscal indicators.

## Usage

``` r
get_rgf(
  an_exercicio,
  in_periodicidade,
  nr_periodo,
  co_tipo_demonstrativo,
  no_anexo,
  co_esfera,
  co_poder,
  id_ente,
  use_cache = TRUE,
  verbose = FALSE,
  page_size = NULL,
  max_rows = Inf
)

get_fiscal_report(fiscal_year, periodicity, period, report_type,
  appendix, sphere, branch, entity_id, use_cache = TRUE, verbose = FALSE,
  page_size = NULL, max_rows = Inf)
```

## Arguments

- an_exercicio:

  Integer. Fiscal year (e.g., `2022`). **Required**.

- in_periodicidade:

  Character. Periodicity: `"Q"` (four-monthly) or `"S"` (semi-annual).
  **Required**.

- nr_periodo:

  Integer. Period number (1-3 for four-monthly, 1-2 for semi-annual).
  **Required**.

- co_tipo_demonstrativo:

  Character. Report type: `"RGF"` or `"RGF Simplificado"`. **Required**.

- no_anexo:

  Character. Appendix name (e.g., `"RGF-Anexo 01"`). **Required**.

- co_esfera:

  Character. Government sphere: `"M"` (municipalities), `"E"` (states),
  or `"U"` (union). **Required**.

- co_poder:

  Character. Government branch: `"E"` (executive), `"L"` (legislative),
  `"J"` (judiciary), `"M"` (public ministry), `"D"` (public defender).
  **Required**.

- id_ente:

  Integer. IBGE code of the entity. **Required**.

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

- fiscal_year:

  Integer. Fiscal year (e.g., `2022`). **Required**. Maps to
  `an_exercicio`.

- periodicity:

  Character. Periodicity: `"Q"` (quadrimester) or `"S"` (semester).
  **Required**. Maps to `in_periodicidade`.

- period:

  Integer. Period number: `1`-`3` (quadrimester) or `1`-`2` (semester).
  **Required**. Maps to `nr_periodo`.

- report_type:

  Character. Report type: `"RGF"` or `"RGF Simplificado"`. **Required**.
  Maps to `co_tipo_demonstrativo`.

- appendix:

  Character. Appendix name (e.g., `"RGF-Anexo 01"`). **Required**. Maps
  to `no_anexo`.

- sphere:

  Character. Government sphere: `"M"`, `"E"`, or `"U"`. **Required**.
  Maps to `co_esfera`.

- branch:

  Character. Government branch: `"E"` (executive), `"L"` (legislative),
  `"J"` (judiciary), `"M"` (public ministry), `"D"` (public defender).
  **Required**. Maps to `co_poder`.

- entity_id:

  Integer. IBGE code of the entity. **Required**. Maps to `id_ente`.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with RGF
data.

## Details

`get_fiscal_report()` is an English-parameter alias for this function.

## See also

Other SICONFI:
[`get_anexos()`](https://strategicprojects.github.io/tesouror/reference/get_anexos.md),
[`get_dca()`](https://strategicprojects.github.io/tesouror/reference/get_dca.md),
[`get_entes()`](https://strategicprojects.github.io/tesouror/reference/get_entes.md),
[`get_extrato()`](https://strategicprojects.github.io/tesouror/reference/get_extrato.md),
[`get_msc_controle()`](https://strategicprojects.github.io/tesouror/reference/get_msc_controle.md),
[`get_msc_orcamentaria()`](https://strategicprojects.github.io/tesouror/reference/get_msc_orcamentaria.md),
[`get_msc_patrimonial()`](https://strategicprojects.github.io/tesouror/reference/get_msc_patrimonial.md),
[`get_rreo()`](https://strategicprojects.github.io/tesouror/reference/get_rreo.md)

## Examples

``` r
if (FALSE) { # \dontrun{
rgf <- get_rgf(
  an_exercicio = 2022, in_periodicidade = "Q", nr_periodo = 3,
  co_tipo_demonstrativo = "RGF", no_anexo = "RGF-Anexo 01",
  co_esfera = "E", co_poder = "E", id_ente = 17
)
} # }
```
