#' Search for Optimization Solution
#'
#' @param model A coconut_spec object with method and params set.
#' @param ... Additional arguments passed to the method.
#' @return A coconut_fit object with solution, value, iterations, and convergence status.
#' @export
coco_search <- function(model, ...) {
  if (is.null(model$method)) {
    stop("Method not specified. Use coco_method().")
  }
  if (is.null(model$params$lower) || is.null(model$params$upper)) {
    stop("lower and upper bounds required")
  }

  # Check for required packages
  required_packages <- c(
    "differential_evolution" = "DEoptim",
    "particle_swarm" = "pso",
    "bee_colony" = "ABCoptim",
    "genetic_algorithm" = "GA",
    "jaya" = "Jaya",
    "cma_es" = "cmaes",
    "generalized_annealing" = "GenSA",
    "bayesian" = "mlrMBO"
  )
  if (
    model$method %in%
      names(required_packages) &&
      !requireNamespace(required_packages[model$method], quietly = TRUE)
  ) {
    stop(sprintf(
      "%s package required for method '%s'. Install it using install.packages('%s')",
      required_packages[model$method],
      model$method,
      required_packages[model$method]
    ))
  }

  # Handle maximization
  obj_fun <- if (model$mode == "maximize") {
    function(x) -model$objective(x)
  } else {
    model$objective
  }

  # Translate standardized parameters to engine-specific ones
  params <- switch(
    model$method,
    "standard" = translate_standard(model$params),
    "differential_evolution" = translate_differential_evolution(model$params),
    "particle_swarm" = translate_particle_swarm(model$params),
    "bee_colony" = translate_bee_colony(model$params),
    "genetic_algorithm" = translate_genetic_algorithm(model$params),
    "jaya" = translate_jaya(model$params),
    "cma_es" = translate_cma_es(model$params),
    "generalized_annealing" = translate_generalized_annealing(model$params),
    "bayesian" = translate_bayesian(model$params),
    stop("Unknown method specified")
  )

  # Run optimization
  # should prob return the whole model in a slot
  result <- switch(
    model$method,
    "standard" = {
      opt_result <- do.call(optim, c(list(fn = obj_fun), params, ...))
      list(
        solution = opt_result$par,
        value = if (model$mode == "maximize") {
          -opt_result$value
        } else {
          opt_result$value
        },
        iterations = opt_result$counts["function"],
        convergence = opt_result$convergence
      )
    },
    "differential_evolution" = {
      de_result <- do.call(DEoptim::DEoptim, c(list(fn = obj_fun), params, ...))
      list(
        solution = de_result$optim$bestmem,
        value = if (model$mode == "maximize") {
          -de_result$optim$bestval
        } else {
          de_result$optim$bestval
        },
        iterations = de_result$optim$iter,
        convergence = de_result$optim$converged
      )
    },
    "particle_swarm" = {
      pso_result <- do.call(pso::psoptim, c(list(fn = obj_fun), params, ...))
      list(
        solution = pso_result$par,
        value = if (model$mode == "maximize") {
          -pso_result$value
        } else {
          pso_result$value
        },
        iterations = pso_result$counts[[2]],
        convergence = pso_result$convergence
      )
    },
    "bee_colony" = {
      abc_result <- do.call(
        ABCoptim::abc_optim,
        c(list(fn = obj_fun), params, ...)
      )
      list(
        solution = abc_result$par,
        value = if (model$mode == "maximize") {
          -abc_result$value
        } else {
          abc_result$value
        },
        iterations = abc_result$counts[[1]],
        convergence = "" # abc_result$counts[[1]] <= params$max_iter, TODO need to test when abc does not converge !!!
      )
    },
    "genetic_algorithm" = {
      ga_result <- do.call(
        GA::ga,
        c(
          list(
            type = "real-valued",
            fitness = if (model$mode == "maximize") {
              obj_fun
            } else {
              \(x) -obj_fun(x)
            }
          ),
          params,
          ...
        )
      )
      list(
        solution = ga_result@solution,
        value = ga_result@fitnessValue,
        iterations = ga_result@iter,
        convergence = "" # ga_result$iter <= ga_results$maxiter, TODO need to test when ga does not converge !!!
      )
    },
    "jaya" = {
      jaya_result <- do.call(
        Jaya::jaya,
        c(
          params,
          list(
            fun = obj_fun, #,
            # seed = 123,  reproducible but suboptimal ?
            # patience = 200,
            opt = if (model$mode == "minimize") "minimize" else "maximize"
          )
        )
      )
      list(
        solution = jaya_result$Best[, -ncol(jaya_result$Best)] |>
          as.matrix() |>
          as.vector(),
        value = jaya_result$Best[, ncol(jaya_result$Best)],
        iterations = length(jaya_result$Iterations),
        convergence = "" # doesn't seem to have a convergence val
      )
    },
    "cma_es" = {
      cma_result <- do.call(cmaes::cma_es, c(list(fn = obj_fun), params, ...))
      list(
        solution = cma_result$par,
        value = cma_result$value,
        iterations = cma_result$counts[["function"]],
        convergence = cma_result$convergence # each package has different conventions, need to come up with a coconut, "yes/no"
      )
    },
    "generalized_annealing" = {
      gensa_result <- do.call(GenSA::GenSA, c(list(fn = obj_fun), params, ...))
      list(
        solution = gensa_result$par,
        value = gensa_result$value,
        iterations = gensa_result$counts,
        convergence = "" #  doesn't seem to have a convergence note
      )
    },
    "bayesian" = {
      mbo_result <- do.call(
        mlrMBO::mbo,
        c(
          #params,
          list(
            fun = smoof::makeSingleObjectiveFunction(
              name = "objective",
              fn = obj_fun,
              par.set = params$par.set,
              minimize = (model$mode == "minimize")
            ),
            design = ParamHelpers::generateDesign(
              n = params$pop_size %||% 50,
              par.set = params$par.set
            ),
            learner = mlr::makeLearner(
              "regr.km",
              predict.type = "se",
              covtype = "matern3_2",
              nugget.estim = TRUE
            ),
            control = params$control
          )
        )
      )
      list(
        solution = mbo_result$x |> unlist() |> as.vector(),
        value = mbo_result$y,
        iterations = mbo_result$control$iters,
        convergence = ""
      )
    },
    stop("Unknown method specified")
  )

  # Return standardized fit object
  structure(
    list(
      spec = model,
      result = result
      # ?should prob return the whole model class in a slot too
    ),
    class = "coconut_fit"
  )
}
