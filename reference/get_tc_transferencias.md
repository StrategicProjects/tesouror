# Get transfer type dictionary

Retrieves the dictionary of constitutional transfer types and their
numeric codes. Use these codes in the `p_transferencia` /
`transfer_type` parameter of other functions.

## Usage

``` r
get_tc_transferencias(use_cache = TRUE, verbose = FALSE)

get_tc_transfer_types(use_cache = TRUE, verbose = FALSE)
```

## Arguments

- use_cache:

  Logical. If `TRUE` (default), uses an in-memory cache.

- verbose:

  Logical. If `TRUE`, prints the full API URL being called. Useful for
  debugging or testing in a browser. Defaults to
  `getOption("tesouror.verbose", FALSE)`.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
columns `codigo` (code) and `nome` (name) of each transfer type.

## Details

These are **internal Treasury codes**, not IBGE codes.

`get_tc_transfer_types()` is an English alias.

## See also

Other Transferencias:
[`get_tc_estados()`](https://strategicprojects.github.io/tesouror/reference/get_tc_estados.md),
[`get_tc_municipios()`](https://strategicprojects.github.io/tesouror/reference/get_tc_municipios.md),
[`get_tc_por_estados()`](https://strategicprojects.github.io/tesouror/reference/get_tc_por_estados.md),
[`get_tc_por_estados_detalhe()`](https://strategicprojects.github.io/tesouror/reference/get_tc_por_estados_detalhe.md),
[`get_tc_por_municipio()`](https://strategicprojects.github.io/tesouror/reference/get_tc_por_municipio.md),
[`get_tc_por_municipio_detalhe()`](https://strategicprojects.github.io/tesouror/reference/get_tc_por_municipio_detalhe.md)

Other Transferencias dictionaries:
[`get_tc_estados()`](https://strategicprojects.github.io/tesouror/reference/get_tc_estados.md),
[`get_tc_municipios()`](https://strategicprojects.github.io/tesouror/reference/get_tc_municipios.md)

## Examples

``` r
if (FALSE) { # \dontrun{
tipos <- get_tc_transferencias()
# Use tipos$codigo as values for p_transferencia in other functions
} # }
```
