## Submission summary

`tesouror 0.3.1` — a bug-fix release following 0.3.0 (published 2026-08-19).

This update is being submitted less than a month after 0.3.0 because the
upstream API changed on the server side and one exported function stopped
working: the Treasury's "Transferências Constitucionais" API renamed its
municipal endpoint and gave the new one a different contract (lower-case,
case-sensitive parameter names; singular `p_municipio`; paginated
responses). With the parameter names the package sent, the server ignored
every filter and answered HTTP 504 after 60 seconds on every call, so
`get_tc_por_municipio()` / `get_tc_by_municipality()` were unusable.

* `get_tc_por_municipio()` and `get_tc_by_municipality()` now send the
  parameter names the server expects and fetch every page of the paginated
  response (new arguments `page_size` and `max_rows`). If a page after the
  first fails, the rows already fetched are returned with
  `attr(x, "partial") = TRUE`, as the SICONFI pagers already do.
* `get_tc_por_municipio_detalhe()` / `get_tc_by_municipality_detail()`
  keep the endpoint's original contract, which is unchanged on the server,
  and now document the ten-day installment columns they return.
* Documentation aligned with the official API documentation
  (`p_sn_detalhar = "sim"`).

No function was added, renamed or removed; existing calls keep working with
the same arguments.

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

Unchanged from 0.3.0. Tests are network-free: HTTP responses are mocked
with `httr2::with_mocked_responses()` (23 new mocked tests cover the URL
construction and the pagination of the municipal endpoints) and the retry
timer is mocked via `testthat::local_mocked_bindings()`. Examples that
need network are wrapped in `\dontrun{}` and vignette chunks that call the
APIs use `eval = FALSE`.

## Reverse dependencies

There are no reverse dependencies on CRAN.
