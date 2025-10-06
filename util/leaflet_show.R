leaflet_show_non_html <- function(geo_map)
{
  dir_name <- knitr::current_input() |> fs::path_ext_remove() |> paste0('_gen')
  fs::dir_create(dir_name)
  geo_map_name <- paste0(knitr::opts_current$get("label"), '.png')
  geo_map_path <- fs::path(dir_name, geo_map_name) |> fs::file_create()

  mapview::mapshot2(geo_map, fs::file_temp(ext='.html'), geo_map_path)
  knitr::include_graphics(geo_map_path)
}

lshow <- function(geo_map)
{
  if(interactive())
    return(geo_map)
  if(knitr::is_html_output())
    return(geo_map)
  else
    return(leaflet_show_non_html(geo_map))
}
