#' Run Optimization Workflow for Parameter Search
#'
#' @param spec A coconut_spec object with method and params set.
#' @param initial_points A matrix or data frame of initial points (rows = points, columns = parameters).
#' @param return Return "best" solution or "all" results.
#' @param ... Additional arguments passed to coco_search().
#' @return A coconut_fit object (for return = "best") or a list of coconut_fit objects (for return = "all").
#' @export
coco_workflow <- function(
  spec,
  initial_points,
  return = c("best", "all"),
  ...
) {
  return <- match.arg(return)
  if (!inherits(spec, "coconut_spec")) {
    stop("spec must be a coconut_spec object")
  }
  if (is.null(spec$method)) {
    stop("Method not specified in spec. Use coco_method().")
  }
  if (!is.matrix(initial_points) && !is.data.frame(initial_points)) {
    stop("initial_points must be a matrix or data frame")
  }
  initial_points <- as.matrix(initial_points)

  # Run coco_search for each initial point
  results <- lapply(1:nrow(initial_points), function(i) {
    new_spec <- coco_params(spec, initial = initial_points[i, ])
    coco_search(new_spec, ...)
  })

  # Return best result or all results
  if (return == "best" && length(results) > 1) {
    values <- sapply(results, function(r) r$result$value)
    best_idx <- if (spec$mode == "minimize") {
      which.min(values)
    } else {
      which.max(values)
    }
    return(results[[best_idx]])
  } else {
    return(results)
  }
}
