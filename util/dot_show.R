dot_run <- function(script, out_file, ext)
{
  system2(command = 'dot',
          args = c(script,
                   paste0('"-o', out_file,'"'),
                   paste0('-T',  ext)))
}

dshow <- function(script)
{
  if(interactive())
  {
    ext <- 'svg'
    p <- fs::file_temp(ext = ext)
  }
  else
  {
    f <- knitr::current_input() |>
      fs::path_ext_remove() |>
      paste0('_gen') |>
      fs::dir_create() |>
      fs::path(knitr::opts_current$get("label"))
    if(knitr::is_html_output())
      ext <- 'svg'
    if(knitr::is_latex_output())
      ext <- 'pdf'

    p <- fs::path_ext_set(f, ext)
  }

  dot_run(script, p, ext)
  knitr::include_graphics(p)
}
