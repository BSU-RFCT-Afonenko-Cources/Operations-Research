library(fs)
library(purrr)
library(readr)
library(stringr)

if (!nzchar(Sys.getenv("QUARTO_PROJECT_RENDER_ALL")))
  quit()

proj_profiles <- Sys.getenv('QUARTO_PROFILE') |> str_split_1(',')
is_dev <- TRUE #'dev' %in% proj_profiles

out <- Sys.getenv('QUARTO_PROJECT_OUTPUT_DIR') |> unique()
if(is_dev)
  cat('Out: ', out, '\n')

proj_abs_paths <- list('dev' = path_abs(out),
                       'prod' = Sys.getenv('PROJECT_PATH'))

site_libs_dir <- Sys.getenv('SITE_LIBS_PATH')

proj_abs_path <- proj_abs_paths[[intersect(names(proj_abs_paths), proj_profiles)]]
if(is_dev)
  cat('ProjAbsPath: ',proj_abs_path, '\n')


file_string_replace <- function(p, pattern, replacement)
{
  read_file(p) |>
    gsub(pattern = pattern, replacement = replacement, x=_) |>
    write_file(p)
}
