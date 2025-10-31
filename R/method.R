#' Choose Optimization Method
#'
#' @param model A coconut_spec object.
#' @param method Optimization algorithm: "standard", "differential_evolution", "particle_swarm", "bee_colony", "genetic_algorithm", "jaya", "cma_es", "generalized_annealing", or "bayesian".
#' @return Updated coconut_spec object.
#' @export
coco_method <- function(
  model,
  method = c(
    "standard",
    "differential_evolution",
    "particle_swarm",
    "bee_colony",
    "genetic_algorithm",
    "jaya",
    "cma_es",
    "generalized_annealing",
    "bayesian"
  )
) {
  method <- match.arg(method)
  if (!inherits(model, "coconut_spec")) {
    stop("model must be a coconut_spec object")
  }
  model$method <- method
  model
}
