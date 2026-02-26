source("renv/activate.R")

options(renv.config.sysreqs.check = FALSE)

if(!file.exists('renv/restore.lock'))
{
  renv::restore()
  file.create('renv/restore.lock')
}

fs::dir_ls(path = 'util', type = 'file', glob = '*.R') |>
  purrr::walk(source)

Sys.setenv(PLOTLY_MATHJAX_PATH = fs::path_abs('mathjax_plotly'))
Sys.setenv(JULIA_PROJECT = base::getwd())
Sys.setenv(RETICULATE_PYTHON = fs::path_abs('.venv/bin/python'))
