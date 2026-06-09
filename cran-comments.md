## Submission summary

`tesouror 0.2.3` — a small maintenance update to the version currently
on CRAN (0.2.2).

This release makes the `co_esfera` argument of `get_rreo()` (and the
`sphere` argument of its English alias `get_budget_report()`) optional.
Some SICONFI entities only return data when the sphere filter is absent
— notably the Federal District constitutional fund — so the previously
mandatory argument made those records unreachable. `co_esfera` now
defaults to `NULL` and is omitted from the request when not supplied;
existing calls that pass it are unaffected. A regression test was added.

No user-visible API was removed or renamed.

## Test environments

* local macOS 26.4.1 (arm64), R 4.5.2 — `R CMD check --as-cran`
* GitHub Actions `R-CMD-check` workflow (Ubuntu, R release)

## R CMD check results

```
0 errors | 0 warnings | 0 notes
```

## Network access in tests and examples

Unchanged from 0.2.2. The package wraps several public Brazilian
government APIs. Tests under `tests/testthat/` are network-free: HTTP
responses are mocked through `httr2::with_mocked_responses()` and the
retry timer is mocked via `testthat::local_mocked_bindings()`, so the
suite finishes in well under a minute. Examples that need network are
wrapped in `\dontrun{}`.

## Reverse dependencies

There are no reverse dependencies.
