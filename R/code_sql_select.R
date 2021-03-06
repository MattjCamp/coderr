#' Code a SQL SELECT
#'
#' Returns a formated sql SELECT query based on parameters. Useful when automating code
#' @param table_or_sql SQL query or table name that you will select records from
#' @param select.cols the columns that you would like to select
#' @param joins
#' @param filters
#' @param filters.logical
#' @param group.by.cols
#' @param order.by.cols
#' @param alias
#' @keywords coder, sql, query
#' @export
#' @examples

code_sql_select <- function(table_or_sql,
                            select.cols = c("*"),
                            joins = NULL,
                            filters = NULL,
                            filters.logical = "AND",
                            group.by.cols = NULL,
                            order.by.cols = NULL,
                            alias = "RECORDS"){

  library(stringr)

  if (str_detect(str_to_upper(table_or_sql), "SELECT"))
    sql <- sprintf("
        SELECT SELECT_COLS
        FROM (TABLE_NAME) %s
        JOINS
        WHERE_STATEMENT
        GROUP_BY_STATEMENT
        ORDER_BY_STATEMENT", alias)
  else
      sql <- sprintf("
        SELECT SELECT_COLS
        FROM TABLE_NAME %s
        JOINS
        WHERE_STATEMENT
        GROUP_BY_STATEMENT
        ORDER_BY_STATEMENT", alias)

  # SELECT

  if (length(select.cols) == 0)
      stop(sprintf("%s: you must specify at least one SELECT variable",
                   function.name))

  if (length(select.cols) == 1)
    if (select.cols == "")
      stop(sprintf("%s: you must specify at least one SELECT variable",
                   function.name))

  select.cols <- paste(select.cols, collapse = ", ")
  sql <- str_replace(sql, "SELECT_COLS", select.cols)

  # FROM Table

  if ("sql_sample" %in% class(table_or_sql))
    table_or_sql <- table_or_sql[1]

  if (!length(table_or_sql) == 1)
    stop(sprintf("%s: you can specify only exactly one table_or_sql parameter",
                 function.name))

  if (table_or_sql == "")
    stop(sprintf("%s: your table_or_sql parameter cannot be blank",
                 function.name))

  sql <- str_replace(sql, "TABLE_NAME", table_or_sql)

  # Joins

  if (!(length(joins) == 0))
    joins <- paste(joins, collapse = " ")
  else
    joins <- ""

  sql <- str_replace(sql, "JOINS", joins)

  # WHERE Statement

  if (!(length(filters) == 0)) {
    if (!filters[1] == "") {
      filters.logical <- sprintf(" %s ", filters.logical)
      filters <- paste(filters, collapse = filters.logical)
      filters <- sprintf("WHERE %s", filters)
    }else
      filters <- ""
  }else
    filters <- ""

  sql <- str_replace(sql, "WHERE_STATEMENT",
                     filters)

  # GROUP BY

  if (!(length(group.by.cols) == 0)) {
    group.by.cols <- paste(group.by.cols, collapse = ", ")
    group.by.cols <- sprintf("GROUP BY %s", group.by.cols)
  }
  else
    group.by.cols <- ""

  sql <- str_replace(sql, "GROUP_BY_STATEMENT", group.by.cols)

  # ORDER BY

  if (!(length(order.by.cols) == 0)) {
    order.by.cols <- paste(order.by.cols, collapse = ", ")
    order.by.cols <- sprintf("ORDER BY %s", order.by.cols)
  }
  else
    order.by.cols <- ""

  sql <- str_replace(sql, "ORDER_BY_STATEMENT", order.by.cols)

  sql <- gsub("\\s+", " ", str_trim(sql))

  sql

}
