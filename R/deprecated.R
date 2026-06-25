# ============================================================================
# Deprecated function names
#
# In 0.3.0 the SICONFI report getters were renamed to make their scope
# explicit: the singular getters (one entity) gained the `_ufs` suffix and
# the state-wide sweeps (all municipalities of a UF) moved from `_for_state`
# to `_municipios` / `_municipalities`. The old names below still work but
# emit a deprecation warning and forward to the new names. They are kept for
# at least one release cycle for backward compatibility.
# ============================================================================

#' Deprecated functions in tesouror
#'
#' These functions were renamed in tesouror 0.3.0 and are kept as thin
#' wrappers for backward compatibility. They forward to their replacements
#' and emit a [.Deprecated()] warning. Please migrate to the new names:
#'
#' | Deprecated | Replacement |
#' |---|---|
#' | `get_dca()` | [get_dca_ufs()] |
#' | `get_annual_accounts()` | [get_annual_accounts_ufs()] |
#' | `get_dca_for_state()` | [get_dca_municipios()] |
#' | `get_annual_accounts_for_state()` | [get_annual_accounts_municipalities()] |
#' | `get_rreo()` | [get_rreo_ufs()] |
#' | `get_budget_report()` | [get_budget_report_ufs()] |
#' | `get_rreo_for_state()` | [get_rreo_municipios()] |
#' | `get_budget_report_for_state()` | [get_budget_report_municipalities()] |
#' | `get_rgf()` | [get_rgf_ufs()] |
#' | `get_fiscal_report()` | [get_fiscal_report_ufs()] |
#' | `get_rgf_for_state()` | [get_rgf_municipios()] |
#' | `get_fiscal_report_for_state()` | [get_fiscal_report_municipalities()] |
#'
#' @param ... Arguments forwarded to the replacement function.
#' @return The value returned by the replacement function.
#' @name tesouror-deprecated
#' @keywords internal
NULL

# -- DCA ----------------------------------------------------------------------

#' @rdname tesouror-deprecated
#' @export
get_dca <- function(...) {
  .Deprecated("get_dca_ufs")
  get_dca_ufs(...)
}

#' @rdname tesouror-deprecated
#' @export
get_annual_accounts <- function(...) {
  .Deprecated("get_annual_accounts_ufs")
  get_annual_accounts_ufs(...)
}

#' @rdname tesouror-deprecated
#' @export
get_dca_for_state <- function(...) {
  .Deprecated("get_dca_municipios")
  get_dca_municipios(...)
}

#' @rdname tesouror-deprecated
#' @export
get_annual_accounts_for_state <- function(...) {
  .Deprecated("get_annual_accounts_municipalities")
  get_annual_accounts_municipalities(...)
}

# -- RREO ---------------------------------------------------------------------

#' @rdname tesouror-deprecated
#' @export
get_rreo <- function(...) {
  .Deprecated("get_rreo_ufs")
  get_rreo_ufs(...)
}

#' @rdname tesouror-deprecated
#' @export
get_budget_report <- function(...) {
  .Deprecated("get_budget_report_ufs")
  get_budget_report_ufs(...)
}

#' @rdname tesouror-deprecated
#' @export
get_rreo_for_state <- function(...) {
  .Deprecated("get_rreo_municipios")
  get_rreo_municipios(...)
}

#' @rdname tesouror-deprecated
#' @export
get_budget_report_for_state <- function(...) {
  .Deprecated("get_budget_report_municipalities")
  get_budget_report_municipalities(...)
}

# -- RGF ----------------------------------------------------------------------

#' @rdname tesouror-deprecated
#' @export
get_rgf <- function(...) {
  .Deprecated("get_rgf_ufs")
  get_rgf_ufs(...)
}

#' @rdname tesouror-deprecated
#' @export
get_fiscal_report <- function(...) {
  .Deprecated("get_fiscal_report_ufs")
  get_fiscal_report_ufs(...)
}

#' @rdname tesouror-deprecated
#' @export
get_rgf_for_state <- function(...) {
  .Deprecated("get_rgf_municipios")
  get_rgf_municipios(...)
}

#' @rdname tesouror-deprecated
#' @export
get_fiscal_report_for_state <- function(...) {
  .Deprecated("get_fiscal_report_municipalities")
  get_fiscal_report_municipalities(...)
}
