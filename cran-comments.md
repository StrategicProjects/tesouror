## Submission summary

`tesouror 0.3.0` — a feature release following 0.2.3.

* **Clearer SICONFI function names.** The single-entity report getters were
  renamed to make their scope explicit (e.g. `get_rreo()` → `get_rreo_ufs()`),
  and the state-wide municipality sweeps moved from the `_for_state` suffix to
  `_municipios` / `_municipalities`. **No API was broken:** every old name is
  retained as an exported, deprecated wrapper that emits a `.Deprecated()`
  warning and forwards to its replacement (documented under
  `?"tesouror-deprecated"`).
* **New SIOPE entity-type filter.** All `get_siope_*()` functions gained an
  optional `tipo` / `type` argument that applies a server-side filter so
  callers can fetch only the state row or only the municipalities. Existing
  calls are unaffected (defaults to `NULL`).

The documentation was regenerated with roxygen2 8.0.0 (cosmetic `.Rd`
changes only).

## Test environments

* local macOS 26.4.1 (arm64), R 4.5.2 — `R CMD check --as-cran`
* GitHub Actions `R-CMD-check` workflow (Ubuntu, R release)

## R CMD check results

```
0 errors | 0 warnings | 0 notes
```

Locally a single NOTE is emitted — "Skipping checking HTML validation:
'tidy' doesn't look like recent enough HTML Tidy" — which reflects the old
`tidy` binary on the test machine, not the package, and does not occur on
CRAN's check machines.

## Network access in tests and examples

Unchanged from 0.2.x. The package wraps several public Brazilian
government APIs. Tests under `tests/testthat/` are network-free: HTTP
responses are mocked through `httr2::with_mocked_responses()` and the
retry timer is mocked via `testthat::local_mocked_bindings()`, so the
suite finishes in well under a minute. Examples that need network are
wrapped in `\dontrun{}` and vignette chunks that call the APIs use
`eval = FALSE`.

## Reverse dependencies

There are no reverse dependencies.
