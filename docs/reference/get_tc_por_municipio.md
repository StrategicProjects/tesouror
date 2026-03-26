# Get constitutional transfers by municipality

Retrieves constitutional transfer data for municipalities within states.

## Usage

``` r
get_tc_por_municipio(
  p_estado = NULL,
  p_municipio = NULL,
  p_ano = NULL,
  p_mes = NULL,
  p_transferencia = NULL,
  p_sn_detalhar = NULL,
  use_cache = TRUE,
  verbose = FALSE
)

get_tc_by_municipality(state_code = NULL, municipality = NULL,
  year = NULL, month = NULL, transfer_type = NULL, detailed = NULL,
  use_cache = TRUE, verbose = FALSE)
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

- p_sn_detalhar:

  Character. Set to any value to include detailed breakdown. Optional.

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

- detailed:

  Character. Set to any value to include detail. Optional. Maps to
  `p_sn_detalhar`.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
transfer data by municipality.

## Details

All codes are **internal Treasury codes** (not IBGE). Use the dictionary
functions to look them up:
[`get_tc_estados()`](https://strategicprojects.github.io/tesouror/reference/get_tc_estados.md)
for state codes,
[`get_tc_municipios()`](https://strategicprojects.github.io/tesouror/reference/get_tc_municipios.md)
for municipality codes, and
[`get_tc_transferencias()`](https://strategicprojects.github.io/tesouror/reference/get_tc_transferencias.md)
for transfer type codes.

Multi-value parameters accept either a colon-separated string
(`"1:2:3"`) or an R vector (`c(1, 2, 3)`).

`get_tc_by_municipality()` is an English alias.

## See also

Other Transferencias:
[`get_tc_estados()`](https://strategicprojects.github.io/tesouror/reference/get_tc_estados.md),
[`get_tc_municipios()`](https://strategicprojects.github.io/tesouror/reference/get_tc_municipios.md),
[`get_tc_por_estados()`](https://strategicprojects.github.io/tesouror/reference/get_tc_por_estados.md),
[`get_tc_por_estados_detalhe()`](https://strategicprojects.github.io/tesouror/reference/get_tc_por_estados_detalhe.md),
[`get_tc_por_municipio_detalhe()`](https://strategicprojects.github.io/tesouror/reference/get_tc_por_municipio_detalhe.md),
[`get_tc_transferencias()`](https://strategicprojects.github.io/tesouror/reference/get_tc_transferencias.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Step 1: look up codes (Treasury codes, NOT IBGE)
estados <- get_tc_estados()
pe_code <- estados$codigo[estados$nome == "Pernambuco"]
municipios <- get_tc_municipios(p_uf = pe_code)
recife_code <- municipios$codigo[municipios$nome == "Recife"]

# Step 2: query (pass vector or string)
tc <- get_tc_por_municipio(
  p_estado = pe_code,
  p_municipio = recife_code,
  p_ano = 2023
)
} # }
```
