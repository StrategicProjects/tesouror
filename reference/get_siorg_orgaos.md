# Get federal organizations from SIORG

Retrieves the list of federal government organizations (organs and
entities) from the SIORG system. Use the returned SIORG codes as
`organizacao_n1` / `org_level1` in CUSTOS API functions like
[`get_custos_pessoal_ativo()`](https://strategicprojects.github.io/tesouror/reference/get_custos_pessoal_ativo.md).

## Usage

``` r
get_siorg_orgaos(
  codigo_poder = NULL,
  codigo_esfera = NULL,
  use_cache = TRUE,
  verbose = FALSE
)

get_siorg_organizations(power_code = NULL, sphere_code = NULL,
  use_cache = TRUE, verbose = FALSE)
```

## Arguments

- codigo_poder:

  Integer. Power branch code: `1` = Executive, `2` = Legislative, `3` =
  Judiciary. Optional (default returns all).

- codigo_esfera:

  Integer. Government sphere: `1` = Federal, `2` = State/District, `3` =
  Municipal. Optional.

- use_cache:

  Logical. If `TRUE` (default), uses an in-memory cache.

- verbose:

  Logical. If `TRUE`, prints the full API URL being called. Defaults to
  `getOption("tesouror.verbose", FALSE)`.

- power_code:

  Integer. Power branch: `1` = Executive, `2` = Legislative, `3` =
  Judiciary. Maps to `codigo_poder`.

- sphere_code:

  Integer. Sphere: `1` = Federal. Maps to `codigo_esfera`.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
columns including `codigo_unidade` (SIORG code — use as `organizacao_n1`
in CUSTOS), `codigo_unidade_pai` (parent code — for navigating
hierarchy), `nome`, `sigla`, `codigo_tipo_unidade` (`"orgao"` or
`"entidade"`), `codigo_natureza_juridica`, `codigo_esfera`,
`codigo_poder`.

## Details

`get_siorg_organizations()` is an English alias.

## See also

Other SIORG:
[`get_siorg_estrutura()`](https://strategicprojects.github.io/tesouror/reference/get_siorg_estrutura.md),
[`get_siorg_unidade()`](https://strategicprojects.github.io/tesouror/reference/get_siorg_unidade.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# List all federal executive branch organizations
orgaos <- get_siorg_orgaos(codigo_poder = 1, codigo_esfera = 1)

# Find a specific ministry by name
mec <- orgaos[grepl("Educação", orgaos$nome), ]
mec_code <- mec$codigo_unidade[mec$sigla == "MEC"]

# Use that code in CUSTOS queries (auto-padded to "000244")
custos <- get_custos_pessoal_ativo(
  ano = 2023, organizacao_n1 = mec_code
)

# Browse children: units whose parent is MEC
mec_filhos <- orgaos[orgaos$codigo_unidade_pai == mec_code, ]
} # }
```
