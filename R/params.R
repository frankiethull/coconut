#' Set Optimization Parameters
#'
#' @param model A coconut_spec object.
#' @param ... Standardized parameters (lower, upper, pop_size, max_iter, initial) or method-specific controls (via method_control).
#' @return Updated coconut_spec object.
#' @export
coco_params <- \(model, ...) {
  if (!inherits(model, "coconut_spec")) {
    stop("model must be a coconut_spec object")
  }
  model$params <- modifyList(model$params, list(...))
  model
}

# Internal translation functions for engine-specific parameters
translate_standard <- \(params) {
  if (is.null(params$initial)) {
    stop("initial point required for standard")
  }
  list(
    par = params$initial,
    lower = params$lower %||% -Inf,
    upper = params$upper %||% Inf,
    method = params$optim_method %||% "L-BFGS-B",
    control = modifyList(
      list(maxit = params$max_iter %||% 100),
      params$method_control %||% list()
    )
  )
}

translate_differential_evolution <- \(params) {
  list(
    lower = params$lower,
    upper = params$upper,
    control = modifyList(
      list(itermax = params$max_iter %||% 100, NP = params$pop_size %||% 50),
      params$method_control %||% list()
    )
  )
}

translate_particle_swarm <- \(params) {
  if (is.null(params$initial)) {
    stop("initial point required for particle_swarm")
  }
  list(
    par = params$initial,
    lower = params$lower,
    upper = params$upper,
    control = modifyList(
      list(maxit = params$max_iter %||% 100, s = params$pop_size %||% 50),
      params$method_control %||% list()
    )
  )
}

translate_bee_colony <- \(params) {
  if (is.null(params$initial)) {
    stop("initial point required for bee_colony")
  }
  list(
    par = params$initial,
    lb = params$lower,
    ub = params$upper,
    maxCycle = params$max_iter %||% 100,
    FoodNumber = params$pop_size %||% 50
  )
}

translate_genetic_algorithm <- \(params) {
  list(
    lower = params$lower,
    upper = params$upper,
    maxiter = params$max_iter %||% 100,
    popSize = params$pop_size %||% 50
  )
}
translate_jaya <- \(params) {
  list(
    lower = params$lower,
    upper = params$upper,
    popSize = params$pop_size %||% 50,
    maxiter = params$max_iter %||% 100,
    n_var = length(params$lower)
  )
}

translate_cma_es <- \(params) {
  if (is.null(params$initial)) {
    stop("initial point required for cma_es")
  }
  list(
    #   fn = params$objective,
    par = params$initial,
    lower = params$lower,
    upper = params$upper,
    control = modifyList(
      list(
        maxit = params$max_iter %||% 100,
        mu = params$pop_size %||% 50
      ),
      params$method_control %||% list()
    )
  )
}

translate_generalized_annealing <- \(params) {
  if (is.null(params$initial)) {
    stop("initial point required for generalized_annealing")
  }
  list(
    #     fn = params$objective,
    lower = params$lower,
    upper = params$upper,
    par = params$initial,
    control = modifyList(
      list(maxit = params$max_iter %||% 100, max.time = Inf),
      params$method_control %||% list()
    )
  )
}

translate_bayesian <- \(params) {
  if (is.null(params$lower)) {
    stop("lower & upper design required for bayesian (e.g., point bounds)")
  }
  list(
    # fun = smoof::makeSingleObjectiveFunction( ?omg..
    #   name = "objective",
    #   fn = params$objective,
    #   par.set = make_param_set(params$lower, params$upper),
    #   minimize = TRUE !!ah!!
    # ),
    par.set = make_param_set(params$lower, params$upper),
    # design = ParamHelpers::generateDesign(
    #   n = params$pop_size %||% 50,
    #   par.set = par.set
    # ),
    control = (mlrMBO::setMBOControlTermination(
      mlrMBO::makeMBOControl(),
      iters = params$max_iter
    ))
    #,
    # params$method_control %||% list() # not in use, this mlr MBO stuff is kinda difficult to wrap like the rest
    #)
  )
}

# mlr helper
make_param_set <- function(lower, upper) {
  params <- lapply(seq_along(lower), function(i) {
    ParamHelpers::makeNumericParam(
      paste0("X", i),
      lower = lower[i],
      upper = upper[i]
    )
  })
  # Unpack the list of params as separate arguments to makeParamSet()
  do.call(ParamHelpers::makeParamSet, params)
}
