source('sql.R')

# Загрузка запросов
tbl <- yaml::read_yaml('database.yaml') |> purrr::map('name')
q <- yaml::read_yaml('queries.yaml')
qs <- q$queries
sqs <- q$subqueries

# В граф добавляются все постоянные агрументы запросов:
# JOIN,FROM - таблицы
# WHERE     - условия
# SELECT    - столбцы
# AGGREGATE - функции
all_queries <- c(qs, sqs)

g <- init_graph()
g <- purrr::reduce(tbl, add_table, .init = g)
g <- get_column_names(all_queries) |>
  purrr::reduce(add_column, .init = g)
g <- get_aggregate_names(all_queries) |>
  purrr::reduce(add_aggregate, .init = g)
g <- get_condition_names(all_queries) |>
  purrr::reduce(add_condition, .init = g)


# В граф добавляются сначала подзапросы, потом запросы
purrr::walk2(
  purrr::map(sqs, 'body') |>
    purrr::map(make_list_query),
  purrr::map(sqs, 'name'),
  add_subquery
)

purrr::walk2(
  purrr::map(qs, 'body') |>
    purrr::map(make_list_query),
  purrr::map(qs, 'name'),
  add_query
)

# В графе определяются общие узлы, с последующим слиянием
merge_graph()

# Сохранить в файл
igraph::write_graph(g,'plan.graphml',format = 'graphml')
readr::write_csv(igraph::as_data_frame(g, 'vertices'), 'vertex.csv')
readr::write_csv(igraph::as_data_frame(g, 'edges'), 'edges.csv')
