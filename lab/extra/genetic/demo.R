aggs <- c('MIN', 'MAX')
selects <- paste0('COL', 1:2)
conds <- paste0('COND', 1:2)
tbls <- paste0('T', 1:3)
g <- igraph::make_empty_graph()


empty <- 'JE'
q1 <- c(list(fun = 'AGGREGATE', val = c(list(
  fun = 'SELECT', val = c(list(
    fun = 'FILTER', val = c(list(fun = 'JOIN', val = empty), tbls), 'SUBQ1'
  ), conds)
), selects)), aggs)
q2 <- c(list(fun = 'SELECT', val = c(list(
  fun = 'FILTER', val = c(list(fun = 'JOIN', val = empty), tbls)
), conds)), selects)
q3 <- c(list(fun = 'SELECT', val = c(list(
  fun = 'FILTER', val = c(list(fun = 'JOIN', val = empty), c('T1', 'T2', 'T5'))
), conds)), c('COL6'))

q4 <- c(list(fun = 'SELECT', val = c(list(
  fun = 'FILTER', val = c(list(fun = 'JOIN', val = empty), c('T1', 'T2', 'T4'))
), conds)), c('COL6'))


add_query(q1, 'Q1')
add_query(q2, 'Q2')
add_query(q3, 'Q3')
add_query(q4, 'Q4')
