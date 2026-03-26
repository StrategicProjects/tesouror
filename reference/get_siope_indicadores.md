# Get SIOPE education indicators

Retrieves education spending indicators such as percentage of revenue
applied to education, FUNDEB compliance, etc.

## Usage

``` r
get_siope_indicadores(
  ano,
  periodo,
  uf,
  use_cache = TRUE,
  verbose = FALSE,
  page_size = 1000L,
  max_rows = Inf,
  filter = NULL,
  orderby = NULL,
  select = NULL
)

get_siope_indicators(year, period, state, use_cache = TRUE,
  verbose = FALSE,
  page_size = 1000, max_rows = Inf,
  filter = NULL, orderby = NULL, select = NULL)
```

## Arguments

- ano:

  Integer. Year of the data (e.g., `2023`). **Required**.

- periodo:

  Integer. Bimester period (1-6). **Required**.

- uf:

  Character. State abbreviation (e.g., `"PE"`). **Required**.

- use_cache:

  Logical. If `TRUE` (default), uses an in-memory cache.

- verbose:

  Logical. If `TRUE`, prints the full API URL. Defaults to `FALSE`. Set
  globally with `options(tesouror.verbose = TRUE)`.

- page_size:

  Integer. Rows per page for OData pagination. Defaults to `1000`.

- max_rows:

  Numeric. Maximum rows to return. Defaults to `Inf`.

- filter:

  Character. OData `$filter` expression to narrow results **on the
  server** (much faster than downloading everything). Uses OData syntax
  (e.g., `"NOM_MUNI eq 'Recife'"`, `"COD_MUNI eq 2611606"`). Combine
  with `and`/`or`. Column names must use the **original API names**
  (uppercase), not the snake_case cleaned names. To discover valid
  names, run a `max_rows = 1` query and use `toupper(names(result))`.
  Optional.

- orderby:

  Character. OData `$orderby` expression to sort results (e.g.,
  `"NOM_MUNI asc"`, `"NUM_POPU desc"`). Uses original API column names
  (uppercase). Optional.

- select:

  Character vector. Column names to return (reduces payload size). Uses
  original API column names (e.g., `c("NOM_MUNI", "VAL_DECL")`). If a
  column name is invalid the API returns HTTP 400. Optional.

- year:

  Integer. Year. **Required**. Maps to `ano`.

- period:

  Integer. Bimester (1-6). **Required**. Maps to `periodo`.

- state:

  Character. State abbreviation. **Required**. Maps to `uf`.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with 13
columns including indicator codes and values.

## Details

`get_siope_indicators()` is an English alias.

## See also

Other SIOPE:
[`get_siope_dados_gerais()`](https://strategicprojects.github.io/tesouror/reference/get_siope_dados_gerais.md),
[`get_siope_despesas()`](https://strategicprojects.github.io/tesouror/reference/get_siope_despesas.md),
[`get_siope_despesas_funcao()`](https://strategicprojects.github.io/tesouror/reference/get_siope_despesas_funcao.md),
[`get_siope_info_complementares()`](https://strategicprojects.github.io/tesouror/reference/get_siope_info_complementares.md),
[`get_siope_receitas()`](https://strategicprojects.github.io/tesouror/reference/get_siope_receitas.md),
[`get_siope_remuneracao()`](https://strategicprojects.github.io/tesouror/reference/get_siope_remuneracao.md),
[`get_siope_responsaveis()`](https://strategicprojects.github.io/tesouror/reference/get_siope_responsaveis.md)

## Examples

``` r
if (FALSE) { # \dontrun{
ind <- get_siope_indicadores(ano = 2023, periodo = 6, uf = "PE")
} # }
```
