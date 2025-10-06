source('scripts/load_enviroment.R')

print_head <- function(x,name)
{
  cat(name,'\n')
  head(x) |>
    purrr::walk(\(e) cat('\t',e,'\n'))
  cat('Total:', length(x),'\n')
}

site_lib_path <- path(proj_abs_path, site_libs_dir)

if(is_dev)
  cat('site_lib_path', site_lib_path,'\n')


widgets <- fs::dir_ls(out, recurse = TRUE, glob = '*_files/figure-html/widgets/widget_*.html', type = 'file')
if(is_dev) print_head(widgets,'Widgets')
if(is_dev) cat('Widgets PlotlyLibs -> SiteLibs started','\n')
widgets |> purrr::walk(file_string_replace,
                       pattern = 'plotly_libs',
                       replacement = site_lib_path,
                       .progress = is_dev)

if(is_dev) cat('Widgets link replacement completed','\n')

plotly_libs_dirs <-  fs::dir_ls(out,
                                recurse = TRUE,
                                glob = '*plotly_libs',
                                type = 'dir')

if(is_dev) print_head(plotly_libs_dirs,'PlotlyLibDirs')

plotly_libs_inner_dirs <- plotly_libs_dirs |>
  purrr::map(\(d) fs::dir_ls(d, type = 'dir')) |>
  purrr::list_c()

if(is_dev) print_head(plotly_libs_inner_dirs,'PlotlyLibInnerDirs')

if(is_dev) cat('Copy PlotlyLibs -> SiteLibs started','\n')
plotly_libs_inner_dirs |>
  purrr::walk(\(d) file.copy(from = d,
                             to = fs::path(out, site_libs_dir),
                             overwrite = FALSE,
                             recursive = TRUE,
                             copy.mode = TRUE),
              .progress = is_dev)

if(is_dev) cat('Remove PlotlyLibs started','\n')
fs::dir_ls(out,
           recurse = TRUE,
           glob = '*plotly_libs',
           type = 'dir') |>
  unique() |>
  purrr::walk(fs::dir_delete,
              .progress = is_dev)

