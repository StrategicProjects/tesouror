## Submission summary

`tesouror 0.3.2` — a feature release following 0.3.1 (published 2026-09-12).

This update extends the package's tidy layer for the Brazilian RREO fiscal
report, which reconciles label drift across fiscal years. No function was
added, renamed or removed; existing calls keep working with the same
arguments.

* `tidy_rreo()` covers three new topics besides `"previdencia"`:
  `"rcl"` (net current revenue, Anexo 03), `"balanco"` (budget balance,
  Anexo 01) and `"resultado"` (primary and nominal results, Anexo 06),
  for every government sphere, probed live against the SICONFI API for
  fiscal years 2015-2026.
* The bundled layout table gained a `cod_conta_match` column: a rule can
  now match on SICONFI's stable semantic account code instead of the
  free-text label, which is ambiguous in the two new appendices.
* When the input carries an `anexo` column, `tidy_rreo()` matches rows
  only against the appendix each rule refers to, preventing double
  counting with the simplified statement (Anexo 14), which repeats
  accounts from other appendices under identical labels.
* Updated author metadata (one author added, ORCID identifiers).

## Test environments

* local macOS (arm64), R 4.6.0 — `R CMD check --as-cran`
* GitHub Actions `R-CMD-check`: macOS (release), Windows (release),
  Ubuntu (devel, release, oldrel-1)
* win-builder (R-devel)

## R CMD check results

```
0 errors | 0 warnings | 0 notes
```

## Network access in tests and examples

Unchanged from 0.3.1. Tests are network-free: the new `tidy_rreo()` tests
run on in-memory fixtures, HTTP responses elsewhere are mocked with
`httr2::with_mocked_responses()`, and the retry timer is mocked via
`testthat::local_mocked_bindings()`. Examples that need network are
wrapped in `\dontrun{}` and vignette chunks that call the APIs use
`eval = FALSE`.

## Reverse dependencies

There are no reverse dependencies on CRAN.
