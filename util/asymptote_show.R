asymptote_run <- function(script, out_file, ext)
{
  system2(command = 'asy',
          args = c(script,
                   '-o', out_file,
                   '-f',  ext))
}

ashow <- function(script, count = 1)
{
  if(interactive())
  {
    ext <- 'svg'
    p <- fs::file_temp(ext = ext)
    f <- fs::path_ext_remove(p)
  }
  else
  {
    dir_name <- knitr::current_input() |> fs::path_ext_remove() |> paste0('_gen')
    fs::dir_create(dir_name)
    f <- fs::path(dir_name, knitr::opts_current$get("label"))
    if(knitr::is_html_output())
      ext <- 'svg'
    if(knitr::is_latex_output())
      ext <- 'pdf'

    p <- fs::path_ext_set(f, ext)
  }

  asymptote_run(script, f, ext)
  knitr::include_graphics(rep(p, count))
}
