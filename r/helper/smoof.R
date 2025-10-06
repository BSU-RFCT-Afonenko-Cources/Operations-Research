# Аналог base::outer для не векторизированной функции smoof
# Возвращает список, с векторами координат x1,x2,x3,...,xn длинами len[[1]],len[[2]],...,len[[n]]
# Элемены f1,f2... содержит массив со значениями функции f на координатной сетке, размера len[[1]]*len[[2]]*...*len[[n]]
# Внешнее произведение, если у функции f несколько значений
smoof_outer <- function(f, len)
{
  nx <- smoof::getNumberOfParameters(f)
  nf <- smoof::getNumberOfObjectives(f)
  len <- if (length(len) == 1)
    rep(len, nx)
  else
    len
  lo <- smoof::getLowerBoxConstraints(f)
  up <- smoof::getUpperBoxConstraints(f)
  x <- purrr::pmap(list(lo, up, len), \(l, u, le) seq(l, u, length.out = le)) |>
    purrr::set_names(paste0('x', seq_len(nx)))
  cf <- purrr::compose(f, base::c)
  do.call(tidyr::crossing, rev(x)) |>
    purrr::pmap(cf) |>
    do.call(rbind, args = _) |>
    (\(m) purrr::map(seq_len(ncol(m)), \(i) array(m[, i], dim = len)))() |>
    purrr::set_names(paste0('f', if (nf > 1)
      seq_len(nf)
      else
        '')) |>
    (\(l) c(x, l))() |>
    tibble::as_tibble()
}

