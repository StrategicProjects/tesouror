# Get constitutional transfers by state

Retrieves constitutional transfer data aggregated by state.

## Usage

``` r
get_tc_por_estados(
  p_estado = NULL,
  p_ano = NULL,
  p_mes = NULL,
  p_transferencia = NULL,
  p_sn_detalhar = NULL,
  use_cache = TRUE,
  verbose = FALSE
)

get_tc_by_state(state_code = NULL, year = NULL, month = NULL,
  transfer_type = NULL, detailed = NULL, use_cache = TRUE, verbose = FALSE)
```

## Arguments

- p_estado:

  State code(s) from
  [`get_tc_estados()`](https://strategicprojects.github.io/tesouror/reference/get_tc_estados.md).
  Accepts a vector or a colon-separated string. Optional.

- p_ano:

  Year(s). Accepts a vector or colon-separated string. Optional.

- p_mes:

  Month(s) (1-12). Accepts a vector or colon-separated string. Optional.

- p_transferencia:

  Transfer type code(s) from
  [`get_tc_transferencias()`](https://strategicprojects.github.io/tesouror/reference/get_tc_transferencias.md).
  Accepts a vector or colon-separated string. Optional.

- p_sn_detalhar:

  Character. Set to any value to include detailed breakdown. Omit for
  summary. Optional.

- use_cache:

  Logical. If `TRUE` (default), uses an in-memory cache.

- verbose:

  Logical. If `TRUE`, prints the full API URL being called. Useful for
  debugging or testing in a browser. Defaults to
  `getOption("tesouror.verbose", FALSE)`.

- state_code:

  State code(s) from
  [`get_tc_estados()`](https://strategicprojects.github.io/tesouror/reference/get_tc_estados.md).
  Accepts a vector (e.g., `c(1, 2)`) or colon-separated string
  (`"1:2"`). These are **Treasury codes**, not IBGE codes. Optional.
  Maps to `p_estado`.

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

  Character. Set to any value to include a detailed breakdown. Omit for
  summary. Optional. Maps to `p_sn_detalhar`.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
transfer data by state.

## Details

All codes are **internal Treasury codes** (not IBGE). Use the dictionary
functions to look them up:
[`get_tc_estados()`](https://strategicprojects.github.io/tesouror/reference/get_tc_estados.md)
for state codes and
[`get_tc_transferencias()`](https://strategicprojects.github.io/tesouror/reference/get_tc_transferencias.md)
for transfer type codes.

Multi-value parameters accept either a colon-separated string
(`"1:2:3"`) or an R vector (`c(1, 2, 3)`).

`get_tc_by_state()` is an English alias.

## See also

Other Transferencias:
[`get_tc_estados()`](https://strategicprojects.github.io/tesouror/reference/get_tc_estados.md),
[`get_tc_municipios()`](https://strategicprojects.github.io/tesouror/reference/get_tc_municipios.md),
[`get_tc_por_estados_detalhe()`](https://strategicprojects.github.io/tesouror/reference/get_tc_por_estados_detalhe.md),
[`get_tc_por_municipio()`](https://strategicprojects.github.io/tesouror/reference/get_tc_por_municipio.md),
[`get_tc_por_municipio_detalhe()`](https://strategicprojects.github.io/tesouror/reference/get_tc_por_municipio_detalhe.md),
[`get_tc_transferencias()`](https://strategicprojects.github.io/tesouror/reference/get_tc_transferencias.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Step 1: look up codes (Treasury codes, NOT IBGE)
estados <- get_tc_estados()
tipos   <- get_tc_transferencias()

pe_code <- estados$codigo[estados$nome == "Pernambuco"]

# Step 2: query (pass a vector or colon-separated string)
tc_pe <- get_tc_por_estados(p_estado = pe_code, p_ano = 2023)
tc_multi <- get_tc_por_estados(
  p_estado = c(1, 2), p_ano = 2023, p_mes = c(1, 2)
)
} # }
```
