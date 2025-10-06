# Логарифм со знаком
slog <- \(v) sign(v) * log(abs(v)) |> tidyr::replace_na(0)

# Вызывает библиотеку plot_ly для отрисовки контурного графика для функции smoof
smoof_pcontour <- function(f, len)
{
  r <- smoof_outer(f, len)
  plotly::plot_ly(x = r$x1,
                  y = r$x2,
                  z = slog(r$f),
                  type = 'contour',
                  ncontours = 40)
}

# Для градиентного графика
smoof_pcontour_grad <- function(f_g, len)
{
  rescale <- \(x, first, last) (last - first) / (max(x) - min(x)) * (x -
                                                                       min(x)) + first
  r_theta <- purrr::compose(unlist, \(args) do.call(DescTools::CartToPol, args) , unname , list)

  d <- smoof_outer(objfn_g, 10)

  df <- dplyr::select(d, dplyr::contains('f')) |>
    purrr::pmap(r_theta) |>
    do.call(rbind, args=_) |>
    tibble::as_tibble() |>
    dplyr::bind_cols(tidyr::crossing(d$x1,d$x2) |> rev() |> purrr::set_names(paste0('x',1:2)))

  u <- smoof::getUpperBoxConstraints(objfn_g)
  l <- smoof::getLowerBoxConstraints(objfn_g)

  df$r <- df$r |> log() |> rescale(0, ((u - l) / 15) |> min())

  fig <- ggplot2::ggplot(df, ggplot2::aes(x1, x2)) +
    ggplot2::geom_point() +
    ggplot2::geom_spoke(ggplot2::aes(angle = theta, radius = r))

  plotly::ggplotly(fig)
}
