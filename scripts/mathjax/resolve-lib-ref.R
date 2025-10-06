source('scripts/load_enviroment.R')

mathjax_rel_path <- path(site_libs_dir, 'mathjax-3.2.2', 'tex-svg-full.js')

mathjax_quarto_local_out_path <- path(out, mathjax_rel_path)
mathjax_quarto_local_in_path <- path('mathjax_quarto', 'es5', 'tex-svg-full.js')

mathjax_quarto_local_out_path |> fs::path_dir() |> fs::dir_create()
fs::file_copy(mathjax_quarto_local_in_path, mathjax_quarto_local_out_path)

mathjax_quarto_lib_path <- path(proj_abs_path, mathjax_rel_path)

fs::dir_ls(out, recurse = TRUE, glob = '*.html', type = 'file') |>
  purrr::walk(file_string_replace,
              pattern = 'QUARTO_MATHJAX_SVG',
              replacement = mathjax_quarto_lib_path,
              .progress = is_dev)
