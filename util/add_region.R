add_region <- function(fig, xy, name = 'region', color) {
  plotly::add_trace(
    fig,
    x = xy[, 1],
    y = xy[, 2],
    type = 'scatter',
    fill = 'toself',
    fillcolor = color,
    hoveron = 'points+fills',
    marker = list(color = 'red'),
    line = list(color = color),
    text = apply(xy, 1, paste, collapse = ','),
    hoverinfo = 'text',
    name = plotly::TeX(name)
  )
}
