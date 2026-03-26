# Get organizational structure from SIORG

Retrieves the organizational structure tree for a specific SIORG unit,
returning all sub-units (departments, secretariats, etc.) as a flat
tibble.

## Usage

``` r
get_siorg_estrutura(
  codigo_unidade,
  vinculados = NULL,
  use_cache = TRUE,
  verbose = FALSE
)

get_siorg_structure(unit_code, include_linked = NULL,
  use_cache = TRUE, verbose = FALSE)
```

## Arguments

- codigo_unidade:

  Integer or character. SIORG code of the unit. **Required**. Use
  [`get_siorg_orgaos()`](https://strategicprojects.github.io/tesouror/reference/get_siorg_orgaos.md)
  to find codes.

- vinculados:

  Character. Return linked organs/entities? `"SIM"` or `"NAO"`.
  Optional.

- use_cache:

  Logical. If `TRUE` (default), uses an in-memory cache.

- verbose:

  Logical. If `TRUE`, prints the full API URL. Defaults to
  `getOption("tesouror.verbose", FALSE)`.

- unit_code:

  Integer or character. SIORG code. Maps to `codigo_unidade`.

- include_linked:

  Character. `"SIM"` or `"NAO"`. Maps to `vinculados`.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
columns including `codigo_unidade`, `codigo_unidade_pai`, `nome`,
`sigla`, `codigo_tipo_unidade`. Use `codigo_unidade_pai` to navigate the
parent-child hierarchy.

## Details

Use the returned codes as `organizacao_n2` / `org_level2` and
`organizacao_n3` / `org_level3` in CUSTOS API functions.

`get_siorg_structure()` is an English alias.

## See also

Other SIORG:
[`get_siorg_orgaos()`](https://strategicprojects.github.io/tesouror/reference/get_siorg_orgaos.md),
[`get_siorg_unidade()`](https://strategicprojects.github.io/tesouror/reference/get_siorg_unidade.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Get structure of AGU (code 46)
estrutura <- get_siorg_estrutura(codigo_unidade = 46)
} # }
```
