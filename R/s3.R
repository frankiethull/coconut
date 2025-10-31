# add s3 methods to generics here

# add print to each coco_{fun} via assigning coco_{classes}
# mode, method, params (spec), search (fit)

# testing idea
#' print method for coconut_fit
#' @export
print.coconut_fit <- function(x, ...) {
  cat("coconut results\n")
  cat("Method:", x$spec$method, "\n")
  cat("Mode:", x$spec$mode, "\n")
  cat("Solution:", round(x$result$solution, 4), "\n")
  cat("Value:", round(x$result$value, 4), "\n")
  cat("Iterations:", x$result$iterations, "\n")
  cat("Convergence:", x$result$convergence, "\n")
}

# summary, data.frame, other ?
