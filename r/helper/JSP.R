# njob скаляр целое число работ
# nmachine скаляр целое число машин
# cost_mat матрица по строкам работы, по стобцам машины, на пересечении стоимость.
make_task_data <- function(njob, nmachine, cost_mat)
{
  list(
    njob = njob,
    namchine = nmachine,
    n = njob * nmachine,
    s = max(njob, nmachine),
    t = tidyr::crossing(job = seq_len(njob), machine = seq_len(nmachine)) |>
      dplyr::mutate(cost = cost_mat)
  )
}

# Возвращает матрицу городов как отдельных задач
JSP_to_TSP <- function(task_data)
{
  t <- task_data$t
  n <- task_data$n
  D <- matrix(0, n, n)

  for (i in seq_len(n))
    for (j in seq_len(n))
    {
      if (i == j)
        next

      D[i, j] <- if (t[[i, 'job']] == t[[j, 'job']] ||
                     t[[i, 'machine']] == t[[j, 'machine']])
        t[[i, 'cost']] + t[[j, 'cost']]
      else
        max(t[[i, 'cost']], t[[j, 'cost']])
    }
  D
}

# получает оптимальный путь, возвращает список с оптимальным планированием и стоимостью
TSP_to_JSP <- function(task_data, path)
{
  t <- task_data$t
  s <- task_data$s
  A <- tibble::tibble(
    job = seq_len(task_data$njob) |> rep(length.out = s),
    machine = seq_len(task_data$namchine) |> rep(length.out = s),
    from = 0,
    to = 0
  )

  take_last_to <- \(df)  dplyr::select(df, to) |>
    dplyr::slice_tail() |>
    (\(m) m[[1, 1]])()

  total_cost <- \(df) max(df$to)

  for (o in path)
  {
    j <- t[[o, 'job']]
    m <- t[[o, 'machine']]
    cost <- t[[o, 'cost']]
    mc <- dplyr::filter(A, machine == m) |> take_last_to()
    jc <- dplyr::filter(A, job == j) |> take_last_to()

    from <- max(mc, jc)
    A <- tibble::add_row(
      A,
      from = from,
      to = from + cost,
      job = j,
      machine = m
    )
  }
  A <- dplyr::slice_tail(A, n = -s) |>
    dplyr::mutate(job = factor(job), machine = factor(machine))

  list(schedule = A, cost = total_cost(A))
}


plot_jsp_schedule <- function(sh)
{
  ggplot2::ggplot(sh,
                  ggplot2::aes(
                    x = from,
                    xend = to,
                    y = machine,
                    yend = machine,
                    color = job
                  )) +
    ggplot2::geom_segment(linewidth = 5) +
    ggplot2::xlab(NULL) + ggplot2::ylab(NULL)
}
