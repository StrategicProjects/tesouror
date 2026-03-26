# Get report appendix reference table

Retrieves the reference table of report appendices (anexos) grouped by
government sphere. This is a support table that describes which
appendices are available for each report type (RREO, RGF, DCA, etc.).

## Usage

``` r
get_anexos(use_cache = TRUE, verbose = FALSE, page_size = NULL, max_rows = Inf)

get_annexes(use_cache = TRUE, verbose = FALSE,
  page_size = NULL, max_rows = Inf)
```

## Arguments

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

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
columns:

- esfera:

  Government sphere: `"U"` (Union), `"E"` (States), `"M"`
  (Municipalities).

- demonstrativo:

  Report type (e.g., `"RREO"`, `"RGF"`, `"DCA"`).

- anexo:

  Appendix name (e.g., `"RREO-Anexo 01"`).

## Details

`get_annexes()` is an English alias for `get_anexos()`.

## See also

Other SICONFI:
[`get_dca()`](https://strategicprojects.github.io/tesouror/reference/get_dca.md),
[`get_entes()`](https://strategicprojects.github.io/tesouror/reference/get_entes.md),
[`get_extrato()`](https://strategicprojects.github.io/tesouror/reference/get_extrato.md),
[`get_msc_controle()`](https://strategicprojects.github.io/tesouror/reference/get_msc_controle.md),
[`get_msc_orcamentaria()`](https://strategicprojects.github.io/tesouror/reference/get_msc_orcamentaria.md),
[`get_msc_patrimonial()`](https://strategicprojects.github.io/tesouror/reference/get_msc_patrimonial.md),
[`get_rgf()`](https://strategicprojects.github.io/tesouror/reference/get_rgf.md),
[`get_rreo()`](https://strategicprojects.github.io/tesouror/reference/get_rreo.md)

## Examples

``` r
if (FALSE) { # \dontrun{
anexos <- get_anexos()
} # }
```
