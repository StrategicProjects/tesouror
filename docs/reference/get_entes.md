# Get list of Brazilian government entities

Retrieves the complete list of government entities (entes) registered in
the SICONFI system, including states, municipalities, and the Federal
District.

## Usage

``` r
get_entes(use_cache = TRUE, verbose = FALSE, page_size = NULL, max_rows = Inf)

get_entities(use_cache = TRUE, verbose = FALSE,
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

- cod_ibge:

  IBGE code of the entity.

- ente:

  Name of the entity.

- capital:

  Whether the municipality is a state capital (1 = yes, 0 = no).

- regiao:

  Geographic region (`"SU"`, `"NE"`, `"NO"`, `"SE"`, `"CO"`, `"BR"`).

- uf:

  State abbreviation.

- esfera:

  Government sphere: `"M"`, `"E"`, `"U"`, `"D"`.

- an_exercicio:

  Year of the population data.

- populacao:

  Estimated population.

- co_cnpj:

  CNPJ of the entity.

## Details

`get_entities()` is an English alias for `get_entes()`.

## See also

Other SICONFI:
[`get_anexos()`](https://strategicprojects.github.io/tesouror/reference/get_anexos.md),
[`get_dca()`](https://strategicprojects.github.io/tesouror/reference/get_dca.md),
[`get_extrato()`](https://strategicprojects.github.io/tesouror/reference/get_extrato.md),
[`get_msc_controle()`](https://strategicprojects.github.io/tesouror/reference/get_msc_controle.md),
[`get_msc_orcamentaria()`](https://strategicprojects.github.io/tesouror/reference/get_msc_orcamentaria.md),
[`get_msc_patrimonial()`](https://strategicprojects.github.io/tesouror/reference/get_msc_patrimonial.md),
[`get_rgf()`](https://strategicprojects.github.io/tesouror/reference/get_rgf.md),
[`get_rreo()`](https://strategicprojects.github.io/tesouror/reference/get_rreo.md)

## Examples

``` r
if (FALSE) { # \dontrun{
entes <- get_entes()
} # }
```
