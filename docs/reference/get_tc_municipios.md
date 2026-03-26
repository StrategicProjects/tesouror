# Get municipality dictionary

Retrieves the dictionary of municipalities and their numeric codes. Use
these codes in the `p_municipio` / `municipality` parameter of other
functions.

## Usage

``` r
get_tc_municipios(
  p_nome = NULL,
  p_uf = NULL,
  use_cache = TRUE,
  verbose = FALSE
)

get_tc_municipalities(name = NULL, state_code = NULL,
  use_cache = TRUE, verbose = FALSE)
```

## Arguments

- p_nome:

  Character. Partial municipality name for searching (e.g., `"Recife"`).
  Optional.

- p_uf:

  Numeric or character. State code from
  [`get_tc_estados()`](https://strategicprojects.github.io/tesouror/reference/get_tc_estados.md).
  **Not** a state abbreviation or IBGE code. Optional.

- use_cache:

  Logical. If `TRUE` (default), uses an in-memory cache.

- verbose:

  Logical. If `TRUE`, prints the full API URL being called. Useful for
  debugging or testing in a browser. Defaults to
  `getOption("tesouror.verbose", FALSE)`.

- name:

  Character. Partial municipality name for searching (e.g., `"Recife"`).
  Optional. Maps to `p_nome`.

- state_code:

  Numeric or character. State code from
  [`get_tc_estados()`](https://strategicprojects.github.io/tesouror/reference/get_tc_estados.md).
  **Not** a state abbreviation or IBGE code. Optional. Maps to `p_uf`.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
municipality data including `codigo`, `codigo_uf`, and `nome`.

## Details

These are **internal Treasury codes**, not IBGE codes. Filter by state
using the numeric code from
[`get_tc_estados()`](https://strategicprojects.github.io/tesouror/reference/get_tc_estados.md).

`get_tc_municipalities()` is an English alias.

## See also

Other Transferencias:
[`get_tc_estados()`](https://strategicprojects.github.io/tesouror/reference/get_tc_estados.md),
[`get_tc_por_estados()`](https://strategicprojects.github.io/tesouror/reference/get_tc_por_estados.md),
[`get_tc_por_estados_detalhe()`](https://strategicprojects.github.io/tesouror/reference/get_tc_por_estados_detalhe.md),
[`get_tc_por_municipio()`](https://strategicprojects.github.io/tesouror/reference/get_tc_por_municipio.md),
[`get_tc_por_municipio_detalhe()`](https://strategicprojects.github.io/tesouror/reference/get_tc_por_municipio_detalhe.md),
[`get_tc_transferencias()`](https://strategicprojects.github.io/tesouror/reference/get_tc_transferencias.md)

Other Transferencias dictionaries:
[`get_tc_estados()`](https://strategicprojects.github.io/tesouror/reference/get_tc_estados.md),
[`get_tc_transferencias()`](https://strategicprojects.github.io/tesouror/reference/get_tc_transferencias.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Step 1: find the state code (Treasury code, NOT IBGE)
estados <- get_tc_estados()
pe_code <- estados$codigo[estados$nome == "Pernambuco"]

# Step 2: list municipalities for that state
municipios <- get_tc_municipios(p_uf = pe_code)

# Or search by partial name
recife <- get_tc_municipios(p_nome = "Recife")
} # }
```
