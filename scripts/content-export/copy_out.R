if (!nzchar(Sys.getenv("QUARTO_PROJECT_RENDER_ALL")))
  quit()

out <- Sys.getenv('QUARTO_PROJECT_OUTPUT_DIR')

# Костыль для экспорта из какталого отличного от export.yaml
fs::dir_create(out, fs::path('r','helper'))

for(cfg in fs::dir_ls(recurse = TRUE,
                      glob = '*content-export.yml',
                      type = 'file'))
  for(e in yaml::read_yaml(cfg))
    for(f in e$files)
    {
      d <- fs::path_dir(cfg) |> fs::path_norm()
      fs::dir_create(out, d)
      fs::file_copy(path = fs::path(d, f) |> fs::path_norm(),
                    new_path = fs::path(out,d,f) |> fs::path_norm(),
                    overwrite = TRUE)
    }

