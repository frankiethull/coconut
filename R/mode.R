#' Create a Coconut Optimization Mode
#'
#' @param objective Function to optimize (minimize or maximize).
#' @param mode Optimization mode: "minimize" or "maximize".
#' @return A coconut_spec object.
#' @export
coco_mode <- function(objective, mode = c("minimize", "maximize")) {
  mode <- match.arg(mode)
  if (!is.function(objective)) {
    stop("objective must be a function")
  }
  structure(
    list(
      objective = objective,
      mode = mode,
      method = NULL,
      params = list()
    ),
    class = "coconut_spec"
  )
}
