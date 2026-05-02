# Normalize the `coluna` field of a RREO tibble across years

SICONFI's RREO column labels drift over years: the same conceptual
column appears as `"DESPESAS LIQUIDADAS ATÉ O BIMESTRE / 2019"` in 2019,
`"DESPESAS LIQUIDADAS ATÉ O BIMESTRE"` (no year) in 2021-2022, and
`"DESPESAS LIQUIDADAS ATÉ O BIMESTRE / 2023"` in 2023+. This helper adds
two columns:

## Usage

``` r
rreo_normalize_columns(data)
```

## Arguments

- data:

  A tibble returned by
  [`get_rreo()`](https://strategicprojects.github.io/tesouror/reference/get_rreo.md)
  or
  [`get_rreo_for_state()`](https://strategicprojects.github.io/tesouror/reference/get_rreo_for_state.md).
  Must contain a `coluna` column.

## Value

The input tibble with `coluna_padrao` and `coluna_ano` appended.

## Details

- `coluna_padrao`: the column label with any trailing `"/ YYYY"` or
  `"EM YYYY"` suffix removed (whitespace squished).

- `coluna_ano`: the year that appeared in the suffix (integer), or `NA`
  when no year was present. Useful for distinguishing the current-year
  column from a comparative previous-year column.

## See also

Other RREO tidy:
[`rreo_layout()`](https://strategicprojects.github.io/tesouror/reference/rreo_layout.md),
[`tidy_rreo()`](https://strategicprojects.github.io/tesouror/reference/tidy_rreo.md)

## Examples

``` r
demo <- tibble::tibble(
  coluna = c(
    "DESPESAS LIQUIDADAS ATÉ O BIMESTRE / 2023",
    "DESPESAS LIQUIDADAS ATÉ O BIMESTRE",
    "INSCRITAS EM RESTOS A PAGAR NÃO PROCESSADOS EM 2023"
  )
)
rreo_normalize_columns(demo)
#> # A tibble: 3 × 3
#>   coluna                                              coluna_padrao   coluna_ano
#>   <chr>                                               <chr>                <int>
#> 1 DESPESAS LIQUIDADAS ATÉ O BIMESTRE / 2023           DESPESAS LIQUI…       2023
#> 2 DESPESAS LIQUIDADAS ATÉ O BIMESTRE                  DESPESAS LIQUI…         NA
#> 3 INSCRITAS EM RESTOS A PAGAR NÃO PROCESSADOS EM 2023 INSCRITAS EM R…       2023
```
