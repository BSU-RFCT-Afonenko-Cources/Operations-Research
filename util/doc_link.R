loadNamespace('downlit') |> invisible()
loadNamespace('xml2') |> invisible()

dl <- doc_link <- \(fun) fun |>
  rlang::enquo() |>
  rlang::as_label() |>
  (\(x) paste0('`',x,'`'))() |>
  downlit::downlit_md_string() |>
  gsub('\n','', x=_) |>
  I()
