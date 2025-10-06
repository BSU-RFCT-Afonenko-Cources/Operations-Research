nloptr_formals_present <- function(args)
{
  nloptr::nloptr |>
    formalArgs() |>
    stringr::str_subset('eval*') |>
    purrr::discard(\(name) is.null(args[[name]]))
}

nloptr_trace_path <- function(...)
{
  args <- list(...)
  r <- list()

  nloptr_formals_present(args) |>
    purrr::keep(\(name) is(args[[name]], 'smoof_function')) |>
    purrr::walk(\(name){
      f <- args[[name]]
      args[[name]] <<- \(par) f(par)
    })

  for (i in seq_len(500))
  {
    args$opts$maxeval <- i
    res <- do.call(nloptr::nloptr, args)
    r[[i]] <- c(res$solution, res$objective)
    if (res$status != 5)
      break
  }
  df <- do.call(rbind,r) |> unique() |> as.data.frame()
  n <- paste0('x',seq_along(r[[1]]))
  n[length(n)] <- 'obj'
  colnames(df) <- n
  df
}

nloptr_trace_eval <- function(...)
{
  args <- list(...)

  eval_fn <- nloptr_formals_present(args) |>
    purrr::set_names() |>
    purrr::map(\(name){
      f <- smoof::addLoggingWrapper(args[[name]], logg.x = TRUE, size  = 200L)
      args[[name]] <<- \(par) f(par)
      f
    })
  do.call(nloptr::nloptr, args)
  purrr::map(eval_fn, \(f) smoof::getLoggedValues(f, compact = TRUE))
}

nloptr_trace <- function(...)
{
  e <- nloptr_trace_eval(...)
  list(path = nloptr_trace_path(...),
       eval = e,
       count = purrr::map(e, nrow) |>
         (\(e) tibble::tibble(func = names(e), count = as.numeric(e)))()
       )
}
