# Добавить yaml схему и валидацию

if (!nzchar(Sys.getenv("QUARTO_PROJECT_RENDER_ALL")))
  quit()

qmd_files <- Sys.getenv('QUARTO_PROJECT_INPUT_FILES') |>
  stringr::str_split_1('\n')

has_warning <- FALSE
for (cfg in fs::dir_ls(recurse = TRUE,
                       glob = '*content-export.yml',
                       type = 'file'))
{
  for (e in yaml::read_yaml(cfg))
  {
    d <- fs::path_dir(cfg)
    ep <- fs::path(d, e$from)

    if (!(ep %in% qmd_files))
      next

    for (f in e$files)
    {
      p <- fs::path(d, f) |> fs::path_norm()

      if (!fs::file_exists(p))
      {
        has_warning <- TRUE
        warning(paste(cfg, ' : file not found:', p, '\n'))
      }

      if (!stringr::str_detect(readr::read_file(ep), f))
      {
        has_warning <- TRUE
        warning(paste('file named', f , 'not found in', ep))
      }
    }
  }
}

if (has_warning)
  stop()
