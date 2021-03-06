#' @rdname weighted_sd
#' @export
weighted_chisqtest <- function(data, ...) {
  UseMethod("weighted_chisqtest")
}

#' @importFrom dplyr select
#' @rdname weighted_sd
#' @export
weighted_chisqtest.default <- function(data, x, y, weights, ...) {
  x.name <- deparse(substitute(x))
  y.name <- deparse(substitute(y))
  w.name <- deparse(substitute(weights))

  if (w.name == "NULL") {
    w.name <- "weights"
    data$weights <- 1
  }

  # create string with variable names
  vars <- c(x.name, y.name, w.name)

  # get data
  dat <- suppressMessages(dplyr::select(data, !! vars))
  dat <- na.omit(dat)

  colnames(dat)[3] <- ".weights"
  crosstable_statistics(data = dat, statistics = "auto", weights = ".weights", ...)
}


#' @importFrom stats xtabs
#' @rdname weighted_sd
#' @export
weighted_chisqtest.formula <- function(formula, data, ...) {
  vars <- all.vars(formula)

  if (length(vars) < 3) {
    vars <- c(vars, ".weights")
    data$.weights <- 1
  }

  tab <- as.table(round(stats::xtabs(data[[vars[3]]] ~ data[[vars[1]]] + data[[vars[2]]])))
  class(tab) <- "table"
  crosstable_statistics(data = tab, statistics = "auto", weights = NULL, ...)
}
