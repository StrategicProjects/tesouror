# Get details of a single SIORG unit

Retrieves summary data for a single organizational unit by its SIORG
code. Returns a single-row tibble with the unit's details.

## Usage

``` r
get_siorg_unidade(codigo_unidade, use_cache = TRUE, verbose = FALSE)

get_siorg_unit(unit_code, use_cache = TRUE, verbose = FALSE)
```

## Arguments

- codigo_unidade:

  Integer or character. SIORG code. **Required**.

- use_cache:

  Logical. If `TRUE` (default), uses an in-memory cache.

- verbose:

  Logical. If `TRUE`, prints the full API URL. Defaults to
  `getOption("tesouror.verbose", FALSE)`.

- unit_code:

  Integer or character. SIORG code. Maps to `codigo_unidade`.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) (single
row) with unit details including `codigo_unidade`, `nome`, `sigla`,
`codigo_tipo_unidade`, `codigo_unidade_pai`, `codigo_natureza_juridica`,
and more.

## Details

`get_siorg_unit()` is an English alias.

## See also

Other SIORG:
[`get_siorg_estrutura()`](https://strategicprojects.github.io/tesouror/reference/get_siorg_estrutura.md),
[`get_siorg_orgaos()`](https://strategicprojects.github.io/tesouror/reference/get_siorg_orgaos.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Get details for AGU (code 46)
agu <- get_siorg_unidade(codigo_unidade = 46)
} # }
```
