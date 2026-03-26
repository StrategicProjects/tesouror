# Changelog

## tesouror 0.1.0

### New package

`tesouror` expands the former `siconfir` package into a unified
interface for all Brazilian National Treasury open data APIs.

#### APIs covered

- **SICONFI** — Fiscal reports (RREO, RGF, DCA, MSC) and entity data
  (all functions from the original `siconfir` package).
- **CUSTOS** — Federal government cost data (active/retired staff,
  pensioners, depreciation, transfers, other costs).
- **SADIPEM** — Public debt verification letters (PVL), credit
  operations, payment schedules, and debt capacity.
- **Transferências Constitucionais** — Constitutional transfers to
  states and municipalities (FPE, FPM, FUNDEB, etc.).
- **SIORG** — Federal organizational structure (organs, entities,
  departments). SIORG codes serve as dictionary values for the
  `organizacao_n1/n2/n3` parameters in the CUSTOS API.
- **SIOPE** — Education spending data from FNDE/MEC (general data,
  revenues, expenses, indicators, compensation). Uses the FNDE’s
  OData-style API.

#### Features

- Bilingual interface: every function has both Portuguese (API-native)
  and English-named versions with English parameter names.
- In-memory caching across all APIs
  ([`tesouror_clear_cache()`](https://strategicprojects.github.io/tesouror/reference/tesouror_clear_cache.md)).
- Automatic pagination for ORDS-style responses (SICONFI, CUSTOS,
  SADIPEM) and OData-style responses (SIOPE), with per-page progress
  reporting.
- `page_size` parameter to control rows per page (CUSTOS defaults to
  1000 instead of the server’s slow default of 250; SIOPE defaults to
  1000).
- `max_rows` parameter on all paginated functions to cap the number of
  rows returned. Automatically adjusts `limit`/`$top` to avoid fetching
  unnecessary data.
- Retry logic: 5 attempts with progressive backoff (3s, 6s, 9s, 12s,
  15s) on HTTP 500/502/503/504/429 and connection failures. HTTP 400/404
  are not retried and produce actionable error messages.
- `verbose` parameter on every function to print the full API URL for
  debugging or testing in a browser/curl. Can be set globally with
  `options(tesouror.verbose = TRUE)`.
- [`janitor::clean_names()`](https://sfirke.github.io/janitor/reference/clean_names.html)
  applied to all responses for consistent snake_case column names.
- CUSTOS: SIORG codes auto-padded (`244` → `"000244"`).
- SIOPE: OData `$filter`, `$orderby`, and `$select` support for
  server-side filtering, sorting, and column selection.
- Transferências: multi-value parameters accept R vectors (`c(1, 2, 3)`)
  in addition to colon-separated strings (`"1:2:3"`).
- Friendly error messages with retry logic for transient failures. HTTP
  400 errors parse server messages and suggest checking column names.
- NA validation in required parameters.
- Tidy tibble output with whitespace trimming.
