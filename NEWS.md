# tesouror 0.1.0.9000 (development version)

## New features

* **Fault-tolerant batch fetchers for SICONFI**. New helpers
  `get_rreo_for_state()`, `get_dca_for_state()`, and `get_rgf_for_state()`
  (plus English aliases `get_budget_report_for_state()`,
  `get_annual_accounts_for_state()`, `get_fiscal_report_for_state()`) fetch
  data for every municipality of a Brazilian state in a single call. They
  loop over the underlying SICONFI endpoint per municipality and tolerate
  per-entity failures: when an individual call cannot be recovered after the
  five-attempt retry budget, the failure is recorded and the loop continues.
  Failed calls are returned via `attr(result, "failed")` (a tibble with
  `iteration`, `id`, `error`). The `on_error` argument controls behaviour:
  `"warn"` (default), `"stop"`, or `"silent"`. This addresses the
  fault-tolerance and missing-municipality concerns reported in
  [rsiconfi#2](https://github.com/tchiluanda/rsiconfi/issues/2) and
  [rsiconfi#3](https://github.com/tchiluanda/rsiconfi/issues/3).

* **Distinct reporting for empty responses**. The SICONFI API replies
  HTTP 200 with zero rows when an entity has not homologated a given
  report (a common cause of "missing municipalities" complaints). The new
  batch fetchers expose these cases via `attr(result, "no_data")` (a
  tibble with `iteration`, `id`), separate from technical failures in
  `attr(result, "failed")`.

* **Layout-aware RREO tidy layer**. New functions `rreo_layout()`,
  `rreo_normalize_columns()`, and `tidy_rreo()` reconcile SICONFI's
  drifting column and account labels across fiscal years. The bundled
  `inst/extdata/rreo_layout.csv` knows that, for example, the federal
  RGPS appendix moved from `RREO-Anexo 04.3 - RGPS` (≤2022) to
  `RREO-Anexo 04.4 - RGPS` (2023+) and that account names with shifting
  Roman numerals (`"... (VII) = (III - VI)"`) are matched on a stable
  stem. `rreo_normalize_columns()` adds a `coluna_padrao` (year-stripped)
  and a `coluna_ano` (the year that appeared in the suffix, or `NA`),
  letting users distinguish a current-year column from a comparative
  previous-year column. `tidy_rreo(data, topic = "previdencia")` returns
  a year-stable indicator column ready for longitudinal analysis,
  collapsing the manual `paste0(... ifelse(year >= 2021, "", " / "), ...)`
  workarounds that were the workhorse for issue
  [rsiconfi#4](https://github.com/tchiluanda/rsiconfi/issues/4).
  Currently ships rules for federal previdência (RGPS, RPPS civis, FCDF,
  militares); contributions for additional topics are welcome. See the
  new vignette `vignette("rreo-longitudinal")` for an end-to-end
  walkthrough.

* **New dependency**: `stringi (>= 1.7.0)` (for portable diacritic
  stripping; already a transitive dependency via `stringr`).

## Other

* Added a hard `Depends: R (>= 4.1.0)` to reflect the use of the native
  pipe (`|>`) inside the package.

# tesouror 0.1.0

## New package

`tesouror` expands the former `siconfir` package into a unified interface
for all Brazilian National Treasury open data APIs.

### APIs covered

* **SICONFI** — Fiscal reports (RREO, RGF, DCA, MSC) and entity data
  (all functions from the original `siconfir` package).
* **CUSTOS** — Federal government cost data (active/retired staff,
  pensioners, depreciation, transfers, other costs).
* **SADIPEM** — Public debt verification letters (PVL), credit operations,
  payment schedules, and debt capacity.
* **Transferências Constitucionais** — Constitutional transfers to states
  and municipalities (FPE, FPM, FUNDEB, etc.).
* **SIORG** — Federal organizational structure (organs, entities,
  departments). SIORG codes serve as dictionary values for the
  `organizacao_n1/n2/n3` parameters in the CUSTOS API.
* **SIOPE** — Education spending data from FNDE/MEC (general data,
  revenues, expenses, indicators, compensation). Uses the FNDE's
  OData-style API.

### Features

* Bilingual interface: every function has both Portuguese (API-native) and
  English-named versions with English parameter names.
* In-memory caching across all APIs (`tesouror_clear_cache()`).
* Automatic pagination for ORDS-style responses (SICONFI, CUSTOS, SADIPEM)
  and OData-style responses (SIOPE), with per-page progress reporting.
* `page_size` parameter to control rows per page (CUSTOS defaults to 1000
  instead of the server's slow default of 250; SIOPE defaults to 1000).
* `max_rows` parameter on all paginated functions to cap the number of rows
  returned. Automatically adjusts `limit`/`$top` to avoid fetching
  unnecessary data.
* Retry logic: 5 attempts with progressive backoff (3s, 6s, 9s, 12s, 15s)
  on HTTP 500/502/503/504/429 and connection failures. HTTP 400/404 are
  not retried and produce actionable error messages.
* `verbose` parameter on every function to print the full API URL for
  debugging or testing in a browser/curl. Can be set globally with
  `options(tesouror.verbose = TRUE)`.
* `janitor::clean_names()` applied to all responses for consistent
  snake_case column names.
* CUSTOS: SIORG codes auto-padded (`244` → `"000244"`).
* SIOPE: OData `$filter`, `$orderby`, and `$select` support for
  server-side filtering, sorting, and column selection.
* Transferências: multi-value parameters accept R vectors (`c(1, 2, 3)`)
  in addition to colon-separated strings (`"1:2:3"`).
* Friendly error messages with retry logic for transient failures.
  HTTP 400 errors parse server messages and suggest checking column names.
* NA validation in required parameters.
* Tidy tibble output with whitespace trimming.
