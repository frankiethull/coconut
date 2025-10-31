#' Generate Initial Points for Optimization
#'
#' @param n Number of initial points to generate.
#' @param lb Lower bounds for parameters.
#' @param ub Upper bounds for parameters.
#' @param method Sampling method: "uniform", "lhs", or "sobol".
#' @return A matrix of initial points (n rows, length(lb) columns).
#' @export
coco_initial <- function(n, lb, ub, method = c("uniform", "lhs", "sobol")) {
  method <- match.arg(method)
  if (length(lb) != length(ub)) {
    stop("lb and ub must have the same length")
  }
  if (any(lb >= ub)) {
    stop("lb must be less than ub")
  }
  if (n < 1) {
    stop("n must be positive")
  }

  if (method == "uniform") {
    return(matrix(runif(n * length(lb), lb, ub), nrow = n, byrow = TRUE))
  } else if (method == "lhs") {
    if (!requireNamespace("lhs", quietly = TRUE)) {
      stop(
        "lhs package required for method 'lhs'. Install it using install.packages('lhs')"
      )
    }
    return(lhs::randomLHS(n, length(lb)) * (ub - lb) + lb)
  } else if (method == "sobol") {
    if (!requireNamespace("randtoolbox", quietly = TRUE)) {
      stop(
        "randtoolbox package required for method 'sobol'. Install it using install.packages('randtoolbox')"
      )
    }
    return(randtoolbox::sobol(n, dim = length(lb)) * (ub - lb) + lb)
  }
}
