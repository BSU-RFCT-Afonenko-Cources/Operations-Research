# Выбрать из датафрейма строки равномерно длиной n и добавить колонку цвета
uni_sample <- \(df, n) dplyr::slice(df, seq(1, nrow(df), length.out = n) |> as.integer())

# Выбрать из датафрейма строки логарифмически (в начале больше) длиной n и добавить колонку цвета
log_sample <- \(df, n) dplyr::slice(df, pracma::logseq(1, nrow(df), n) |> round())

# Выбрать из датафрейма строки логарифмически (в конце больше) длиной n и добавить колонку цвета
rlog_sample <- \(df, n) dplyr::slice(df, nrow(df) + 1  - pracma::logseq(nrow(df), 1, n) |> round())
