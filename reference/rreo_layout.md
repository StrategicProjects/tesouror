# Return the bundled RREO layout reference table

RREO appendix names, account labels, and column suffixes drift across
fiscal years (e.g., `RREO-Anexo 04.3 - RGPS` for 2019-2022 vs.
`RREO-Anexo 04.4 - RGPS` for 2023+). The package ships a small reference
table in `inst/extdata/rreo_layout.csv` that maps
`(topic, regime, year_range)` to the correct appendix and
account-matching key.

## Usage

``` r
rreo_layout()
```

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
columns `topic`, `regime`, `first_year`, `last_year`, `co_esfera`,
`no_anexo`, `conta_match`, `cod_conta_match`, `indicador`.

## Details

Each rule matches either on a cleaned account label (`conta_match`) or
on SICONFI's stable semantic account code (`cod_conta_match`, e.g.
`"TotalReceitas"`); exactly one of the two is non-empty per row. Code
matching is used where the free-text label is ambiguous — in Anexo 06,
for instance, `"RESULTADO PRIMÁRIO (COM RPPS) - ..."` and
`"RESULTADO PRIMÁRIO (SEM RPPS) - ..."` collapse to the same cleaned
label, while their `cod_conta` values stay distinct.

[`tidy_rreo()`](https://strategicprojects.github.io/tesouror/reference/tidy_rreo.md)
uses this table to assemble layout-stable indicators across years; you
can also use it directly to look up which appendix to fetch with
[`get_rreo_ufs()`](https://strategicprojects.github.io/tesouror/reference/get_rreo_ufs.md)
for a given topic.

## See also

Other RREO tidy:
[`rreo_normalize_columns()`](https://strategicprojects.github.io/tesouror/reference/rreo_normalize_columns.md),
[`tidy_rreo()`](https://strategicprojects.github.io/tesouror/reference/tidy_rreo.md)

## Examples

``` r
rreo_layout()
#> # A tibble: 30 × 9
#>    topic       regime        first_year last_year co_esfera no_anexo conta_match
#>    <chr>       <chr>              <int>     <int> <chr>     <chr>    <chr>      
#>  1 previdencia civil_rpps          2015      2022 U         RREO-An… resultado …
#>  2 previdencia civil_rpps          2023      2099 U         RREO-An… resultado …
#>  3 previdencia fcdf                2015      2022 U         RREO-An… resultado …
#>  4 previdencia fcdf                2023      2099 U         RREO-An… resultado …
#>  5 previdencia militar             2015      2099 U         RREO-An… resultado …
#>  6 previdencia rgps                2015      2022 U         RREO-An… resultado …
#>  7 previdencia rgps                2023      2099 U         RREO-An… resultado …
#>  8 rcl         total               2015      2099 U/E/M     RREO-An… receita co…
#>  9 rcl         ajustada_end…       2020      2099 E/M       RREO-An… receita co…
#> 10 rcl         ajustada_pes…       2020      2099 E/M       RREO-An… receita co…
#> # ℹ 20 more rows
#> # ℹ 2 more variables: cod_conta_match <chr>, indicador <chr>
```
