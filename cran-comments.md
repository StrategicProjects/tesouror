## Submission summary

This is the first CRAN submission of `tesouror`. It supersedes the
unreleased `siconfir` package, expanding the scope from one to six
Brazilian National Treasury / open-data APIs (SICONFI, CUSTOS, SADIPEM,
SIORG, Transferências Constitucionais, SIOPE) under a single, consistent
interface.

## Test environments

* local macOS 26.4.1 (arm64), R 4.5.2 — `R CMD check --as-cran`
* GitHub Actions `R-CMD-check` workflow (Ubuntu, R release)
* GitHub Actions `pkgdown` workflow (site build)

## R CMD check results

```
0 ERRORs | 0 WARNINGs | 1 NOTE
```

The single NOTE is the standard "New submission" line.

## Network access in tests and examples

The package wraps several public Brazilian government APIs. Tests under
`tests/testthat/` are network-free: HTTP responses are mocked through
`httr2::with_mocked_responses()` (with `httptest2` listed in Suggests as
a future hook for full cassette-based mocking). The retry timer is also
mocked via `testthat::local_mocked_bindings(.tnr_sleep = ...)` so the
suite finishes in well under a minute.

Examples that genuinely need network are wrapped in `\dontrun{}`. Where
an example only depends on a public, anonymous endpoint and is a useful
runnable demo, we use `\donttest{}` so reviewers can verify behaviour
locally without slowing down the standard check.

## Reverse dependencies

There are no reverse dependencies (first submission).

## Notes for the reviewer

* All function and parameter names are bilingual (Portuguese
  API-native + English aliases). The Portuguese terms are the source of
  truth for the upstream APIs; an `inst/WORDLIST` accompanies the
  package so `spelling::spell_check_package()` runs cleanly.
* The package has eight pre-rendered vignettes under `inst/doc/`
  illustrating each API; one of them (`rreo-longitudinal`) walks
  through the layout-drift problem the package solves. All vignettes use
  `eval = FALSE` chunks and are reproducible by users with network access.
