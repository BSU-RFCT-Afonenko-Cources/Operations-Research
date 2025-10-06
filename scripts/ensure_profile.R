if (!nzchar(Sys.getenv("QUARTO_PROJECT_RENDER_ALL")))
  quit()

profiles <- Sys.getenv('QUARTO_PROFILE') |> stringr::str_split_1(',')
groups <- yaml::read_yaml('_quarto.yml')$profile$group

cat('Профили: ', toString(profiles), '\n')

res <- sapply(groups, \(g) sapply(profiles, \(p) p %in% g))

if (length(profiles) != length(groups))
  stop('Колличество профилей и групп не совпадает')

for (i in seq_len(nrow(res)))
  if (sum(res[i, ]) != 1L)
    stop(paste0('Неизвестный профиль "', dimnames(res)[[1]][[i]], '"\n'))

re <- r'(:::\s+\{\.content-(?:hidden|visible)\s+(?:when|unless)\-profile=\"?(?<profile>[^\"]+)\"?.+\})'

# Включая зависимые qmd используемые в include

in_files <- Sys.getenv('QUARTO_PROJECT_INPUT_FILES') |>
  stringr::str_split_1('\n')

in_text_profiles <- purrr::map(in_files, fs::path_dir) |>
  purrr::discard(\(p) fs::path_abs(p) == fs::path_wd()) |>
  unique() |>
  purrr::map(\(d) fs::dir_ls(
    d,
    type = 'file',
    glob = '*.qmd',
    recurse = TRUE
  )) |>
  purrr::list_c() |>
  union(in_files) |>
  purrr::map_chr(readr::read_file, .progress = TRUE) |>
  stringr::str_match_all(stringr::regex(re)) |>
  purrr::discard(rlang::is_empty) |>
  do.call(rbind, args = _) |>
  (\(m) m[, 2])() |>
  unique()

all_profiles <- unlist(groups)

for (p in in_text_profiles)
  if (!(p %in% all_profiles))
    stop(paste0('Неизвестный профиль "', p, '"\n'))
