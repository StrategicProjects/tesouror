# Clear the tesouror in-memory cache

Removes **all** cached API responses stored during the current R
session. This applies to every API covered by the package: SICONFI,
CUSTOS, SADIPEM, and Transferencias Constitucionais. All cached
responses share the same in-memory store and are cleared together.

## Usage

``` r
tesouror_clear_cache()
```

## Value

Invisible `NULL`.

## Examples

``` r
tesouror_clear_cache()
#> ℹ Cache cleared (all APIs).
```
