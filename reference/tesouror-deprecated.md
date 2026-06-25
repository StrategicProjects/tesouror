# Deprecated functions in tesouror

These functions were renamed in tesouror 0.3.0 and are kept as thin
wrappers for backward compatibility. They forward to their replacements
and emit a [`.Deprecated()`](https://rdrr.io/r/base/Deprecated.html)
warning. Please migrate to the new names:

## Usage

``` r
get_dca(...)

get_annual_accounts(...)

get_dca_for_state(...)

get_annual_accounts_for_state(...)

get_rreo(...)

get_budget_report(...)

get_rreo_for_state(...)

get_budget_report_for_state(...)

get_rgf(...)

get_fiscal_report(...)

get_rgf_for_state(...)

get_fiscal_report_for_state(...)
```

## Arguments

- ...:

  Arguments forwarded to the replacement function.

## Value

The value returned by the replacement function.

## Details

|  |  |
|----|----|
| Deprecated | Replacement |
| `get_dca()` | [`get_dca_ufs()`](https://strategicprojects.github.io/tesouror/reference/get_dca_ufs.md) |
| `get_annual_accounts()` | [`get_annual_accounts_ufs()`](https://strategicprojects.github.io/tesouror/reference/get_dca_ufs.md) |
| `get_dca_for_state()` | [`get_dca_municipios()`](https://strategicprojects.github.io/tesouror/reference/get_dca_municipios.md) |
| `get_annual_accounts_for_state()` | [`get_annual_accounts_municipalities()`](https://strategicprojects.github.io/tesouror/reference/get_dca_municipios.md) |
| `get_rreo()` | [`get_rreo_ufs()`](https://strategicprojects.github.io/tesouror/reference/get_rreo_ufs.md) |
| `get_budget_report()` | [`get_budget_report_ufs()`](https://strategicprojects.github.io/tesouror/reference/get_rreo_ufs.md) |
| `get_rreo_for_state()` | [`get_rreo_municipios()`](https://strategicprojects.github.io/tesouror/reference/get_rreo_municipios.md) |
| `get_budget_report_for_state()` | [`get_budget_report_municipalities()`](https://strategicprojects.github.io/tesouror/reference/get_rreo_municipios.md) |
| `get_rgf()` | [`get_rgf_ufs()`](https://strategicprojects.github.io/tesouror/reference/get_rgf_ufs.md) |
| `get_fiscal_report()` | [`get_fiscal_report_ufs()`](https://strategicprojects.github.io/tesouror/reference/get_rgf_ufs.md) |
| `get_rgf_for_state()` | [`get_rgf_municipios()`](https://strategicprojects.github.io/tesouror/reference/get_rgf_municipios.md) |
| `get_fiscal_report_for_state()` | [`get_fiscal_report_municipalities()`](https://strategicprojects.github.io/tesouror/reference/get_rgf_municipios.md) |
