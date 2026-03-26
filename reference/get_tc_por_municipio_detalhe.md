# Get detailed constitutional transfers by municipality

Retrieves detailed constitutional transfer data by municipality.

## Usage

``` r
get_tc_por_municipio_detalhe(
  p_estado = NULL,
  p_municipio = NULL,
  p_ano = NULL,
  p_mes = NULL,
  p_transferencia = NULL,
  use_cache = TRUE,
  verbose = FALSE
)

get_tc_by_municipality_detail(state_code = NULL,
  municipality = NULL, year = NULL, month = NULL,
  transfer_type = NULL, use_cache = TRUE, verbose = FALSE)
```

## Arguments

- p_estado:

  State code(s) from
  [`get_tc_estados()`](https://strategicprojects.github.io/tesouror/reference/get_tc_estados.md).
  Accepts a vector or colon-separated string. Optional.

- p_municipio:

  Municipality code(s) from
  [`get_tc_municipios()`](https://strategicprojects.github.io/tesouror/reference/get_tc_municipios.md).
  Accepts a vector or colon-separated string. Optional.

- p_ano:

  Year(s). Accepts a vector or colon-separated string. Optional.

- p_mes:

  Month(s). Accepts a vector or colon-separated string. Optional.

- p_transferencia:

  Transfer type code(s) from
  [`get_tc_transferencias()`](https://strategicprojects.github.io/tesouror/reference/get_tc_transferencias.md).
  Accepts a vector or colon-separated string. Optional.

- use_cache:

  Logical. If `TRUE` (default), uses an in-memory cache.

- verbose:

  Logical. If `TRUE`, prints the full API URL being called. Useful for
  debugging or testing in a browser. Defaults to
  `getOption("tesouror.verbose", FALSE)`.

- state_code:

  State code(s) from
  [`get_tc_estados()`](https://strategicprojects.github.io/tesouror/reference/get_tc_estados.md).
  Accepts a vector or colon-separated string. **Treasury codes**, not
  IBGE. Optional. Maps to `p_estado`.

- municipality:

  Municipality code(s) from
  [`get_tc_municipios()`](https://strategicprojects.github.io/tesouror/reference/get_tc_municipios.md).
  Accepts a vector or colon-separated string. **Treasury codes**.
  Optional. Maps to `p_municipio`.

- year:

  Year(s). Accepts a vector or colon-separated string. Optional. Maps to
  `p_ano`.

- month:

  Month(s) (1-12). Accepts a vector or colon-separated string. Optional.
  Maps to `p_mes`.

- transfer_type:

  Transfer type code(s) from
  [`get_tc_transferencias()`](https://strategicprojects.github.io/tesouror/reference/get_tc_transferencias.md).
  Accepts a vector or colon-separated string. Optional. Maps to
  `p_transferencia`.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
detailed municipality transfer data.

## Details

All codes are **internal Treasury codes** (not IBGE). See
[`get_tc_estados()`](https://strategicprojects.github.io/tesouror/reference/get_tc_estados.md),
[`get_tc_municipios()`](https://strategicprojects.github.io/tesouror/reference/get_tc_municipios.md),
and
[`get_tc_transferencias()`](https://strategicprojects.github.io/tesouror/reference/get_tc_transferencias.md)
for dictionaries.

`get_tc_by_municipality_detail()` is an English alias.

## See also

Other Transferencias:
[`get_tc_estados()`](https://strategicprojects.github.io/tesouror/reference/get_tc_estados.md),
[`get_tc_municipios()`](https://strategicprojects.github.io/tesouror/reference/get_tc_municipios.md),
[`get_tc_por_estados()`](https://strategicprojects.github.io/tesouror/reference/get_tc_por_estados.md),
[`get_tc_por_estados_detalhe()`](https://strategicprojects.github.io/tesouror/reference/get_tc_por_estados_detalhe.md),
[`get_tc_por_municipio()`](https://strategicprojects.github.io/tesouror/reference/get_tc_por_municipio.md),
[`get_tc_transferencias()`](https://strategicprojects.github.io/tesouror/reference/get_tc_transferencias.md)

## Examples

``` r
if (FALSE) { # \dontrun{
estados <- get_tc_estados()
pe_code <- estados$codigo[estados$nome == "Pernambuco"]
det <- get_tc_por_municipio_detalhe(p_estado = pe_code, p_ano = 2023)
} # }
```
