# Выбор цветов для градиента
plt <- c('yellow', 'purple', 'green')

# Создать функцию по палитре. clf получает число цветов и равномерно распределяет градиент между ними
clf <- colorRampPalette(plt)

# Добавляет на (контурный) график точки из датасета. Точки выделюятся цветом, если датасет df получен с помощью функций *_colored_sample
padd_eval_points <- \(fig, df) plotly::add_trace(
  fig,
  x = df$x1,
  y = df$x2,
  type = 'scatter',
  mode = 'markers',
  marker = list(color = clf(nrow(df))),
  showlegend = FALSE,
  name = 'eval'
)

padd_path_points <- \(fig, df) plotly::add_trace(
  fig,
  x = df$x1,
  y = df$x2,
  type = 'scatter',
  mode = 'lines+markers',
  name = 'path'
)

padd_start_stop_points <- function(fig, df)
{
  n <- nrow(df)
  plotly::add_trace(
    fig,
    x = df[[1, 'x1']],
    y = df[[1, 'x2']],
    type = 'scatter',
    mode = 'markers',
    name = 'start'
  ) |>
    plotly::add_trace(
      fig,
      x = df[[n, 'x1']],
      y = df[[n, 'x2']],
      type = 'scatter',
      mode = 'markers',
      name = 'end'
    )
}
