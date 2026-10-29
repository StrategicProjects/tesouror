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
`no_anexo`, `conta_match`, `indicador`.

## Details

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
#> # A tibble: 10 × 8
#>    topic    regime first_year last_year co_esfera no_anexo conta_match indicador
#>    <chr>    <chr>       <int>     <int> <chr>     <chr>    <chr>       <chr>    
#>  1 previde… civil…       2015      2022 U         RREO-An… resultado … resultad…
#>  2 previde… civil…       2023      2099 U         RREO-An… resultado … resultad…
#>  3 previde… fcdf         2015      2022 U         RREO-An… resultado … resultad…
#>  4 previde… fcdf         2023      2099 U         RREO-An… resultado … resultad…
#>  5 previde… milit…       2015      2099 U         RREO-An… resultado … resultad…
#>  6 previde… rgps         2015      2022 U         RREO-An… resultado … resultad…
#>  7 previde… rgps         2023      2099 U         RREO-An… resultado … resultad…
#>  8 rcl      total        2015      2099 U/E/M     RREO-An… receita co… receita_…
#>  9 rcl      ajust…       2020      2099 E/M       RREO-An… receita co… rcl_ajus…
#> 10 rcl      ajust…       2020      2099 E/M       RREO-An… receita co… rcl_ajus…
```
