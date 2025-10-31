
<!-- README.md is generated from README.Rmd. Please edit that file -->

# coconut <img src="man/figures/logo.png" align="right" height="222" alt="" />

<!-- badges: start -->

<!-- badges: end -->

The goal of coconut is to optimize with ease.

## Installation

You can install the development version of coconut from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("frankiethull/coconut")
```

## what is coconut

coconut is a prototype optimizer interface. built with the intent to
swap optimizers easily without worrying about individual library
minutae.

staging ols to solve for m & b.

``` r
library(coconut)
set.seed(13)

# hidden parameters to find
m0 <- .20
b0 <- 10

x <- rnorm(n = 30) * 100
y <- m0 * x + b0

line <- function(par) {
  m <- par[1]
  b <- par[2]

  ## see if model can find m and b by shrinking SSE
  sse <- sum((y - (x * m + b))^2)
  sse
}
```

typical linear model solution:

``` r
# solving for b0 & m0
lm_analytic <- lm(y ~ x)
lm_analytic$coefficients
#> (Intercept)           x 
#>        10.0         0.2
```

coconut is designed to minimize/maximize an objective function for any
optimizer. various kinds of optimizers are scattered across various
individual packages in R. supported optimizers are showcased below.

### optimization methods

#### Standards

base R supported optimizers

``` r
result <-
  coco_mode(objective = line, mode = "minimize") |>
  coco_method("standard") |>
  coco_params(
    lower = c(-5, -5),
    upper = c(5, 20),
    initial = c(0, 0),
    pop_size = 50,
    max_iter = 200
  ) |>
  coco_search()

print(result)
#> coconut results
#> Method: standard 
#> Mode: minimize 
#> Solution: 0.2 10 
#> Value: 0 
#> Iterations: 11 
#> Convergence: 0
```

#### Differential Evolution

based on {DEoptim}

``` r
result_de <-
  coco_mode(objective = line, mode = "minimize") |>
  coco_method("differential_evolution") |>
  coco_params(
    lower = c(-5, -5),
    upper = c(5, 20),
    pop_size = 50,
    max_iter = 200,
    initial = c(0, 0), # not necessary for DE
    # method control is experimental entry for some optimizers
    method_control = list(strategy = 2) # DEoptim-specific control
  ) |>
  coco_search()
#> Iteration: 1 bestvalit: 6816.192787 bestmemit:    0.063904   16.556512
#> Iteration: 2 bestvalit: 6816.192787 bestmemit:    0.063904   16.556512
#> Iteration: 3 bestvalit: 2148.244196 bestmemit:    0.271300   14.375825
#> Iteration: 4 bestvalit: 342.433892 bestmemit:    0.217887   12.829668
#> Iteration: 5 bestvalit: 342.433892 bestmemit:    0.217887   12.829668
#> Iteration: 6 bestvalit: 214.130431 bestmemit:    0.213090   12.302715
#> Iteration: 7 bestvalit: 39.726209 bestmemit:    0.206427    9.036802
#> Iteration: 8 bestvalit: 39.726209 bestmemit:    0.206427    9.036802
#> Iteration: 9 bestvalit: 39.726209 bestmemit:    0.206427    9.036802
#> Iteration: 10 bestvalit: 20.900887 bestmemit:    0.208164    9.834109
#> Iteration: 11 bestvalit: 20.900887 bestmemit:    0.208164    9.834109
#> Iteration: 12 bestvalit: 0.657968 bestmemit:    0.201151    9.905629
#> Iteration: 13 bestvalit: 0.657968 bestmemit:    0.201151    9.905629
#> Iteration: 14 bestvalit: 0.657968 bestmemit:    0.201151    9.905629
#> Iteration: 15 bestvalit: 0.657968 bestmemit:    0.201151    9.905629
#> Iteration: 16 bestvalit: 0.657968 bestmemit:    0.201151    9.905629
#> Iteration: 17 bestvalit: 0.657968 bestmemit:    0.201151    9.905629
#> Iteration: 18 bestvalit: 0.033409 bestmemit:    0.199985   10.033363
#> Iteration: 19 bestvalit: 0.033409 bestmemit:    0.199985   10.033363
#> Iteration: 20 bestvalit: 0.033409 bestmemit:    0.199985   10.033363
#> Iteration: 21 bestvalit: 0.033409 bestmemit:    0.199985   10.033363
#> Iteration: 22 bestvalit: 0.033409 bestmemit:    0.199985   10.033363
#> Iteration: 23 bestvalit: 0.033409 bestmemit:    0.199985   10.033363
#> Iteration: 24 bestvalit: 0.033409 bestmemit:    0.199985   10.033363
#> Iteration: 25 bestvalit: 0.033409 bestmemit:    0.199985   10.033363
#> Iteration: 26 bestvalit: 0.023036 bestmemit:    0.200099   10.025688
#> Iteration: 27 bestvalit: 0.002586 bestmemit:    0.200055   10.007326
#> Iteration: 28 bestvalit: 0.002586 bestmemit:    0.200055   10.007326
#> Iteration: 29 bestvalit: 0.001005 bestmemit:    0.200055   10.001748
#> Iteration: 30 bestvalit: 0.001005 bestmemit:    0.200055   10.001748
#> Iteration: 31 bestvalit: 0.001005 bestmemit:    0.200055   10.001748
#> Iteration: 32 bestvalit: 0.000179 bestmemit:    0.199992    9.997711
#> Iteration: 33 bestvalit: 0.000157 bestmemit:    0.199989   10.002011
#> Iteration: 34 bestvalit: 0.000157 bestmemit:    0.199989   10.002011
#> Iteration: 35 bestvalit: 0.000157 bestmemit:    0.199989   10.002011
#> Iteration: 36 bestvalit: 0.000099 bestmemit:    0.199986   10.001126
#> Iteration: 37 bestvalit: 0.000099 bestmemit:    0.199986   10.001126
#> Iteration: 38 bestvalit: 0.000023 bestmemit:    0.199992    9.999833
#> Iteration: 39 bestvalit: 0.000013 bestmemit:    0.199997   10.000599
#> Iteration: 40 bestvalit: 0.000013 bestmemit:    0.199997   10.000599
#> Iteration: 41 bestvalit: 0.000008 bestmemit:    0.200000    9.999493
#> Iteration: 42 bestvalit: 0.000008 bestmemit:    0.200000    9.999493
#> Iteration: 43 bestvalit: 0.000001 bestmemit:    0.200002    9.999933
#> Iteration: 44 bestvalit: 0.000001 bestmemit:    0.200002    9.999933
#> Iteration: 45 bestvalit: 0.000001 bestmemit:    0.200002    9.999933
#> Iteration: 46 bestvalit: 0.000000 bestmemit:    0.199999    9.999945
#> Iteration: 47 bestvalit: 0.000000 bestmemit:    0.199999    9.999945
#> Iteration: 48 bestvalit: 0.000000 bestmemit:    0.199999    9.999945
#> Iteration: 49 bestvalit: 0.000000 bestmemit:    0.200000   10.000032
#> Iteration: 50 bestvalit: 0.000000 bestmemit:    0.200000   10.000032
#> Iteration: 51 bestvalit: 0.000000 bestmemit:    0.200000   10.000005
#> Iteration: 52 bestvalit: 0.000000 bestmemit:    0.200000   10.000005
#> Iteration: 53 bestvalit: 0.000000 bestmemit:    0.200000   10.000005
#> Iteration: 54 bestvalit: 0.000000 bestmemit:    0.200000   10.000005
#> Iteration: 55 bestvalit: 0.000000 bestmemit:    0.200000   10.000005
#> Iteration: 56 bestvalit: 0.000000 bestmemit:    0.200000   10.000005
#> Iteration: 57 bestvalit: 0.000000 bestmemit:    0.200000   10.000005
#> Iteration: 58 bestvalit: 0.000000 bestmemit:    0.200000   10.000005
#> Iteration: 59 bestvalit: 0.000000 bestmemit:    0.200000    9.999998
#> Iteration: 60 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 61 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 62 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 63 bestvalit: 0.000000 bestmemit:    0.200000   10.000001
#> Iteration: 64 bestvalit: 0.000000 bestmemit:    0.200000   10.000001
#> Iteration: 65 bestvalit: 0.000000 bestmemit:    0.200000   10.000001
#> Iteration: 66 bestvalit: 0.000000 bestmemit:    0.200000   10.000001
#> Iteration: 67 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 68 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 69 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 70 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 71 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 72 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 73 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 74 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 75 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 76 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 77 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 78 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 79 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 80 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 81 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 82 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 83 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 84 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 85 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 86 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 87 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 88 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 89 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 90 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 91 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 92 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 93 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 94 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 95 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 96 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 97 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 98 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 99 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 100 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 101 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 102 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 103 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 104 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 105 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 106 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 107 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 108 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 109 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 110 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 111 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 112 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 113 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 114 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 115 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 116 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 117 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 118 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 119 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 120 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 121 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 122 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 123 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 124 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 125 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 126 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 127 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 128 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 129 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 130 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 131 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 132 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 133 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 134 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 135 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 136 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 137 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 138 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 139 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 140 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 141 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 142 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 143 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 144 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 145 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 146 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 147 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 148 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 149 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 150 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 151 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 152 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 153 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 154 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 155 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 156 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 157 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 158 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 159 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 160 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 161 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 162 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 163 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 164 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 165 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 166 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 167 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 168 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 169 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 170 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 171 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 172 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 173 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 174 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 175 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 176 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 177 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 178 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 179 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 180 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 181 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 182 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 183 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 184 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 185 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 186 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 187 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 188 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 189 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 190 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 191 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 192 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 193 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 194 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 195 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 196 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 197 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 198 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 199 bestvalit: 0.000000 bestmemit:    0.200000   10.000000
#> Iteration: 200 bestvalit: 0.000000 bestmemit:    0.200000   10.000000

print(result_de)
#> coconut results
#> Method: differential_evolution 
#> Mode: minimize 
#> Solution: 0.2 10 
#> Value: 0 
#> Iterations: 200 
#> Convergence:
```

#### Particle Swarm

based on {pso}

``` r
result_pso <-
  coco_mode(objective = line, mode = "minimize") |>
  coco_method("particle_swarm") |>
  coco_params(
    lower = c(-5, -5),
    upper = c(5, 20),
    pop_size = 30,
    max_iter = 100,
    initial = c(0, 0),
    method_control = list(w = 0.01) # PSO-specific inertia weight,
  ) |>
  coco_search()

print(result_pso)
#> coconut results
#> Method: particle_swarm 
#> Mode: minimize 
#> Solution: 0.2 10 
#> Value: 0 
#> Iterations: 100 
#> Convergence: 2
```

#### Artificial Bee Colony

based on {ABCoptim}

``` r
result_abc <-
  coco_mode(objective = line, mode = "minimize") |>
  coco_method("bee_colony") |>
  coco_params(
    lower = c(-5, -5),
    upper = c(5, 20),
    pop_size = 30,
    max_iter = 100,
    initial = c(0, 0)
  ) |>
  coco_search()

print(result_abc)
#> coconut results
#> Method: bee_colony 
#> Mode: minimize 
#> Solution: 0.2 10 
#> Value: 0 
#> Iterations: 100 
#> Convergence:
```

#### Genetic Algorithm

based on {GA}

``` r
result_ga <-
  coco_mode(objective = line, mode = "minimize") |>
  coco_method("genetic_algorithm") |>
  coco_params(
    lower = c(-5, -5),
    upper = c(5, 30),
    pop_size = 40,
    max_iter = 200,
    initial = c(0, 0)
  ) |>
  coco_search()

print(result_ga)
#> coconut results
#> Method: genetic_algorithm 
#> Mode: minimize 
#> Solution: 0.2 10.003 
#> Value: -7e-04 
#> Iterations: 200 
#> Convergence:
```

#### Jaya

based on {Jaya}

``` r
result_jaya <-
  coco_mode(objective = line, mode = "minimize") |>
  coco_method("jaya") |>
  coco_params(
    lower = c(-5, -5),
    upper = c(5, 20),
    pop_size = 30,
    max_iter = 100,
    initial = c(0, 0) # not necessary for jaya
  ) |>
  coco_search()

print(result_jaya)
#> coconut results
#> Method: jaya 
#> Mode: minimize 
#> Solution: 0.4017 -1.1813 
#> Value: 0 
#> Iterations: 100 
#> Convergence:
```

#### Covariance Matrix Adapting Evolution Strategy

based on {cmaes}

``` r
result_cma <-
  coco_mode(objective = line, mode = "minimize") |>
  coco_method("cma_es") |>
  coco_params(
    lower = c(-5, -5),
    upper = c(5, 20),
    pop_size = 30,
    max_iter = 100,
    initial = c(0, 0),
    method_control = list(lambda = 40) # num of offspring (greater than pop size)
  ) |>
  coco_search()

print(result_cma)
#> coconut results
#> Method: cma_es 
#> Mode: minimize 
#> Solution: 0.2 10 
#> Value: 0 
#> Iterations: 4000 
#> Convergence: 1
```

#### Generalized Simulated Annealing

based on {GenSA}

``` r
result_gsa <-
  coco_mode(objective = line, mode = "minimize") |>
  coco_method("generalized_annealing") |>
  coco_params(
    lower = c(-5, -5),
    upper = c(5, 20),
    pop_size = 30,
    max_iter = 100,
    initial = c(0, 0)
  ) |>
  coco_search()

print(result_gsa)
#> coconut results
#> Method: generalized_annealing 
#> Mode: minimize 
#> Solution: 0.2 10 
#> Value: 0 
#> Iterations: 437 
#> Convergence:
```

#### Bayesian Optimization

based on {mlrMBO}

``` r
result_bayes <-
  coco_mode(objective = line, mode = "minimize") |>
  coco_method("bayesian") |>
  coco_params(
    lower = c(-5, -5),
    upper = c(5, 20),
    pop_size = 30,
    max_iter = 100,
    initial = c(0, 0) # ignored for bayes, instead creates a mesh of points across the lb/ub range
  ) |>
  coco_search()
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 48.67013 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -701.7794 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       701.78  |proj g|=       2.4301
#> At iterate     1  f =        686.6  |proj g|=        1.5758
#> ys=-8.425e-01  -gs= 1.487e+01, BFGS update SKIPPED
#> At iterate     2  f =       683.48  |proj g|=        1.5305
#> At iterate     3  f =       678.57  |proj g|=        1.3926
#> At iterate     4  f =       675.27  |proj g|=         1.239
#> At iterate     5  f =       672.16  |proj g|=        1.0445
#> At iterate     6  f =       671.13  |proj g|=        1.0128
#> At iterate     7  f =       670.99  |proj g|=        1.0114
#> At iterate     8  f =       660.97  |proj g|=       0.79115
#> Nonpositive definiteness in Cholesky factorization in formk;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate     9  f =       659.63  |proj g|=       0.20391
#> At iterate    10  f =       659.58  |proj g|=       0.12114
#> At iterate    11  f =       659.56  |proj g|=      0.017196
#> At iterate    12  f =       659.56  |proj g|=     0.0012216
#> At iterate    13  f =       659.56  |proj g|=    1.0275e-05
#> At iterate    14  f =       659.56  |proj g|=    1.3701e-06
#> 
#> iterations 14
#> function evaluations 50
#> segments explored during Cauchy searches 19
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 1.37012e-06
#> final function value 659.559
#> 
#> F = 659.559
#> final  value 659.559300 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 48.67013 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -721.2628 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       721.26  |proj g|=       9.0561
#> At iterate     1  f =       676.13  |proj g|=       0.90458
#> ys=-2.480e+03  -gs= 9.129e+01, BFGS update SKIPPED
#> At iterate     2  f =        671.7  |proj g|=       0.26159
#> At iterate     3  f =       671.68  |proj g|=       0.22275
#> At iterate     4  f =       671.62  |proj g|=      0.023988
#> At iterate     5  f =       671.62  |proj g|=     0.0024984
#> At iterate     6  f =       671.62  |proj g|=    3.3905e-05
#> At iterate     7  f =       671.62  |proj g|=     6.086e-07
#> 
#> iterations 7
#> function evaluations 23
#> segments explored during Cauchy searches 8
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 6.08598e-07
#> final function value 671.618
#> 
#> F = 671.618
#> final  value 671.617663 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.33389 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -715.4698 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       715.47  |proj g|=       1.8754
#> At iterate     1  f =       698.22  |proj g|=        1.1725
#> ys=-2.143e+01  -gs= 1.208e+01, BFGS update SKIPPED
#> At iterate     2  f =       687.18  |proj g|=       0.90506
#> At iterate     3  f =       683.14  |proj g|=       0.57567
#> At iterate     4  f =       683.04  |proj g|=       0.46915
#> At iterate     5  f =       682.81  |proj g|=      0.086111
#> At iterate     6  f =        682.8  |proj g|=      0.015931
#> At iterate     7  f =        682.8  |proj g|=    0.00068806
#> At iterate     8  f =        682.8  |proj g|=    4.9271e-06
#> 
#> iterations 8
#> function evaluations 24
#> segments explored during Cauchy searches 9
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 4.92714e-06
#> final function value 682.802
#> 
#> F = 682.802
#> final  value 682.802488 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.33389 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -719.7575 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       719.76  |proj g|=       2.6751
#> At iterate     1  f =       695.74  |proj g|=       0.79938
#> ys=-2.666e+01  -gs= 1.822e+01, BFGS update SKIPPED
#> At iterate     2  f =       694.02  |proj g|=      0.014341
#> At iterate     3  f =       694.02  |proj g|=      0.014341
#> 
#> iterations 3
#> function evaluations 22
#> segments explored during Cauchy searches 4
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 0.0143408
#> final function value 694.024
#> 
#> F = 694.024
#> Warning:  more than 10 function and gradient evaluations
#>    in the last line search
#> final  value 694.023527 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.33389 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -773.8018 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=        773.8  |proj g|=       3.9965
#> At iterate     1  f =       760.62  |proj g|=        5.8826
#> At iterate     2  f =       727.21  |proj g|=        12.026
#> ys=-1.683e+02  -gs= 1.487e+01, BFGS update SKIPPED
#> At iterate     3  f =       714.01  |proj g|=        3.4427
#> At iterate     4  f =       711.91  |proj g|=        2.1198
#> At iterate     5  f =       710.22  |proj g|=       0.87337
#> At iterate     6  f =       709.79  |proj g|=       0.89817
#> At iterate     7  f =        709.7  |proj g|=       0.91172
#> At iterate     8  f =        709.7  |proj g|=       0.91572
#> At iterate     9  f =        709.7  |proj g|=       0.91625
#> At iterate    10  f =        709.7  |proj g|=       0.91626
#> 
#> iterations 10
#> function evaluations 13
#> segments explored during Cauchy searches 13
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 0.916265
#> final function value 709.696
#> 
#> F = 709.696
#> final  value 709.695605 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.33389 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -783.5221 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       783.52  |proj g|=      0.73632
#> At iterate     1  f =       756.95  |proj g|=        17.479
#> ys=-9.319e+01  -gs= 1.489e+01, BFGS update SKIPPED
#> At iterate     2  f =       744.29  |proj g|=         1.568
#> At iterate     3  f =       733.44  |proj g|=        1.3272
#> At iterate     4  f =       733.36  |proj g|=         1.348
#> At iterate     5  f =       733.36  |proj g|=        1.3474
#> At iterate     6  f =       733.36  |proj g|=        1.3474
#> 
#> iterations 6
#> function evaluations 12
#> segments explored during Cauchy searches 7
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 1.34736
#> final function value 733.364
#> 
#> F = 733.364
#> final  value 733.363608 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.33389 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -823.5484 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       823.55  |proj g|=       3.7871
#> At iterate     1  f =       731.38  |proj g|=       0.97568
#> ys=-2.601e+03  -gs= 3.350e+01, BFGS update SKIPPED
#> At iterate     2  f =       727.03  |proj g|=       0.31955
#> At iterate     3  f =       727.02  |proj g|=       0.32136
#> At iterate     4  f =          727  |proj g|=       0.28406
#> At iterate     5  f =       726.91  |proj g|=      0.033119
#> At iterate     6  f =       726.91  |proj g|=     0.0039103
#> At iterate     7  f =       726.91  |proj g|=    6.5118e-05
#> At iterate     8  f =       726.91  |proj g|=    3.8531e-06
#> 
#> iterations 8
#> function evaluations 22
#> segments explored during Cauchy searches 9
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 3.85305e-06
#> final function value 726.912
#> 
#> F = 726.912
#> final  value 726.911781 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.33389 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -772.4195 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       772.42  |proj g|=       1.1734
#> At iterate     1  f =       763.18  |proj g|=        2.9018
#> ys=-2.927e+00  -gs= 8.457e+00, BFGS update SKIPPED
#> At iterate     2  f =       758.09  |proj g|=        1.5017
#> At iterate     3  f =       757.79  |proj g|=        1.5077
#> At iterate     4  f =       757.59  |proj g|=        1.5133
#> At iterate     5  f =       757.57  |proj g|=        1.5145
#> At iterate     6  f =       757.57  |proj g|=        1.5147
#> At iterate     7  f =       757.57  |proj g|=        1.5147
#> At iterate     8  f =       757.57  |proj g|=        1.5147
#> 
#> iterations 8
#> function evaluations 9
#> segments explored during Cauchy searches 9
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 1.51475
#> final function value 757.568
#> 
#> F = 757.568
#> final  value 757.568239 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.33389 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -839.2611 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       839.26  |proj g|=        3.784
#> At iterate     1  f =       756.11  |proj g|=        1.1077
#> ys=-1.422e+03  -gs= 3.345e+01, BFGS update SKIPPED
#> At iterate     2  f =       750.67  |proj g|=       0.90453
#> At iterate     3  f =        749.5  |proj g|=        0.9865
#> At iterate     4  f =        749.3  |proj g|=       0.82753
#> At iterate     5  f =       748.77  |proj g|=       0.19095
#> At iterate     6  f =       748.73  |proj g|=      0.047728
#> At iterate     7  f =       748.73  |proj g|=     0.0038113
#> At iterate     8  f =       748.73  |proj g|=     8.149e-05
#> At iterate     9  f =       748.73  |proj g|=    2.4875e-06
#> 
#> iterations 9
#> function evaluations 24
#> segments explored during Cauchy searches 10
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 2.48749e-06
#> final function value 748.73
#> 
#> F = 748.73
#> final  value 748.730118 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -824.9399 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       824.94  |proj g|=       2.0719
#> At iterate     1  f =       809.02  |proj g|=        3.2472
#> ys=-1.772e+01  -gs= 1.100e+01, BFGS update SKIPPED
#> At iterate     2  f =       800.22  |proj g|=        2.4072
#> At iterate     3  f =       798.92  |proj g|=        2.3608
#> At iterate     4  f =       797.28  |proj g|=        2.2486
#> At iterate     5  f =        796.5  |proj g|=        2.1412
#> At iterate     6  f =          796  |proj g|=        2.0165
#> At iterate     7  f =       795.72  |proj g|=         1.895
#> At iterate     8  f =       795.67  |proj g|=        1.8621
#> At iterate     9  f =       795.67  |proj g|=        1.8621
#> 
#> iterations 9
#> function evaluations 17
#> segments explored during Cauchy searches 10
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 1.8621
#> final function value 795.674
#> 
#> F = 795.674
#> final  value 795.673730 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -841.7607 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       841.76  |proj g|=       2.3288
#> At iterate     1  f =       825.92  |proj g|=        5.1139
#> ys=-1.244e+01  -gs= 1.317e+01, BFGS update SKIPPED
#> At iterate     2  f =       815.28  |proj g|=        2.6939
#> At iterate     3  f =       815.21  |proj g|=        2.6883
#> At iterate     4  f =       815.06  |proj g|=        2.6628
#> At iterate     5  f =       815.05  |proj g|=        2.6546
#> At iterate     6  f =       815.05  |proj g|=         2.652
#> At iterate     7  f =       815.05  |proj g|=        2.6517
#> At iterate     8  f =       815.05  |proj g|=        2.6517
#> 
#> iterations 8
#> function evaluations 9
#> segments explored during Cauchy searches 9
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 2.65173
#> final function value 815.053
#> 
#> F = 815.053
#> final  value 815.053368 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -849.3843 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       849.38  |proj g|=       3.1827
#> At iterate     1  f =       809.07  |proj g|=        1.8909
#> ys=-1.001e+02  -gs= 2.520e+01, BFGS update SKIPPED
#> At iterate     2  f =       804.37  |proj g|=        1.7201
#> At iterate     3  f =       795.69  |proj g|=        1.3088
#> At iterate     4  f =       795.18  |proj g|=         1.885
#> At iterate     5  f =       795.18  |proj g|=         1.929
#> At iterate     6  f =       795.18  |proj g|=         1.922
#> At iterate     7  f =       795.18  |proj g|=        1.9222
#> 
#> iterations 7
#> function evaluations 11
#> segments explored during Cauchy searches 8
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 1.92217
#> final function value 795.181
#> 
#> F = 795.181
#> final  value 795.181430 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -844.6133 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       844.61  |proj g|=       15.935
#> At iterate     1  f =       806.92  |proj g|=        1.3071
#> ys=-2.150e+03  -gs= 2.622e+02, BFGS update SKIPPED
#> At iterate     2  f =       793.04  |proj g|=       0.92151
#> At iterate     3  f =       793.04  |proj g|=       0.92151
#> 
#> iterations 3
#> function evaluations 19
#> segments explored during Cauchy searches 4
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 0.921506
#> final function value 793.041
#> 
#> F = 793.041
#> Warning:  more than 10 function and gradient evaluations
#>    in the last line search
#> final  value 793.040644 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -898.87 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       898.87  |proj g|=       3.2379
#> At iterate     1  f =       817.83  |proj g|=        1.4186
#> ys=-1.311e+03  -gs= 3.045e+01, BFGS update SKIPPED
#> At iterate     2  f =       803.52  |proj g|=        1.0393
#> At iterate     3  f =       802.81  |proj g|=        1.6777
#> At iterate     4  f =       802.18  |proj g|=         1.201
#> At iterate     5  f =       801.36  |proj g|=       0.34881
#> At iterate     6  f =       801.26  |proj g|=       0.10009
#> At iterate     7  f =       801.25  |proj g|=      0.012053
#> At iterate     8  f =       801.25  |proj g|=    0.00048124
#> At iterate     9  f =       801.25  |proj g|=    1.1925e-06
#> 
#> iterations 9
#> function evaluations 25
#> segments explored during Cauchy searches 10
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 1.19246e-06
#> final function value 801.251
#> 
#> F = 801.251
#> final  value 801.251390 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -897.9632 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       897.96  |proj g|=       7.5092
#> At iterate     1  f =       842.95  |proj g|=        2.0676
#> ys=-2.622e+03  -gs= 7.034e+01, BFGS update SKIPPED
#> At iterate     2  f =       837.86  |proj g|=        1.8611
#> At iterate     3  f =       829.58  |proj g|=        1.7668
#> At iterate     4  f =       829.51  |proj g|=        3.1633
#> At iterate     5  f =        829.4  |proj g|=         2.437
#> At iterate     6  f =       829.39  |proj g|=        2.4938
#> At iterate     7  f =       829.39  |proj g|=        2.4986
#> At iterate     8  f =       829.39  |proj g|=        2.4981
#> 
#> iterations 8
#> function evaluations 12
#> segments explored during Cauchy searches 9
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 2.49813
#> final function value 829.394
#> 
#> F = 829.394
#> final  value 829.393891 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -943.888 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       943.89  |proj g|=       9.1989
#> At iterate     1  f =       891.23  |proj g|=        4.3871
#> At iterate     2  f =       886.47  |proj g|=         8.796
#> At iterate     3  f =       886.15  |proj g|=        11.208
#> At iterate     4  f =       886.13  |proj g|=        10.804
#> At iterate     5  f =       886.13  |proj g|=        10.722
#> At iterate     6  f =       886.09  |proj g|=        10.291
#> At iterate     7  f =       886.01  |proj g|=        9.8064
#> At iterate     8  f =       885.78  |proj g|=         8.939
#> At iterate     9  f =       885.22  |proj g|=        7.6832
#> At iterate    10  f =       883.83  |proj g|=        5.8451
#> At iterate    11  f =       880.55  |proj g|=        3.5325
#> At iterate    12  f =       873.39  |proj g|=        2.8693
#> At iterate    13  f =       861.05  |proj g|=        2.4088
#> At iterate    14  f =       846.23  |proj g|=          1.79
#> At iterate    15  f =       832.73  |proj g|=        1.3011
#> At iterate    16  f =       829.82  |proj g|=        1.2822
#> At iterate    17  f =       824.08  |proj g|=       0.98534
#> At iterate    18  f =       822.22  |proj g|=       0.54133
#> Nonpositive definiteness in Cholesky factorization in formk;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate    19  f =       821.97  |proj g|=       0.37656
#> At iterate    20  f =       821.81  |proj g|=       0.15086
#> At iterate    21  f =       821.79  |proj g|=      0.026253
#> At iterate    22  f =       821.79  |proj g|=     0.0015283
#> At iterate    23  f =       821.79  |proj g|=    1.1382e-05
#> At iterate    24  f =       821.79  |proj g|=    6.8097e-07
#> 
#> iterations 24
#> function evaluations 30
#> segments explored during Cauchy searches 27
#> BFGS updates skipped 0
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 6.80966e-07
#> final function value 821.787
#> 
#> F = 821.787
#> final  value 821.786685 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -922.8668 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       922.87  |proj g|=        3.485
#> At iterate     1  f =       864.27  |proj g|=        2.0714
#> ys=-2.973e+02  -gs= 3.057e+01, BFGS update SKIPPED
#> At iterate     2  f =       858.21  |proj g|=        1.8741
#> At iterate     3  f =       845.84  |proj g|=         2.126
#> At iterate     4  f =       845.82  |proj g|=         1.859
#> At iterate     5  f =       845.82  |proj g|=        1.8592
#> 
#> iterations 5
#> function evaluations 10
#> segments explored during Cauchy searches 6
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 1.85925
#> final function value 845.816
#> 
#> F = 845.816
#> final  value 845.816328 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -953.8012 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=        953.8  |proj g|=       5.5728
#> At iterate     1  f =       912.35  |proj g|=        18.435
#> ys=-3.375e+01  -gs= 5.224e+01, BFGS update SKIPPED
#> At iterate     2  f =       892.64  |proj g|=        2.4518
#> At iterate     3  f =       876.41  |proj g|=        2.2084
#> At iterate     4  f =       876.34  |proj g|=        2.1897
#> At iterate     5  f =       876.34  |proj g|=        2.1888
#> At iterate     6  f =       876.34  |proj g|=        2.1889
#> 
#> iterations 6
#> function evaluations 12
#> segments explored during Cauchy searches 8
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 2.1889
#> final function value 876.344
#> 
#> F = 876.344
#> final  value 876.344304 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -954.3407 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       954.34  |proj g|=       5.8032
#> At iterate     1  f =       931.28  |proj g|=        3.1216
#> At iterate     2  f =       881.54  |proj g|=          6.98
#> ys=-7.213e+02  -gs= 1.886e+01, BFGS update SKIPPED
#> At iterate     3  f =       874.69  |proj g|=        1.6628
#> At iterate     4  f =       874.17  |proj g|=        1.6882
#> At iterate     5  f =        873.9  |proj g|=         1.716
#> At iterate     6  f =       873.88  |proj g|=        1.7244
#> At iterate     7  f =       873.88  |proj g|=        1.7261
#> At iterate     8  f =       873.88  |proj g|=        1.7262
#> 
#> iterations 8
#> function evaluations 10
#> segments explored during Cauchy searches 9
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 1.72621
#> final function value 873.882
#> 
#> F = 873.882
#> final  value 873.881912 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -972.4072 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       972.41  |proj g|=       5.3475
#> At iterate     1  f =       951.12  |proj g|=        1.5907
#> At iterate     2  f =       937.53  |proj g|=        18.109
#> ys=-5.177e+01  -gs= 1.586e+01, BFGS update SKIPPED
#> At iterate     3  f =          926  |proj g|=           3.7
#> At iterate     4  f =       917.62  |proj g|=        3.1741
#> At iterate     5  f =       917.61  |proj g|=        3.1578
#> At iterate     6  f =       917.61  |proj g|=        3.1576
#> 
#> iterations 6
#> function evaluations 10
#> segments explored during Cauchy searches 8
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 3.1576
#> final function value 917.606
#> 
#> F = 917.606
#> final  value 917.605828 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -950.6188 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       950.62  |proj g|=       3.3708
#> At iterate     1  f =        943.3  |proj g|=        15.101
#> At iterate     2  f =       887.59  |proj g|=        11.739
#> ys=-1.022e+03  -gs= 2.890e+01, BFGS update SKIPPED
#> At iterate     3  f =       879.44  |proj g|=         5.978
#> At iterate     4  f =       875.15  |proj g|=        3.0148
#> At iterate     5  f =       873.04  |proj g|=        1.3649
#> At iterate     6  f =        872.3  |proj g|=       0.53294
#> At iterate     7  f =       872.14  |proj g|=       0.16009
#> At iterate     8  f =       872.13  |proj g|=       0.12521
#> At iterate     9  f =       872.13  |proj g|=       0.12579
#> At iterate    10  f =       872.13  |proj g|=       0.12581
#> 
#> iterations 10
#> function evaluations 13
#> segments explored during Cauchy searches 13
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 0.125814
#> final function value 872.126
#> 
#> F = 872.126
#> final  value 872.125925 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -960.839 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       960.84  |proj g|=       4.7182
#> At iterate     1  f =       941.43  |proj g|=        3.3977
#> At iterate     2  f =       924.54  |proj g|=        8.0451
#> At iterate     3  f =       924.54  |proj g|=         8.276
#> At iterate     4  f =       924.54  |proj g|=        8.2011
#> At iterate     5  f =       924.54  |proj g|=        8.1829
#> At iterate     6  f =       924.53  |proj g|=        8.0722
#> At iterate     7  f =       924.53  |proj g|=        7.9237
#> At iterate     8  f =        924.5  |proj g|=        7.6676
#> At iterate     9  f =       924.44  |proj g|=        7.2716
#> At iterate    10  f =       924.11  |proj g|=         6.631
#> At iterate    11  f =       922.45  |proj g|=        4.6653
#> At iterate    12  f =       919.33  |proj g|=         2.729
#> At iterate    13  f =       912.09  |proj g|=        2.0457
#> At iterate    14  f =       900.18  |proj g|=        1.6974
#> At iterate    15  f =       886.14  |proj g|=        1.2905
#> At iterate    16  f =       885.39  |proj g|=         1.256
#> At iterate    17  f =        882.1  |proj g|=       0.41932
#> At iterate    18  f =       881.93  |proj g|=      0.022007
#> At iterate    19  f =       881.93  |proj g|=     0.0041215
#> At iterate    20  f =       881.93  |proj g|=    3.5425e-05
#> At iterate    21  f =       881.93  |proj g|=    5.5734e-06
#> 
#> iterations 21
#> function evaluations 26
#> segments explored during Cauchy searches 22
#> BFGS updates skipped 0
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 5.57336e-06
#> final function value 881.927
#> 
#> F = 881.927
#> final  value 881.926502 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -957.3905 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       957.39  |proj g|=      0.88457
#> At iterate     1  f =       923.65  |proj g|=        8.5254
#> ys=-2.913e+02  -gs= 1.531e+01, BFGS update SKIPPED
#> At iterate     2  f =       916.49  |proj g|=        1.8818
#> At iterate     3  f =       912.92  |proj g|=        1.7997
#> At iterate     4  f =       912.83  |proj g|=        1.8117
#> At iterate     5  f =       912.83  |proj g|=        1.8117
#> 
#> iterations 5
#> function evaluations 8
#> segments explored during Cauchy searches 6
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 1.8117
#> final function value 912.833
#> 
#> F = 912.833
#> final  value 912.833143 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -964.1659 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       964.17  |proj g|=       3.0227
#> At iterate     1  f =       949.35  |proj g|=        2.8272
#> At iterate     2  f =       946.28  |proj g|=        3.5946
#> At iterate     3  f =       946.26  |proj g|=        4.1146
#> At iterate     4  f =       946.26  |proj g|=        3.9456
#> At iterate     5  f =       946.26  |proj g|=        3.9507
#> At iterate     6  f =       946.26  |proj g|=         3.953
#> At iterate     7  f =       946.26  |proj g|=        3.9601
#> At iterate     8  f =       946.26  |proj g|=        3.9695
#> At iterate     9  f =       946.26  |proj g|=        3.9861
#> At iterate    10  f =       946.26  |proj g|=        4.0123
#> At iterate    11  f =       946.26  |proj g|=         4.055
#> At iterate    12  f =       946.25  |proj g|=        4.1233
#> At iterate    13  f =       946.24  |proj g|=        4.2342
#> At iterate    14  f =       946.22  |proj g|=        4.4139
#> At iterate    15  f =       946.17  |proj g|=        4.7086
#> At iterate    16  f =       946.04  |proj g|=        5.1958
#> At iterate    17  f =       945.68  |proj g|=        6.0143
#> At iterate    18  f =       944.72  |proj g|=        7.3922
#> At iterate    19  f =        942.1  |proj g|=        9.6555
#> At iterate    20  f =       934.71  |proj g|=         12.67
#> At iterate    21  f =       916.55  |proj g|=        12.425
#> At iterate    22  f =        910.2  |proj g|=        7.6467
#> At iterate    23  f =       904.63  |proj g|=        3.5997
#> At iterate    24  f =       902.27  |proj g|=        1.7013
#> At iterate    25  f =       901.32  |proj g|=        0.6611
#> At iterate    26  f =        901.1  |proj g|=       0.19468
#> At iterate    27  f =       901.08  |proj g|=      0.032339
#> At iterate    28  f =       901.08  |proj g|=     0.0019513
#> At iterate    29  f =       901.08  |proj g|=     1.342e-05
#> At iterate    30  f =       901.08  |proj g|=    1.1958e-06
#> 
#> iterations 30
#> function evaluations 31
#> segments explored during Cauchy searches 31
#> BFGS updates skipped 0
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 1.19582e-06
#> final function value 901.078
#> 
#> F = 901.078
#> final  value 901.078494 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -986.4166 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       986.42  |proj g|=       15.172
#> At iterate     1  f =       928.62  |proj g|=        1.6659
#> ys=-6.490e+03  -gs= 2.440e+02, BFGS update SKIPPED
#> At iterate     2  f =       917.27  |proj g|=        1.5542
#> At iterate     3  f =       917.27  |proj g|=        1.5542
#> 
#> iterations 3
#> function evaluations 23
#> segments explored during Cauchy searches 4
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 1.55419
#> final function value 917.27
#> 
#> F = 917.27
#> Warning:  more than 10 function and gradient evaluations
#>    in the last line search
#> final  value 917.270044 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -972.1198 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       972.12  |proj g|=       3.9608
#> At iterate     1  f =       922.02  |proj g|=        1.3415
#> ys=-1.766e+02  -gs= 3.369e+01, BFGS update SKIPPED
#> At iterate     2  f =       919.88  |proj g|=       0.31033
#> At iterate     3  f =       919.47  |proj g|=       0.20321
#> At iterate     4  f =       919.46  |proj g|=       0.17388
#> At iterate     5  f =       919.44  |proj g|=      0.013111
#> At iterate     6  f =       919.44  |proj g|=    0.00078092
#> At iterate     7  f =       919.44  |proj g|=    9.2439e-06
#> 
#> iterations 7
#> function evaluations 16
#> segments explored during Cauchy searches 8
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 9.24386e-06
#> final function value 919.444
#> 
#> F = 919.444
#> final  value 919.443858 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1004.116 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1004.1  |proj g|=       3.8685
#> At iterate     1  f =       972.88  |proj g|=        3.5621
#> ys=-2.900e+01  -gs= 3.133e+01, BFGS update SKIPPED
#> At iterate     2  f =       965.09  |proj g|=        2.4346
#> At iterate     3  f =       964.89  |proj g|=        2.4227
#> At iterate     4  f =       964.66  |proj g|=         2.394
#> At iterate     5  f =       964.64  |proj g|=        2.3832
#> At iterate     6  f =       964.64  |proj g|=        2.3795
#> At iterate     7  f =       964.64  |proj g|=        2.3791
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate     8  f =       956.95  |proj g|=        2.1289
#> At iterate     9  f =       949.41  |proj g|=        1.7874
#> At iterate    10  f =       949.07  |proj g|=         2.428
#> At iterate    11  f =       949.06  |proj g|=        2.4684
#> At iterate    12  f =       949.06  |proj g|=        2.4627
#> At iterate    13  f =       949.06  |proj g|=        2.4513
#> At iterate    14  f =       949.06  |proj g|=        2.3931
#> At iterate    15  f =       949.05  |proj g|=        2.3102
#> At iterate    16  f =       949.04  |proj g|=        2.1719
#> At iterate    17  f =       948.99  |proj g|=        1.9586
#> At iterate    18  f =       948.86  |proj g|=        1.7566
#> At iterate    19  f =       948.56  |proj g|=         1.772
#> At iterate    20  f =       947.84  |proj g|=        1.7814
#> At iterate    21  f =       946.16  |proj g|=        1.7613
#> At iterate    22  f =        942.6  |proj g|=        1.6631
#> At iterate    23  f =        936.3  |proj g|=        1.5502
#> At iterate    24  f =       933.65  |proj g|=        1.5447
#> At iterate    25  f =       930.19  |proj g|=        1.0896
#> At iterate    26  f =       928.82  |proj g|=       0.19689
#> At iterate    27  f =        928.8  |proj g|=       0.13363
#> At iterate    28  f =       928.79  |proj g|=     0.0083656
#> At iterate    29  f =       928.79  |proj g|=    0.00032686
#> At iterate    30  f =       928.79  |proj g|=    4.8944e-06
#> 
#> iterations 30
#> function evaluations 40
#> segments explored during Cauchy searches 32
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 4.89439e-06
#> final function value 928.792
#> 
#> F = 928.792
#> final  value 928.792023 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1084.023 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=         1084  |proj g|=        4.883
#> At iterate     1  f =       1050.6  |proj g|=       0.33825
#> At iterate     2  f =       962.25  |proj g|=         16.29
#> ys=-1.043e+04  -gs= 2.283e+01, BFGS update SKIPPED
#> At iterate     3  f =       947.06  |proj g|=        3.8299
#> At iterate     4  f =       945.44  |proj g|=        2.3953
#> At iterate     5  f =       944.12  |proj g|=         1.425
#> At iterate     6  f =       943.88  |proj g|=        1.4403
#> At iterate     7  f =       943.85  |proj g|=         1.447
#> At iterate     8  f =       943.85  |proj g|=        1.4483
#> At iterate     9  f =       943.85  |proj g|=        1.4484
#> At iterate    10  f =       943.85  |proj g|=        1.4484
#> 
#> iterations 10
#> function evaluations 13
#> segments explored during Cauchy searches 12
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 1.44838
#> final function value 943.847
#> 
#> F = 943.847
#> final  value 943.846683 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1028.906 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1028.9  |proj g|=       5.4304
#> At iterate     1  f =       971.62  |proj g|=        13.632
#> ys=-6.137e+02  -gs= 5.166e+01, BFGS update SKIPPED
#> At iterate     2  f =       969.45  |proj g|=        1.8823
#> At iterate     3  f =       957.45  |proj g|=        1.6085
#> At iterate     4  f =       955.93  |proj g|=        1.5689
#> At iterate     5  f =       955.92  |proj g|=        1.5593
#> At iterate     6  f =       955.91  |proj g|=        1.5635
#> At iterate     7  f =       955.91  |proj g|=        1.5632
#> At iterate     8  f =       955.91  |proj g|=        1.5632
#> 
#> iterations 8
#> function evaluations 13
#> segments explored during Cauchy searches 9
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 1.56324
#> final function value 955.912
#> 
#> F = 955.912
#> final  value 955.911660 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1107.102 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1107.1  |proj g|=       6.3547
#> At iterate     1  f =       1011.8  |proj g|=        15.571
#> ys=-2.157e+03  -gs= 6.661e+01, BFGS update SKIPPED
#> At iterate     2  f =       995.98  |proj g|=        2.6325
#> At iterate     3  f =       995.61  |proj g|=        2.6239
#> At iterate     4  f =        994.9  |proj g|=        2.5936
#> At iterate     5  f =       994.86  |proj g|=        2.5768
#> At iterate     6  f =       994.85  |proj g|=        2.5826
#> At iterate     7  f =       994.85  |proj g|=        2.5821
#> At iterate     8  f =       994.85  |proj g|=        2.5821
#> 
#> iterations 8
#> function evaluations 11
#> segments explored during Cauchy searches 9
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 2.58209
#> final function value 994.851
#> 
#> F = 994.851
#> final  value 994.850858 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1071.931 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1071.9  |proj g|=       4.1717
#> At iterate     1  f =       987.06  |proj g|=        2.0056
#> ys=-8.017e+02  -gs= 4.114e+01, BFGS update SKIPPED
#> At iterate     2  f =       973.72  |proj g|=        1.6093
#> At iterate     3  f =       968.64  |proj g|=        1.4459
#> At iterate     4  f =       968.51  |proj g|=        1.4198
#> At iterate     5  f =       968.51  |proj g|=        1.4192
#> At iterate     6  f =       968.51  |proj g|=        1.4193
#> 
#> iterations 6
#> function evaluations 11
#> segments explored during Cauchy searches 7
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 1.41926
#> final function value 968.508
#> 
#> F = 968.508
#> final  value 968.508056 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1096.586 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1096.6  |proj g|=        6.073
#> At iterate     1  f =         1015  |proj g|=        11.707
#> ys=-1.257e+03  -gs= 6.197e+01, BFGS update SKIPPED
#> At iterate     2  f =       1014.5  |proj g|=        2.3444
#> At iterate     3  f =       1002.6  |proj g|=         2.258
#> At iterate     4  f =       1002.3  |proj g|=        2.2388
#> At iterate     5  f =       1002.3  |proj g|=        2.2395
#> At iterate     6  f =       1002.3  |proj g|=        2.2394
#> At iterate     7  f =       1002.3  |proj g|=        2.2394
#> 
#> iterations 7
#> function evaluations 10
#> segments explored during Cauchy searches 8
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 2.23938
#> final function value 1002.33
#> 
#> F = 1002.33
#> final  value 1002.332321 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1052.292 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1052.3  |proj g|=       1.6237
#> At iterate     1  f =         1008  |proj g|=        17.776
#> ys=-1.349e+03  -gs= 2.181e+01, BFGS update SKIPPED
#> At iterate     2  f =       986.78  |proj g|=        1.4659
#> At iterate     3  f =       985.06  |proj g|=         1.345
#> At iterate     4  f =       985.03  |proj g|=        1.3892
#> At iterate     5  f =       984.99  |proj g|=        1.3691
#> At iterate     6  f =       984.99  |proj g|=        1.3708
#> At iterate     7  f =       984.99  |proj g|=        1.3709
#> 
#> iterations 7
#> function evaluations 10
#> segments explored during Cauchy searches 9
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 1.37091
#> final function value 984.994
#> 
#> F = 984.994
#> final  value 984.993907 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1127.809 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1127.8  |proj g|=       6.4154
#> At iterate     1  f =       1091.9  |proj g|=        1.0371
#> At iterate     2  f =       1058.9  |proj g|=        18.472
#> ys=-1.252e+03  -gs= 2.160e+01, BFGS update SKIPPED
#> At iterate     3  f =       1039.3  |proj g|=        2.6206
#> At iterate     4  f =       1021.9  |proj g|=        2.2861
#> At iterate     5  f =       1021.8  |proj g|=        2.3071
#> At iterate     6  f =       1021.8  |proj g|=        2.3067
#> At iterate     7  f =       1021.8  |proj g|=        2.3066
#> 
#> iterations 7
#> function evaluations 15
#> segments explored during Cauchy searches 10
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 2.30663
#> final function value 1021.79
#> 
#> F = 1021.79
#> final  value 1021.787401 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1076.361 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1076.4  |proj g|=        3.752
#> At iterate     1  f =       1039.6  |proj g|=         2.602
#> ys=-3.679e+01  -gs= 3.025e+01, BFGS update SKIPPED
#> At iterate     2  f =       1030.5  |proj g|=        2.3091
#> At iterate     3  f =       1026.3  |proj g|=        2.0693
#> At iterate     4  f =       1026.3  |proj g|=        3.3939
#> At iterate     5  f =       1026.2  |proj g|=        2.7363
#> At iterate     6  f =       1026.2  |proj g|=        2.7833
#> At iterate     7  f =       1026.2  |proj g|=        2.7863
#> 
#> iterations 7
#> function evaluations 9
#> segments explored during Cauchy searches 8
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 2.78631
#> final function value 1026.23
#> 
#> F = 1026.23
#> final  value 1026.231581 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1107.68 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1107.7  |proj g|=       4.2362
#> At iterate     1  f =       1043.2  |proj g|=        2.3212
#> ys=-2.521e+02  -gs= 3.950e+01, BFGS update SKIPPED
#> At iterate     2  f =       1033.1  |proj g|=        2.0994
#> At iterate     3  f =         1024  |proj g|=        3.1378
#> At iterate     4  f =       1023.7  |proj g|=        1.7686
#> At iterate     5  f =       1023.7  |proj g|=        1.7685
#> 
#> iterations 5
#> function evaluations 9
#> segments explored during Cauchy searches 6
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 1.76848
#> final function value 1023.7
#> 
#> F = 1023.7
#> final  value 1023.701681 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1211.021 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=         1211  |proj g|=       18.857
#> At iterate     1  f =       1145.8  |proj g|=        5.7269
#> ys=-1.055e+04  -gs= 7.992e+02, BFGS update SKIPPED
#> At iterate     2  f =       1111.3  |proj g|=        4.1415
#> At iterate     3  f =       1035.6  |proj g|=        1.9878
#> At iterate     4  f =       1019.2  |proj g|=       0.77294
#> At iterate     5  f =       1019.2  |proj g|=       0.77294
#> 
#> iterations 5
#> function evaluations 11
#> segments explored during Cauchy searches 7
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 0.77294
#> final function value 1019.23
#> 
#> F = 1019.23
#> final  value 1019.227824 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1164.356 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1164.4  |proj g|=       18.172
#> At iterate     1  f =         1151  |proj g|=         5.469
#> At iterate     2  f =       1137.8  |proj g|=        6.6684
#> At iterate     3  f =       1137.7  |proj g|=        6.6337
#> At iterate     4  f =       1137.7  |proj g|=        6.6429
#> At iterate     5  f =       1137.7  |proj g|=        6.6451
#> At iterate     6  f =       1137.7  |proj g|=        6.6449
#> At iterate     7  f =       1137.7  |proj g|=        6.6449
#> 
#> iterations 7
#> function evaluations 16
#> segments explored during Cauchy searches 9
#> BFGS updates skipped 0
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 6.64493
#> final function value 1137.67
#> 
#> F = 1137.67
#> final  value 1137.672856 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1180.825 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1180.8  |proj g|=       5.2815
#> At iterate     1  f =       1081.6  |proj g|=        2.9277
#> ys=-1.007e+03  -gs= 5.460e+01, BFGS update SKIPPED
#> At iterate     2  f =       1069.7  |proj g|=        2.5397
#> At iterate     3  f =       1066.2  |proj g|=        2.3113
#> At iterate     4  f =       1066.1  |proj g|=        3.2995
#> At iterate     5  f =       1066.1  |proj g|=        2.8449
#> At iterate     6  f =       1066.1  |proj g|=         2.871
#> At iterate     7  f =       1066.1  |proj g|=        2.8721
#> 
#> iterations 7
#> function evaluations 9
#> segments explored during Cauchy searches 8
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 2.87205
#> final function value 1066.08
#> 
#> F = 1066.08
#> final  value 1066.083471 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1206.27 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1206.3  |proj g|=       5.3004
#> At iterate     1  f =       1123.7  |proj g|=        4.5299
#> ys=-3.156e+02  -gs= 5.700e+01, BFGS update SKIPPED
#> At iterate     2  f =         1104  |proj g|=        3.4675
#> At iterate     3  f =       1100.5  |proj g|=        5.7331
#> At iterate     4  f =       1100.4  |proj g|=        6.5934
#> At iterate     5  f =       1100.4  |proj g|=        6.3278
#> At iterate     6  f =       1100.4  |proj g|=        6.3364
#> At iterate     7  f =       1100.4  |proj g|=        6.3389
#> 
#> iterations 7
#> function evaluations 10
#> segments explored during Cauchy searches 8
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 6.33893
#> final function value 1100.43
#> 
#> F = 1100.43
#> final  value 1100.434293 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1167.158 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1167.2  |proj g|=       8.9619
#> At iterate     1  f =       1074.2  |proj g|=           2.5
#> ys=-1.313e+04  -gs= 1.015e+02, BFGS update SKIPPED
#> At iterate     2  f =       1064.6  |proj g|=        2.0872
#> At iterate     3  f =       1056.5  |proj g|=         2.166
#> At iterate     4  f =       1056.2  |proj g|=        1.6839
#> At iterate     5  f =       1055.5  |proj g|=       0.38165
#> At iterate     6  f =       1055.5  |proj g|=      0.087522
#> At iterate     7  f =       1055.5  |proj g|=     0.0061001
#> At iterate     8  f =       1055.5  |proj g|=    0.00013533
#> At iterate     9  f =       1055.5  |proj g|=    3.7007e-05
#> 
#> iterations 9
#> function evaluations 25
#> segments explored during Cauchy searches 10
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 3.70066e-05
#> final function value 1055.47
#> 
#> F = 1055.47
#> final  value 1055.473296 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1176.835 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1176.8  |proj g|=       3.1953
#> At iterate     1  f =         1135  |proj g|=        4.1434
#> ys=-1.878e+02  -gs= 2.357e+01, BFGS update SKIPPED
#> At iterate     2  f =       1119.4  |proj g|=        3.4218
#> At iterate     3  f =       1070.7  |proj g|=        1.7931
#> At iterate     4  f =       1063.9  |proj g|=       0.46589
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate     5  f =       1063.8  |proj g|=       0.23857
#> At iterate     6  f =       1063.8  |proj g|=      0.021042
#> At iterate     7  f =       1063.8  |proj g|=     0.0010341
#> At iterate     8  f =       1063.8  |proj g|=    0.00010054
#> 
#> iterations 8
#> function evaluations 29
#> segments explored during Cauchy searches 10
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 0.000100538
#> final function value 1063.79
#> 
#> F = 1063.79
#> final  value 1063.787863 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1225.063 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1225.1  |proj g|=       6.7633
#> At iterate     1  f =       1132.9  |proj g|=        3.5581
#> ys=-9.211e+03  -gs= 6.913e+01, BFGS update SKIPPED
#> At iterate     2  f =       1114.7  |proj g|=        2.9754
#> At iterate     3  f =       1109.2  |proj g|=        2.7043
#> At iterate     4  f =       1108.5  |proj g|=        2.7692
#> At iterate     5  f =       1108.5  |proj g|=        3.2951
#> At iterate     6  f =       1108.5  |proj g|=        3.1912
#> At iterate     7  f =       1108.5  |proj g|=        3.1949
#> 
#> iterations 7
#> function evaluations 12
#> segments explored during Cauchy searches 8
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 3.19491
#> final function value 1108.48
#> 
#> F = 1108.48
#> final  value 1108.484722 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1179.736 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1179.7  |proj g|=       6.0901
#> At iterate     1  f =       1152.4  |proj g|=        1.0074
#> At iterate     2  f =         1110  |proj g|=        15.512
#> ys=-6.259e+02  -gs= 1.838e+01, BFGS update SKIPPED
#> At iterate     3  f =         1100  |proj g|=        2.1973
#> At iterate     4  f =       1098.4  |proj g|=          2.17
#> At iterate     5  f =       1096.4  |proj g|=        2.0998
#> At iterate     6  f =       1096.4  |proj g|=        2.0807
#> At iterate     7  f =       1096.3  |proj g|=        2.0887
#> At iterate     8  f =       1096.3  |proj g|=        2.0882
#> At iterate     9  f =       1096.3  |proj g|=        2.0882
#> 
#> iterations 9
#> function evaluations 12
#> segments explored during Cauchy searches 11
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 2.08821
#> final function value 1096.34
#> 
#> F = 1096.34
#> final  value 1096.342994 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1194.347 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1194.3  |proj g|=       5.2762
#> At iterate     1  f =       1130.1  |proj g|=        2.8585
#> ys=-2.526e+02  -gs= 5.048e+01, BFGS update SKIPPED
#> At iterate     2  f =       1122.4  |proj g|=        2.6956
#> At iterate     3  f =       1120.1  |proj g|=        2.5866
#> At iterate     4  f =       1118.1  |proj g|=        2.7718
#> At iterate     5  f =         1117  |proj g|=        2.8769
#> At iterate     6  f =       1116.4  |proj g|=        2.8196
#> Nonpositive definiteness in Cholesky factorization in formt();
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate     7  f =       1090.2  |proj g|=        1.7324
#> At iterate     8  f =       1090.2  |proj g|=        1.7324
#> 
#> iterations 8
#> function evaluations 22
#> segments explored during Cauchy searches 9
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 1.73238
#> final function value 1090.17
#> 
#> F = 1090.17
#> Warning:  more than 10 function and gradient evaluations
#>    in the last line search
#> final  value 1090.167973 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1243.321 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1243.3  |proj g|=       7.4342
#> At iterate     1  f =       1184.4  |proj g|=        4.7353
#> At iterate     2  f =       1160.7  |proj g|=        3.8343
#> At iterate     3  f =       1136.1  |proj g|=        4.6171
#> At iterate     4  f =       1136.1  |proj g|=        5.2773
#> At iterate     5  f =       1136.1  |proj g|=        5.2866
#> At iterate     6  f =       1136.1  |proj g|=        5.2827
#> At iterate     7  f =       1136.1  |proj g|=         5.251
#> At iterate     8  f =       1136.1  |proj g|=        5.2111
#> At iterate     9  f =       1136.1  |proj g|=        5.1396
#> At iterate    10  f =       1136.1  |proj g|=         5.025
#> At iterate    11  f =         1136  |proj g|=         4.844
#> At iterate    12  f =         1136  |proj g|=         4.562
#> At iterate    13  f =       1135.9  |proj g|=         4.122
#> At iterate    14  f =       1135.7  |proj g|=        3.4556
#> At iterate    15  f =       1135.2  |proj g|=        2.7538
#> At iterate    16  f =         1134  |proj g|=        2.7673
#> At iterate    17  f =       1131.1  |proj g|=         2.724
#> At iterate    18  f =       1125.3  |proj g|=          2.54
#> At iterate    19  f =       1115.4  |proj g|=        2.7006
#> At iterate    20  f =       1107.4  |proj g|=        2.8035
#> Nonpositive definiteness in Cholesky factorization in formk;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate    21  f =       1100.1  |proj g|=        2.2467
#> At iterate    22  f =       1097.4  |proj g|=        1.3121
#> Nonpositive definiteness in Cholesky factorization in formk;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate    23  f =       1096.7  |proj g|=       0.50877
#> At iterate    24  f =       1096.7  |proj g|=       0.14978
#> At iterate    25  f =       1096.7  |proj g|=      0.012814
#> At iterate    26  f =       1096.7  |proj g|=     0.0005021
#> At iterate    27  f =       1096.7  |proj g|=    0.00017766
#> 
#> iterations 27
#> function evaluations 37
#> segments explored during Cauchy searches 31
#> BFGS updates skipped 0
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 0.000177662
#> final function value 1096.65
#> 
#> F = 1096.65
#> final  value 1096.653949 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1218.501 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1218.5  |proj g|=       3.7304
#> At iterate     1  f =       1175.1  |proj g|=        3.4482
#> ys=-4.241e+01  -gs= 3.423e+01, BFGS update SKIPPED
#> At iterate     2  f =         1126  |proj g|=        2.3204
#> At iterate     3  f =       1124.6  |proj g|=        2.2078
#> At iterate     4  f =       1124.5  |proj g|=        2.4809
#> At iterate     5  f =       1124.5  |proj g|=        2.3494
#> At iterate     6  f =       1124.5  |proj g|=        2.3537
#> At iterate     7  f =       1124.5  |proj g|=        2.3537
#> 
#> iterations 7
#> function evaluations 15
#> segments explored during Cauchy searches 8
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 2.35367
#> final function value 1124.54
#> 
#> F = 1124.54
#> final  value 1124.536836 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1274.108 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1274.1  |proj g|=       6.4922
#> At iterate     1  f =       1229.2  |proj g|=        1.9488
#> At iterate     2  f =       1192.1  |proj g|=        18.919
#> ys=-4.606e+03  -gs= 3.025e+01, BFGS update SKIPPED
#> At iterate     3  f =       1157.1  |proj g|=        2.6781
#> At iterate     4  f =       1117.1  |proj g|=        2.5013
#> At iterate     5  f =       1116.3  |proj g|=        1.8819
#> At iterate     6  f =       1116.2  |proj g|=        1.8701
#> At iterate     7  f =       1116.2  |proj g|=         1.865
#> At iterate     8  f =       1116.2  |proj g|=        1.8656
#> At iterate     9  f =       1116.2  |proj g|=        1.8656
#> 
#> iterations 9
#> function evaluations 18
#> segments explored during Cauchy searches 12
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 1.8656
#> final function value 1116.18
#> 
#> F = 1116.18
#> final  value 1116.177854 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1416.619 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1416.6  |proj g|=       5.1666
#> At iterate     1  f =         1345  |proj g|=        6.3944
#> At iterate     2  f =       1214.5  |proj g|=        19.003
#> ys=-1.230e+05  -gs= 2.817e+01, BFGS update SKIPPED
#> At iterate     3  f =       1135.5  |proj g|=        5.7413
#> At iterate     4  f =       1134.7  |proj g|=        4.9067
#> At iterate     5  f =       1132.3  |proj g|=        2.0655
#> At iterate     6  f =         1132  |proj g|=        2.0843
#> At iterate     7  f =       1131.9  |proj g|=        2.0937
#> At iterate     8  f =       1131.9  |proj g|=        2.0955
#> At iterate     9  f =       1131.9  |proj g|=        2.0956
#> At iterate    10  f =       1131.9  |proj g|=        2.0956
#> 
#> iterations 10
#> function evaluations 17
#> segments explored during Cauchy searches 12
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 2.09564
#> final function value 1131.9
#> 
#> F = 1131.9
#> final  value 1131.903715 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1296.702 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1296.7  |proj g|=       3.4508
#> At iterate     1  f =       1277.3  |proj g|=        14.482
#> At iterate     2  f =       1159.9  |proj g|=        17.713
#> ys=-1.828e+04  -gs= 2.934e+01, BFGS update SKIPPED
#> At iterate     3  f =       1145.5  |proj g|=        6.0731
#> At iterate     4  f =       1143.4  |proj g|=        3.4979
#> At iterate     5  f =       1142.2  |proj g|=        2.1578
#> At iterate     6  f =         1142  |proj g|=         2.175
#> At iterate     7  f =         1142  |proj g|=         2.181
#> At iterate     8  f =         1142  |proj g|=        2.1818
#> At iterate     9  f =         1142  |proj g|=        2.1818
#> 
#> iterations 9
#> function evaluations 12
#> segments explored during Cauchy searches 12
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 2.18178
#> final function value 1142.01
#> 
#> F = 1142.01
#> final  value 1142.013059 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1399.343 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1399.3  |proj g|=       3.3809
#> At iterate     1  f =       1135.7  |proj g|=       0.18016
#> ys=-1.767e+06  -gs= 4.995e+01, BFGS update SKIPPED
#> At iterate     2  f =       1135.3  |proj g|=      0.051055
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate     3  f =       1135.3  |proj g|=    2.0576e-08
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate     4  f =       1135.3  |proj g|=    2.0576e-08
#> 
#> iterations 4
#> function evaluations 58
#> segments explored during Cauchy searches 8
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 2.05757e-08
#> final function value 1135.34
#> 
#> F = 1135.34
#> Warning:  more than 10 function and gradient evaluations
#>    in the last line search
#> final  value 1135.337792 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1360.483 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1360.5  |proj g|=       3.7602
#> At iterate     1  f =       1333.6  |proj g|=        8.6502
#> At iterate     2  f =       1229.6  |proj g|=        18.041
#> ys=-1.290e+04  -gs= 2.430e+01, BFGS update SKIPPED
#> At iterate     3  f =       1212.4  |proj g|=        4.0679
#> At iterate     4  f =       1212.2  |proj g|=        4.0905
#> At iterate     5  f =       1212.1  |proj g|=        4.1275
#> At iterate     6  f =       1212.1  |proj g|=        4.1327
#> At iterate     7  f =       1212.1  |proj g|=        4.1332
#> At iterate     8  f =       1212.1  |proj g|=        4.1332
#> 
#> iterations 8
#> function evaluations 11
#> segments explored during Cauchy searches 11
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 4.13324
#> final function value 1212.08
#> 
#> F = 1212.08
#> final  value 1212.081921 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1323.847 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1323.8  |proj g|=       5.1524
#> At iterate     1  f =       1289.5  |proj g|=        2.7341
#> At iterate     2  f =       1197.6  |proj g|=        17.883
#> ys=-8.816e+03  -gs= 2.312e+01, BFGS update SKIPPED
#> At iterate     3  f =       1178.3  |proj g|=        2.6544
#> At iterate     4  f =         1178  |proj g|=        2.6408
#> At iterate     5  f =       1177.6  |proj g|=        2.5856
#> At iterate     6  f =       1177.6  |proj g|=        2.6033
#> At iterate     7  f =       1177.6  |proj g|=        2.6004
#> At iterate     8  f =       1177.6  |proj g|=        2.6002
#> At iterate     9  f =       1177.6  |proj g|=        2.6002
#> 
#> iterations 9
#> function evaluations 13
#> segments explored during Cauchy searches 12
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 2.6002
#> final function value 1177.55
#> 
#> F = 1177.55
#> final  value 1177.552680 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1475.837 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1475.8  |proj g|=       4.6151
#> At iterate     1  f =         1428  |proj g|=        3.2199
#> At iterate     2  f =       1319.5  |proj g|=        18.161
#> ys=-1.029e+04  -gs= 3.041e+01, BFGS update SKIPPED
#> At iterate     3  f =       1311.4  |proj g|=        8.9601
#> At iterate     4  f =       1311.3  |proj g|=        8.8755
#> At iterate     5  f =       1311.3  |proj g|=        8.7994
#> At iterate     6  f =       1311.3  |proj g|=        8.8055
#> At iterate     7  f =       1311.3  |proj g|=        8.8048
#> At iterate     8  f =       1311.3  |proj g|=        8.8004
#> At iterate     9  f =       1311.3  |proj g|=        8.7947
#> At iterate    10  f =       1311.3  |proj g|=        8.7843
#> At iterate    11  f =       1311.3  |proj g|=        8.7678
#> At iterate    12  f =       1311.2  |proj g|=        8.7398
#> At iterate    13  f =       1311.2  |proj g|=        8.6935
#> At iterate    14  f =       1311.1  |proj g|=        8.6126
#> At iterate    15  f =       1310.7  |proj g|=        9.4988
#> At iterate    16  f =       1309.8  |proj g|=        11.768
#> At iterate    17  f =       1307.4  |proj g|=        15.694
#> At iterate    18  f =       1300.4  |proj g|=        18.036
#> At iterate    19  f =       1280.3  |proj g|=        18.218
#> At iterate    20  f =       1230.1  |proj g|=        17.959
#> At iterate    21  f =       1172.7  |proj g|=        13.403
#> At iterate    22  f =       1167.4  |proj g|=        10.136
#> At iterate    23  f =       1161.8  |proj g|=        4.2248
#> At iterate    24  f =       1160.1  |proj g|=        1.8024
#> At iterate    25  f =       1159.6  |proj g|=       0.54632
#> At iterate    26  f =       1159.6  |proj g|=       0.10416
#> At iterate    27  f =       1159.6  |proj g|=     0.0082772
#> At iterate    28  f =       1159.6  |proj g|=    0.00073419
#> At iterate    29  f =       1159.6  |proj g|=    0.00034131
#> 
#> iterations 29
#> function evaluations 33
#> segments explored during Cauchy searches 31
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 0.000341305
#> final function value 1159.57
#> 
#> F = 1159.57
#> final  value 1159.571294 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1369.783 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1369.8  |proj g|=       4.6184
#> At iterate     1  f =       1282.5  |proj g|=        6.4808
#> ys=-3.055e+03  -gs= 5.953e+01, BFGS update SKIPPED
#> At iterate     2  f =       1244.3  |proj g|=        6.0429
#> At iterate     3  f =       1244.2  |proj g|=        6.9563
#> At iterate     4  f =       1244.2  |proj g|=        6.9745
#> At iterate     5  f =       1244.2  |proj g|=        6.9737
#> 
#> iterations 5
#> function evaluations 7
#> segments explored during Cauchy searches 6
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 6.97371
#> final function value 1244.21
#> 
#> F = 1244.21
#> final  value 1244.206844 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1467.971 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=         1468  |proj g|=       4.1833
#> At iterate     1  f =       1421.4  |proj g|=       0.54712
#> At iterate     2  f =       1284.6  |proj g|=        18.959
#> ys=-1.245e+05  -gs= 3.594e+01, BFGS update SKIPPED
#> At iterate     3  f =       1210.2  |proj g|=        3.9622
#> At iterate     4  f =       1209.9  |proj g|=         3.436
#> At iterate     5  f =       1208.7  |proj g|=        2.8228
#> At iterate     6  f =       1208.7  |proj g|=         2.836
#> At iterate     7  f =       1208.7  |proj g|=        2.8404
#> At iterate     8  f =       1208.7  |proj g|=        2.8408
#> At iterate     9  f =       1208.7  |proj g|=        2.8408
#> 
#> iterations 9
#> function evaluations 12
#> segments explored during Cauchy searches 11
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 2.84082
#> final function value 1208.65
#> 
#> F = 1208.65
#> final  value 1208.652861 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1437.847 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1437.8  |proj g|=        5.123
#> At iterate     1  f =       1273.9  |proj g|=        5.0939
#> ys=-7.700e+04  -gs= 5.989e+01, BFGS update SKIPPED
#> At iterate     2  f =       1247.5  |proj g|=        4.8339
#> At iterate     3  f =       1247.5  |proj g|=         5.218
#> At iterate     4  f =       1247.5  |proj g|=        5.2214
#> 
#> iterations 4
#> function evaluations 6
#> segments explored during Cauchy searches 5
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 5.22138
#> final function value 1247.5
#> 
#> F = 1247.5
#> final  value 1247.503863 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1432.441 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1432.4  |proj g|=       19.398
#> At iterate     1  f =         1337  |proj g|=        5.6609
#> At iterate     2  f =       1295.7  |proj g|=        5.9104
#> At iterate     3  f =       1295.6  |proj g|=        5.9339
#> At iterate     4  f =       1295.6  |proj g|=        5.9296
#> At iterate     5  f =       1295.6  |proj g|=         5.929
#> At iterate     6  f =       1295.6  |proj g|=         5.929
#> 
#> iterations 6
#> function evaluations 11
#> segments explored during Cauchy searches 8
#> BFGS updates skipped 0
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 5.92901
#> final function value 1295.6
#> 
#> F = 1295.6
#> final  value 1295.603413 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1406.769 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1406.8  |proj g|=       6.4353
#> At iterate     1  f =       1296.1  |proj g|=        5.5123
#> ys=-5.410e+02  -gs= 8.190e+01, BFGS update SKIPPED
#> At iterate     2  f =         1271  |proj g|=        4.1441
#> At iterate     3  f =       1261.9  |proj g|=        11.911
#> At iterate     4  f =       1261.4  |proj g|=        17.616
#> At iterate     5  f =       1261.3  |proj g|=        15.552
#> At iterate     6  f =       1261.3  |proj g|=        15.738
#> At iterate     7  f =       1261.3  |proj g|=        15.747
#> 
#> iterations 7
#> function evaluations 9
#> segments explored during Cauchy searches 8
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 15.7465
#> final function value 1261.32
#> 
#> F = 1261.32
#> final  value 1261.324453 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1529.97 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=         1530  |proj g|=       9.2379
#> At iterate     1  f =       1434.7  |proj g|=        19.542
#> ys=-5.095e+04  -gs= 1.278e+02, BFGS update SKIPPED
#> At iterate     2  f =       1257.6  |proj g|=        3.1394
#> At iterate     3  f =       1209.7  |proj g|=       0.19324
#> At iterate     4  f =       1209.7  |proj g|=      0.013574
#> At iterate     5  f =       1209.7  |proj g|=     0.0019221
#> At iterate     6  f =       1209.7  |proj g|=    0.00049352
#> 
#> iterations 6
#> function evaluations 16
#> segments explored during Cauchy searches 9
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 0.000493522
#> final function value 1209.74
#> 
#> F = 1209.74
#> final  value 1209.736417 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1461.613 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1461.6  |proj g|=       18.623
#> At iterate     1  f =       1289.3  |proj g|=        3.2739
#> ys=-4.923e+05  -gs= 6.133e+02, BFGS update SKIPPED
#> At iterate     2  f =       1230.8  |proj g|=        3.7271
#> At iterate     3  f =       1230.8  |proj g|=        3.7271
#> 
#> iterations 3
#> function evaluations 19
#> segments explored during Cauchy searches 5
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 3.72714
#> final function value 1230.78
#> 
#> F = 1230.78
#> Warning:  more than 10 function and gradient evaluations
#>    in the last line search
#> final  value 1230.784395 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1295.978 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=         1296  |proj g|=       17.877
#> At iterate     1  f =         1282  |proj g|=        4.0328
#> At iterate     2  f =       1252.2  |proj g|=        2.8641
#> ys=-1.022e+02  -gs= 1.522e+01, BFGS update SKIPPED
#> At iterate     3  f =       1251.6  |proj g|=        2.8527
#> At iterate     4  f =       1251.1  |proj g|=        2.7994
#> At iterate     5  f =       1250.9  |proj g|=        2.8242
#> At iterate     6  f =       1250.9  |proj g|=        2.8197
#> At iterate     7  f =       1250.9  |proj g|=         2.819
#> At iterate     8  f =       1250.9  |proj g|=         2.819
#> 
#> iterations 8
#> function evaluations 10
#> segments explored during Cauchy searches 11
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 2.81901
#> final function value 1250.86
#> 
#> F = 1250.86
#> final  value 1250.861714 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1489.171 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1489.2  |proj g|=       9.1161
#> At iterate     1  f =       1367.2  |proj g|=        19.253
#> ys=-2.817e+04  -gs= 1.247e+02, BFGS update SKIPPED
#> At iterate     2  f =       1284.8  |proj g|=        3.3206
#> At iterate     3  f =       1235.7  |proj g|=        1.6928
#> At iterate     4  f =       1235.5  |proj g|=        1.7224
#> At iterate     5  f =       1235.5  |proj g|=        1.7212
#> At iterate     6  f =       1235.5  |proj g|=        1.7214
#> At iterate     7  f =       1235.5  |proj g|=        1.7215
#> 
#> iterations 7
#> function evaluations 19
#> segments explored during Cauchy searches 9
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 1.72145
#> final function value 1235.5
#> 
#> F = 1235.5
#> final  value 1235.499377 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1509.716 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1509.7  |proj g|=       5.9232
#> At iterate     1  f =       1296.2  |proj g|=        4.1173
#> ys=-2.211e+04  -gs= 7.524e+01, BFGS update SKIPPED
#> At iterate     2  f =       1249.4  |proj g|=        2.4102
#> At iterate     3  f =       1249.2  |proj g|=        2.3816
#> At iterate     4  f =       1249.2  |proj g|=        2.3792
#> At iterate     5  f =       1249.2  |proj g|=        2.3795
#> At iterate     6  f =       1249.2  |proj g|=        2.3795
#> 
#> iterations 6
#> function evaluations 11
#> segments explored during Cauchy searches 7
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 2.37948
#> final function value 1249.2
#> 
#> F = 1249.2
#> final  value 1249.203243 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1440.263 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1440.3  |proj g|=       6.7782
#> At iterate     1  f =       1269.4  |proj g|=        3.6461
#> ys=-7.219e+03  -gs= 8.231e+01, BFGS update SKIPPED
#> At iterate     2  f =       1258.1  |proj g|=        4.3477
#> At iterate     3  f =       1257.5  |proj g|=        2.4392
#> At iterate     4  f =       1257.5  |proj g|=        2.4391
#> At iterate     5  f =       1257.5  |proj g|=         2.439
#> 
#> iterations 5
#> function evaluations 7
#> segments explored during Cauchy searches 6
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 2.43902
#> final function value 1257.51
#> 
#> F = 1257.51
#> final  value 1257.508945 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1547.469 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1547.5  |proj g|=        3.434
#> At iterate     1  f =       1509.6  |proj g|=        8.5687
#> At iterate     2  f =       1335.8  |proj g|=        18.775
#> ys=-2.087e+05  -gs= 3.073e+01, BFGS update SKIPPED
#> At iterate     3  f =       1272.8  |proj g|=         2.712
#> At iterate     4  f =       1272.8  |proj g|=        2.7138
#> At iterate     5  f =       1272.7  |proj g|=        2.7246
#> At iterate     6  f =       1272.7  |proj g|=        2.7254
#> At iterate     7  f =       1272.7  |proj g|=        2.7254
#> 
#> iterations 7
#> function evaluations 10
#> segments explored during Cauchy searches 10
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 2.72541
#> final function value 1272.73
#> 
#> F = 1272.73
#> final  value 1272.729718 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1418.925 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1418.9  |proj g|=       2.5989
#> At iterate     1  f =       1294.3  |proj g|=        3.2094
#> ys=-1.379e+04  -gs= 3.574e+01, BFGS update SKIPPED
#> At iterate     2  f =       1287.7  |proj g|=        7.5517
#> At iterate     3  f =       1287.3  |proj g|=        2.9197
#> At iterate     4  f =         1287  |proj g|=        3.7686
#> At iterate     5  f =         1287  |proj g|=        4.1785
#> At iterate     6  f =         1287  |proj g|=        4.1275
#> At iterate     7  f =         1287  |proj g|=        4.1286
#> 
#> iterations 7
#> function evaluations 8
#> segments explored during Cauchy searches 8
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 4.12863
#> final function value 1286.96
#> 
#> F = 1286.96
#> final  value 1286.960791 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1541.479 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1541.5  |proj g|=       12.291
#> At iterate     1  f =       1326.8  |proj g|=        4.3091
#> ys=-7.320e+05  -gs= 1.886e+02, BFGS update SKIPPED
#> At iterate     2  f =       1274.8  |proj g|=        2.4657
#> At iterate     3  f =       1271.6  |proj g|=         2.035
#> At iterate     4  f =       1271.6  |proj g|=        2.0434
#> At iterate     5  f =       1271.6  |proj g|=        1.9393
#> At iterate     6  f =       1271.6  |proj g|=        1.9369
#> At iterate     7  f =       1271.6  |proj g|=        1.9371
#> 
#> iterations 7
#> function evaluations 12
#> segments explored during Cauchy searches 8
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 1.93711
#> final function value 1271.56
#> 
#> F = 1271.56
#> final  value 1271.559679 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1618.221 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1618.2  |proj g|=       3.1997
#> At iterate     1  f =       1583.9  |proj g|=        11.261
#> At iterate     2  f =       1437.1  |proj g|=        18.691
#> ys=-5.014e+04  -gs= 2.906e+01, BFGS update SKIPPED
#> At iterate     3  f =       1404.1  |proj g|=        7.4148
#> At iterate     4  f =         1404  |proj g|=         7.383
#> At iterate     5  f =       1403.9  |proj g|=        7.2895
#> At iterate     6  f =       1403.9  |proj g|=        7.2998
#> At iterate     7  f =       1403.9  |proj g|=        7.2991
#> At iterate     8  f =       1403.9  |proj g|=         7.299
#> 
#> iterations 8
#> function evaluations 12
#> segments explored during Cauchy searches 11
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 7.29901
#> final function value 1403.87
#> 
#> F = 1403.87
#> final  value 1403.868760 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1471.236 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1471.2  |proj g|=       5.7513
#> At iterate     1  f =       1431.6  |proj g|=        1.3707
#> At iterate     2  f =       1343.2  |proj g|=        18.087
#> ys=-5.732e+03  -gs= 2.609e+01, BFGS update SKIPPED
#> At iterate     3  f =       1328.8  |proj g|=        4.1404
#> At iterate     4  f =       1320.5  |proj g|=        3.4961
#> At iterate     5  f =       1319.7  |proj g|=        3.3352
#> At iterate     6  f =       1319.7  |proj g|=        3.3351
#> At iterate     7  f =       1319.7  |proj g|=        3.3351
#> 
#> iterations 7
#> function evaluations 12
#> segments explored during Cauchy searches 10
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 3.33511
#> final function value 1319.72
#> 
#> F = 1319.72
#> final  value 1319.715045 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1550.807 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1550.8  |proj g|=       7.2444
#> At iterate     1  f =       1319.3  |proj g|=         4.443
#> ys=-2.744e+04  -gs= 9.468e+01, BFGS update SKIPPED
#> At iterate     2  f =       1302.2  |proj g|=        4.3064
#> At iterate     3  f =       1301.6  |proj g|=        2.5905
#> At iterate     4  f =       1301.6  |proj g|=        2.5901
#> At iterate     5  f =       1301.6  |proj g|=          2.59
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate     6  f =       1296.6  |proj g|=        2.6726
#> At iterate     7  f =       1296.3  |proj g|=        3.0546
#> Nonpositive definiteness in Cholesky factorization in formt();
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate     8  f =       1292.5  |proj g|=        1.2951
#> At iterate     9  f =       1291.3  |proj g|=        1.1344
#> At iterate    10  f =       1291.3  |proj g|=         1.339
#> At iterate    11  f =       1291.3  |proj g|=        1.3072
#> At iterate    12  f =       1291.3  |proj g|=        1.3044
#> At iterate    13  f =       1291.3  |proj g|=        1.3014
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate    14  f =       1290.7  |proj g|=        2.1988
#> At iterate    15  f =       1290.7  |proj g|=        2.1988
#> 
#> iterations 15
#> function evaluations 37
#> segments explored during Cauchy searches 20
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 2.1988
#> final function value 1290.67
#> 
#> F = 1290.67
#> Warning:  more than 10 function and gradient evaluations
#>    in the last line search
#> final  value 1290.666693 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1548.62 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1548.6  |proj g|=       4.9528
#> At iterate     1  f =       1504.3  |proj g|=        1.6526
#> At iterate     2  f =       1384.8  |proj g|=        18.536
#> ys=-2.229e+04  -gs= 3.074e+01, BFGS update SKIPPED
#> At iterate     3  f =       1352.5  |proj g|=        4.3228
#> At iterate     4  f =       1343.8  |proj g|=        3.7285
#> At iterate     5  f =       1343.2  |proj g|=        3.6786
#> At iterate     6  f =       1343.2  |proj g|=        3.6738
#> At iterate     7  f =       1343.2  |proj g|=        3.6747
#> At iterate     8  f =       1343.2  |proj g|=        3.6747
#> 
#> iterations 8
#> function evaluations 13
#> segments explored during Cauchy searches 11
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 3.67469
#> final function value 1343.24
#> 
#> F = 1343.24
#> final  value 1343.242691 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1706.603 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1706.6  |proj g|=       9.2208
#> At iterate     1  f =       1572.4  |proj g|=        4.9874
#> At iterate     2  f =       1430.6  |proj g|=        18.403
#> ys=-2.983e+04  -gs= 3.047e+01, BFGS update SKIPPED
#> At iterate     3  f =       1401.7  |proj g|=        5.7891
#> At iterate     4  f =       1401.6  |proj g|=        5.7809
#> At iterate     5  f =       1401.6  |proj g|=        5.7536
#> At iterate     6  f =       1401.6  |proj g|=        5.7561
#> At iterate     7  f =       1401.6  |proj g|=        5.7559
#> 
#> iterations 7
#> function evaluations 13
#> segments explored during Cauchy searches 9
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 5.75592
#> final function value 1401.56
#> 
#> F = 1401.56
#> final  value 1401.556978 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1674.512 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1674.5  |proj g|=       4.7106
#> At iterate     1  f =       1618.9  |proj g|=        1.9115
#> At iterate     2  f =       1451.4  |proj g|=        18.585
#> ys=-6.779e+04  -gs= 4.070e+01, BFGS update SKIPPED
#> At iterate     3  f =       1415.7  |proj g|=        6.0152
#> At iterate     4  f =       1415.7  |proj g|=        6.0157
#> At iterate     5  f =       1415.7  |proj g|=        6.0171
#> At iterate     6  f =       1415.7  |proj g|=         6.017
#> 
#> iterations 6
#> function evaluations 11
#> segments explored during Cauchy searches 8
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 6.01705
#> final function value 1415.67
#> 
#> F = 1415.67
#> final  value 1415.666746 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1448.96 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=         1449  |proj g|=       2.7063
#> At iterate     1  f =       1429.1  |proj g|=        18.676
#> ys=-2.564e+02  -gs= 3.558e+01, BFGS update SKIPPED
#> At iterate     2  f =       1385.3  |proj g|=        5.0016
#> At iterate     3  f =       1378.7  |proj g|=        4.1519
#> At iterate     4  f =         1376  |proj g|=         4.106
#> At iterate     5  f =         1376  |proj g|=        4.1022
#> At iterate     6  f =         1376  |proj g|=        4.1037
#> At iterate     7  f =         1376  |proj g|=        4.1037
#> 
#> iterations 7
#> function evaluations 11
#> segments explored during Cauchy searches 9
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 4.10368
#> final function value 1376.03
#> 
#> F = 1376.03
#> final  value 1376.026345 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1714.892 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1714.9  |proj g|=       3.8785
#> At iterate     1  f =       1651.7  |proj g|=        13.459
#> At iterate     2  f =       1389.3  |proj g|=         18.46
#> ys=-6.530e+05  -gs= 4.031e+01, BFGS update SKIPPED
#> At iterate     3  f =       1353.5  |proj g|=        10.853
#> At iterate     4  f =       1350.8  |proj g|=          7.21
#> At iterate     5  f =       1348.1  |proj g|=        2.9404
#> At iterate     6  f =       1347.7  |proj g|=        2.9647
#> At iterate     7  f =       1347.6  |proj g|=        2.9754
#> At iterate     8  f =       1347.6  |proj g|=        2.9775
#> At iterate     9  f =       1347.6  |proj g|=        2.9776
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate    10  f =       1327.4  |proj g|=        1.6148
#> At iterate    11  f =       1327.4  |proj g|=        1.6148
#> 
#> iterations 11
#> function evaluations 34
#> segments explored during Cauchy searches 14
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 1.61482
#> final function value 1327.41
#> 
#> F = 1327.41
#> Warning:  more than 10 function and gradient evaluations
#>    in the last line search
#> final  value 1327.405201 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1694.476 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1694.5  |proj g|=       19.206
#> At iterate     1  f =       1446.2  |proj g|=        4.1859
#> ys=-9.642e+05  -gs= 2.346e+03, BFGS update SKIPPED
#> At iterate     2  f =       1335.4  |proj g|=        3.0405
#> At iterate     3  f =       1335.4  |proj g|=        3.0405
#> 
#> iterations 3
#> function evaluations 9
#> segments explored during Cauchy searches 5
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 3.04052
#> final function value 1335.45
#> 
#> F = 1335.45
#> final  value 1335.449385 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1678.421 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1678.4  |proj g|=       5.5346
#> At iterate     1  f =       1600.7  |proj g|=        6.1499
#> At iterate     2  f =       1440.1  |proj g|=        18.813
#> ys=-8.790e+04  -gs= 3.177e+01, BFGS update SKIPPED
#> At iterate     3  f =       1383.6  |proj g|=        4.6101
#> At iterate     4  f =       1377.7  |proj g|=        3.5462
#> At iterate     5  f =       1375.8  |proj g|=        3.4775
#> At iterate     6  f =       1375.8  |proj g|=        3.4621
#> At iterate     7  f =       1375.8  |proj g|=        3.4673
#> At iterate     8  f =       1375.8  |proj g|=         3.467
#> At iterate     9  f =       1375.8  |proj g|=         3.467
#> 
#> iterations 9
#> function evaluations 16
#> segments explored during Cauchy searches 12
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 3.46703
#> final function value 1375.76
#> 
#> F = 1375.76
#> final  value 1375.759168 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1629.412 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1629.4  |proj g|=       4.1675
#> At iterate     1  f =       1585.7  |proj g|=         5.549
#> At iterate     2  f =       1405.5  |proj g|=        18.557
#> ys=-1.052e+05  -gs= 3.333e+01, BFGS update SKIPPED
#> At iterate     3  f =       1358.5  |proj g|=        2.8212
#> At iterate     4  f =       1358.1  |proj g|=         2.813
#> At iterate     5  f =       1357.4  |proj g|=        2.7473
#> At iterate     6  f =       1357.2  |proj g|=        2.7728
#> At iterate     7  f =       1357.2  |proj g|=        2.7681
#> At iterate     8  f =       1357.2  |proj g|=        2.7675
#> At iterate     9  f =       1357.2  |proj g|=        2.7675
#> 
#> iterations 9
#> function evaluations 13
#> segments explored during Cauchy searches 12
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 2.7675
#> final function value 1357.22
#> 
#> F = 1357.22
#> final  value 1357.217069 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1689.379 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1689.4  |proj g|=       16.885
#> At iterate     1  f =       1563.1  |proj g|=        8.3034
#> ys=-1.170e+05  -gs= 3.303e+02, BFGS update SKIPPED
#> At iterate     2  f =       1482.7  |proj g|=        5.4966
#> At iterate     3  f =       1385.8  |proj g|=        4.5053
#> Nonpositive definiteness in Cholesky factorization in formt();
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate     4  f =       1375.1  |proj g|=        3.1107
#> At iterate     5  f =       1374.5  |proj g|=        3.0497
#> At iterate     6  f =       1374.5  |proj g|=        3.0458
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate     7  f =       1369.4  |proj g|=        4.0853
#> At iterate     8  f =       1369.4  |proj g|=        3.8971
#> Nonpositive definiteness in Cholesky factorization in formt();
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate     9  f =       1362.1  |proj g|=         2.748
#> At iterate    10  f =       1361.8  |proj g|=         2.709
#> At iterate    11  f =       1361.8  |proj g|=        2.7084
#> At iterate    12  f =       1361.8  |proj g|=         2.708
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate    13  f =       1357.8  |proj g|=        3.7617
#> At iterate    14  f =       1357.7  |proj g|=        3.3857
#> Nonpositive definiteness in Cholesky factorization in formt();
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate    15  f =       1354.3  |proj g|=       0.58875
#> At iterate    16  f =       1354.3  |proj g|=        1.4194
#> At iterate    17  f =       1354.2  |proj g|=       0.63134
#> At iterate    18  f =       1354.2  |proj g|=       0.70123
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate    19  f =       1353.3  |proj g|=        1.7576
#> At iterate    20  f =       1353.3  |proj g|=        1.7576
#> 
#> iterations 20
#> function evaluations 66
#> segments explored during Cauchy searches 26
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 1.75759
#> final function value 1353.31
#> 
#> F = 1353.31
#> Warning:  more than 10 function and gradient evaluations
#>    in the last line search
#> final  value 1353.305298 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1691.774 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1691.8  |proj g|=       6.3882
#> At iterate     1  f =       1609.7  |proj g|=        4.1796
#> At iterate     2  f =       1481.9  |proj g|=        18.713
#> ys=-2.649e+04  -gs= 3.052e+01, BFGS update SKIPPED
#> At iterate     3  f =       1451.8  |proj g|=        5.8511
#> At iterate     4  f =       1435.6  |proj g|=        4.9767
#> At iterate     5  f =       1432.8  |proj g|=        4.7809
#> At iterate     6  f =       1432.6  |proj g|=         4.849
#> At iterate     7  f =       1432.5  |proj g|=         4.829
#> At iterate     8  f =       1432.5  |proj g|=        4.8258
#> At iterate     9  f =       1432.5  |proj g|=         4.826
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate    10  f =       1411.9  |proj g|=        4.1069
#> At iterate    11  f =       1379.2  |proj g|=        5.0297
#> Nonpositive definiteness in Cholesky factorization in formt();
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate    12  f =       1365.7  |proj g|=        2.4531
#> At iterate    13  f =         1365  |proj g|=        2.1709
#> At iterate    14  f =         1365  |proj g|=        2.1377
#> At iterate    15  f =         1365  |proj g|=        2.1489
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate    16  f =       1361.3  |proj g|=        3.2198
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate    17  f =       1359.2  |proj g|=       0.56761
#> At iterate    18  f =       1359.2  |proj g|=       0.29983
#> At iterate    19  f =       1359.2  |proj g|=      0.014775
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate    20  f =       1359.2  |proj g|=       1.9e-05
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate    21  f =       1359.2  |proj g|=    1.8998e-05
#> 
#> iterations 21
#> function evaluations 61
#> segments explored during Cauchy searches 30
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 1.89975e-05
#> final function value 1359.16
#> 
#> F = 1359.16
#> final  value 1359.160712 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1776.656 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1776.7  |proj g|=        19.26
#> At iterate     1  f =       1590.9  |proj g|=        8.6858
#> ys=-1.906e+05  -gs= 2.617e+03, BFGS update SKIPPED
#> At iterate     2  f =       1506.6  |proj g|=        5.6255
#> At iterate     3  f =       1370.4  |proj g|=        9.5869
#> Nonpositive definiteness in Cholesky factorization in formt();
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate     4  f =         1367  |proj g|=        2.8822
#> At iterate     5  f =       1365.8  |proj g|=        1.5839
#> At iterate     6  f =       1365.5  |proj g|=       0.81978
#> At iterate     7  f =       1365.4  |proj g|=       0.13298
#> At iterate     8  f =       1365.4  |proj g|=      0.011927
#> At iterate     9  f =       1365.4  |proj g|=     0.0087084
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate    10  f =       1365.4  |proj g|=    2.8403e-06
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> Line search cannot locate an adequate point after 20 function
#> and gradient evaluations
#> final  value 1365.431646 
#> stopped after 10 iterations
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1733.798 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1733.8  |proj g|=       4.8591
#> At iterate     1  f =         1679  |proj g|=        2.4522
#> At iterate     2  f =       1501.5  |proj g|=        17.291
#> ys=-5.246e+04  -gs= 3.754e+01, BFGS update SKIPPED
#> At iterate     3  f =       1495.8  |proj g|=          7.09
#> At iterate     4  f =       1495.8  |proj g|=        7.1018
#> At iterate     5  f =       1495.8  |proj g|=        7.1098
#> At iterate     6  f =       1495.8  |proj g|=          7.11
#> 
#> iterations 6
#> function evaluations 9
#> segments explored during Cauchy searches 8
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 7.11
#> final function value 1495.76
#> 
#> F = 1495.76
#> final  value 1495.758606 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1728.433 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1728.4  |proj g|=       3.9043
#> At iterate     1  f =       1684.2  |proj g|=         6.008
#> At iterate     2  f =       1513.9  |proj g|=        18.735
#> ys=-8.153e+04  -gs= 3.386e+01, BFGS update SKIPPED
#> At iterate     3  f =       1469.6  |proj g|=        5.6196
#> At iterate     4  f =       1468.5  |proj g|=        5.5807
#> At iterate     5  f =       1466.1  |proj g|=        5.4516
#> At iterate     6  f =       1465.9  |proj g|=        5.3658
#> At iterate     7  f =       1465.8  |proj g|=        5.3984
#> At iterate     8  f =       1465.8  |proj g|=         5.395
#> At iterate     9  f =       1465.8  |proj g|=        5.3947
#> At iterate    10  f =       1465.8  |proj g|=        5.3948
#> 
#> iterations 10
#> function evaluations 15
#> segments explored during Cauchy searches 13
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 5.39475
#> final function value 1465.82
#> 
#> F = 1465.82
#> final  value 1465.821995 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1717.679 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1717.7  |proj g|=       3.1647
#> At iterate     1  f =       1688.5  |proj g|=         17.17
#> At iterate     2  f =       1525.8  |proj g|=        18.368
#> ys=-3.646e+04  -gs= 3.237e+01, BFGS update SKIPPED
#> At iterate     3  f =       1505.2  |proj g|=        6.7108
#> At iterate     4  f =       1505.1  |proj g|=        6.7326
#> At iterate     5  f =       1505.1  |proj g|=         6.765
#> At iterate     6  f =       1505.1  |proj g|=         6.767
#> At iterate     7  f =       1505.1  |proj g|=        6.7671
#> 
#> iterations 7
#> function evaluations 10
#> segments explored during Cauchy searches 10
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 6.76713
#> final function value 1505.05
#> 
#> F = 1505.05
#> final  value 1505.052993 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1705.175 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1705.2  |proj g|=       5.4605
#> At iterate     1  f =       1649.8  |proj g|=        1.9135
#> At iterate     2  f =       1481.6  |proj g|=        11.289
#> ys=-3.100e+04  -gs= 3.672e+01, BFGS update SKIPPED
#> At iterate     3  f =       1477.8  |proj g|=         5.296
#> At iterate     4  f =       1477.8  |proj g|=        5.3047
#> At iterate     5  f =       1477.8  |proj g|=        5.3095
#> At iterate     6  f =       1477.8  |proj g|=        5.3097
#> 
#> iterations 6
#> function evaluations 9
#> segments explored during Cauchy searches 8
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 5.30966
#> final function value 1477.76
#> 
#> F = 1477.76
#> final  value 1477.762069 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1798.49 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1798.5  |proj g|=       7.9983
#> At iterate     1  f =       1675.8  |proj g|=        18.494
#> At iterate     2  f =       1498.4  |proj g|=        5.8512
#> ys=-2.436e+04  -gs= 9.162e+01, BFGS update SKIPPED
#> At iterate     3  f =         1498  |proj g|=        5.8883
#> At iterate     4  f =       1497.9  |proj g|=        5.9143
#> At iterate     5  f =       1497.9  |proj g|=        5.9185
#> At iterate     6  f =       1497.9  |proj g|=        5.9188
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate     7  f =       1468.1  |proj g|=        4.7437
#> At iterate     8  f =       1432.4  |proj g|=        5.5932
#> Nonpositive definiteness in Cholesky factorization in formt();
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate     9  f =       1417.6  |proj g|=        3.1108
#> At iterate    10  f =       1416.1  |proj g|=        3.0335
#> At iterate    11  f =       1416.1  |proj g|=         3.021
#> At iterate    12  f =       1416.1  |proj g|=        3.0231
#> At iterate    13  f =       1416.1  |proj g|=        3.0235
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate    14  f =       1410.3  |proj g|=        4.0395
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate    15  f =       1404.7  |proj g|=        1.4528
#> At iterate    16  f =       1404.5  |proj g|=        1.3496
#> At iterate    17  f =       1404.5  |proj g|=        1.4616
#> At iterate    18  f =       1404.5  |proj g|=        1.5415
#> At iterate    19  f =       1404.5  |proj g|=         1.536
#> At iterate    20  f =       1404.5  |proj g|=        1.5265
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate    21  f =       1403.3  |proj g|=        3.6318
#> At iterate    22  f =       1403.3  |proj g|=        3.6318
#> 
#> iterations 22
#> function evaluations 47
#> segments explored during Cauchy searches 31
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 3.63177
#> final function value 1403.32
#> 
#> F = 1403.32
#> Warning:  more than 10 function and gradient evaluations
#>    in the last line search
#> final  value 1403.320157 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1712.14 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1712.1  |proj g|=       6.8823
#> At iterate     1  f =       1658.3  |proj g|=        5.2816
#> At iterate     2  f =       1595.4  |proj g|=         18.61
#> ys=-1.633e+03  -gs= 2.943e+01, BFGS update SKIPPED
#> At iterate     3  f =       1578.3  |proj g|=        9.7134
#> At iterate     4  f =       1577.4  |proj g|=        9.7106
#> At iterate     5  f =         1577  |proj g|=        14.035
#> At iterate     6  f =         1577  |proj g|=         13.16
#> At iterate     7  f =         1577  |proj g|=        13.239
#> At iterate     8  f =         1577  |proj g|=        13.241
#> 
#> iterations 8
#> function evaluations 12
#> segments explored during Cauchy searches 11
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 13.2412
#> final function value 1577
#> 
#> F = 1577
#> final  value 1577.000748 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1789.933 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1789.9  |proj g|=       3.9407
#> At iterate     1  f =         1744  |proj g|=        5.8948
#> At iterate     2  f =       1583.5  |proj g|=        18.767
#> ys=-5.295e+04  -gs= 3.461e+01, BFGS update SKIPPED
#> At iterate     3  f =       1545.7  |proj g|=        7.5143
#> At iterate     4  f =       1543.1  |proj g|=        7.4083
#> At iterate     5  f =       1537.8  |proj g|=        7.0399
#> At iterate     6  f =       1537.7  |proj g|=        6.9522
#> At iterate     7  f =       1537.7  |proj g|=        6.9898
#> At iterate     8  f =       1537.7  |proj g|=        6.9874
#> At iterate     9  f =       1537.7  |proj g|=        6.9873
#> 
#> iterations 9
#> function evaluations 13
#> segments explored during Cauchy searches 12
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 6.98734
#> final function value 1537.65
#> 
#> F = 1537.65
#> final  value 1537.651051 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1748.414 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1748.4  |proj g|=       9.7873
#> At iterate     1  f =       1506.9  |proj g|=        18.164
#> ys=-2.515e+04  -gs= 1.441e+02, BFGS update SKIPPED
#> At iterate     2  f =       1490.3  |proj g|=        6.1698
#> At iterate     3  f =       1478.7  |proj g|=        4.3382
#> At iterate     4  f =       1478.7  |proj g|=        4.3407
#> At iterate     5  f =       1478.7  |proj g|=        4.3407
#> 
#> iterations 5
#> function evaluations 10
#> segments explored during Cauchy searches 7
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 4.34068
#> final function value 1478.67
#> 
#> F = 1478.67
#> final  value 1478.668674 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1739.064 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1739.1  |proj g|=       7.5343
#> At iterate     1  f =       1562.5  |proj g|=        7.1689
#> ys=-9.739e+02  -gs= 1.340e+02, BFGS update SKIPPED
#> At iterate     2  f =       1528.2  |proj g|=         6.066
#> At iterate     3  f =       1521.5  |proj g|=        5.7129
#> At iterate     4  f =       1520.5  |proj g|=        5.5605
#> At iterate     5  f =       1520.4  |proj g|=        6.0384
#> At iterate     6  f =       1520.4  |proj g|=        5.8377
#> At iterate     7  f =       1520.4  |proj g|=        5.8448
#> 
#> iterations 7
#> function evaluations 13
#> segments explored during Cauchy searches 8
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 5.84481
#> final function value 1520.43
#> 
#> F = 1520.43
#> final  value 1520.431068 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1955.494 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1955.5  |proj g|=       8.0461
#> At iterate     1  f =       1592.5  |proj g|=        7.6788
#> ys=-1.638e+05  -gs= 1.198e+02, BFGS update SKIPPED
#> At iterate     2  f =       1540.8  |proj g|=        6.1884
#> At iterate     3  f =       1519.8  |proj g|=        7.4937
#> At iterate     4  f =       1519.7  |proj g|=        5.6594
#> At iterate     5  f =       1519.7  |proj g|=        5.6612
#> 
#> iterations 5
#> function evaluations 10
#> segments explored during Cauchy searches 6
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 5.66123
#> final function value 1519.66
#> 
#> F = 1519.66
#> final  value 1519.661100 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1672.326 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1672.3  |proj g|=        7.744
#> At iterate     1  f =       1478.7  |proj g|=        5.9002
#> ys=-4.410e+03  -gs= 1.008e+02, BFGS update SKIPPED
#> At iterate     2  f =       1463.9  |proj g|=        3.3246
#> At iterate     3  f =       1462.1  |proj g|=         3.238
#> At iterate     4  f =       1462.1  |proj g|=        3.2231
#> At iterate     5  f =       1462.1  |proj g|=        3.2258
#> At iterate     6  f =       1462.1  |proj g|=        3.2263
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate     7  f =         1456  |proj g|=        4.5491
#> At iterate     8  f =       1455.9  |proj g|=        5.0125
#> Nonpositive definiteness in Cholesky factorization in formt();
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate     9  f =       1447.7  |proj g|=        1.5234
#> At iterate    10  f =       1447.3  |proj g|=        1.3407
#> At iterate    11  f =       1447.3  |proj g|=        1.3338
#> At iterate    12  f =       1447.3  |proj g|=        1.3346
#> At iterate    13  f =       1447.3  |proj g|=        1.3346
#> 
#> iterations 13
#> function evaluations 20
#> segments explored during Cauchy searches 16
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 1.33456
#> final function value 1447.29
#> 
#> F = 1447.29
#> final  value 1447.293871 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1943.149 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1943.1  |proj g|=        7.852
#> At iterate     1  f =       1509.1  |proj g|=        6.5225
#> ys=-5.924e+05  -gs= 1.175e+02, BFGS update SKIPPED
#> At iterate     2  f =       1460.1  |proj g|=        3.0603
#> At iterate     3  f =       1458.9  |proj g|=        2.9973
#> At iterate     4  f =       1458.9  |proj g|=        2.9928
#> At iterate     5  f =       1458.9  |proj g|=        2.9927
#> At iterate     6  f =       1458.9  |proj g|=        2.9927
#> 
#> iterations 6
#> function evaluations 11
#> segments explored during Cauchy searches 7
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 2.99269
#> final function value 1458.92
#> 
#> F = 1458.92
#> final  value 1458.921724 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1825.993 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=         1826  |proj g|=       12.526
#> At iterate     1  f =       1702.3  |proj g|=        6.5344
#> At iterate     2  f =       1659.8  |proj g|=        7.3993
#> At iterate     3  f =       1610.4  |proj g|=        18.032
#> ys=-5.011e+02  -gs= 2.053e+01, BFGS update SKIPPED
#> At iterate     4  f =       1605.6  |proj g|=        10.412
#> At iterate     5  f =       1605.6  |proj g|=        10.759
#> At iterate     6  f =       1605.6  |proj g|=        10.928
#> At iterate     7  f =       1605.6  |proj g|=        10.925
#> 
#> iterations 7
#> function evaluations 13
#> segments explored during Cauchy searches 10
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 10.9253
#> final function value 1605.55
#> 
#> F = 1605.55
#> final  value 1605.550727 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1879.545 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1879.5  |proj g|=       4.3177
#> At iterate     1  f =       1817.1  |proj g|=       0.73838
#> At iterate     2  f =       1539.3  |proj g|=        18.566
#> ys=-5.443e+05  -gs= 4.865e+01, BFGS update SKIPPED
#> At iterate     3  f =       1490.2  |proj g|=        3.6465
#> At iterate     4  f =         1490  |proj g|=        3.4703
#> At iterate     5  f =       1489.6  |proj g|=        3.4976
#> At iterate     6  f =       1489.5  |proj g|=        3.5025
#> At iterate     7  f =       1489.5  |proj g|=        3.5027
#> At iterate     8  f =       1489.5  |proj g|=        3.5029
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate     9  f =       1478.1  |proj g|=        3.1947
#> At iterate    10  f =       1465.6  |proj g|=        3.4713
#> Nonpositive definiteness in Cholesky factorization in formt();
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate    11  f =       1463.7  |proj g|=      0.072621
#> At iterate    12  f =       1463.7  |proj g|=     0.0085902
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate    13  f =       1463.7  |proj g|=    2.3637e-06
#> At iterate    14  f =       1463.7  |proj g|=    1.1742e-06
#> 
#> iterations 14
#> function evaluations 23
#> segments explored during Cauchy searches 18
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 1.17419e-06
#> final function value 1463.71
#> 
#> F = 1463.71
#> final  value 1463.710036 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1579.398 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1579.4  |proj g|=       7.9274
#> At iterate     1  f =       1529.2  |proj g|=        4.2277
#> At iterate     2  f =       1522.1  |proj g|=        2.7118
#> At iterate     3  f =       1495.9  |proj g|=        6.5276
#> ys=-6.793e+01  -gs= 1.427e+01, BFGS update SKIPPED
#> At iterate     4  f =       1494.8  |proj g|=        3.5103
#> At iterate     5  f =       1494.4  |proj g|=        3.4814
#> At iterate     6  f =       1494.4  |proj g|=        3.4699
#> At iterate     7  f =       1494.4  |proj g|=        3.4705
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate     8  f =       1484.6  |proj g|=        3.5386
#> At iterate     9  f =       1482.1  |proj g|=        4.5583
#> Nonpositive definiteness in Cholesky factorization in formt();
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate    10  f =       1475.4  |proj g|=        1.9289
#> At iterate    11  f =       1475.3  |proj g|=        1.8047
#> At iterate    12  f =       1475.3  |proj g|=         1.868
#> At iterate    13  f =       1475.3  |proj g|=        1.8519
#> At iterate    14  f =       1475.3  |proj g|=        1.8519
#> 
#> iterations 14
#> function evaluations 24
#> segments explored during Cauchy searches 19
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 1.85186
#> final function value 1475.29
#> 
#> F = 1475.29
#> final  value 1475.286145 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1843.839 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1843.8  |proj g|=       7.0096
#> At iterate     1  f =       1582.4  |proj g|=        7.3434
#> ys=-4.746e+05  -gs= 9.680e+01, BFGS update SKIPPED
#> At iterate     2  f =         1537  |proj g|=        4.7106
#> At iterate     3  f =       1532.2  |proj g|=        4.4799
#> At iterate     4  f =       1532.2  |proj g|=        4.4433
#> At iterate     5  f =       1532.2  |proj g|=        4.4577
#> At iterate     6  f =       1532.2  |proj g|=         4.457
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate     7  f =       1525.1  |proj g|=        6.4799
#> At iterate     8  f =       1524.6  |proj g|=        6.0286
#> Nonpositive definiteness in Cholesky factorization in formt();
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate     9  f =       1509.3  |proj g|=        5.5825
#> At iterate    10  f =       1508.8  |proj g|=        3.7123
#> At iterate    11  f =       1508.8  |proj g|=        3.7122
#> 
#> iterations 11
#> function evaluations 20
#> segments explored during Cauchy searches 14
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 1
#> norm of the final projected gradient 3.71224
#> final function value 1508.79
#> 
#> F = 1508.79
#> final  value 1508.792266 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1852.844 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1852.8  |proj g|=        25.03
#> At iterate     1  f =       1655.1  |proj g|=        5.6145
#> ys=-1.699e+03  -gs= 9.616e+02, BFGS update SKIPPED
#> At iterate     2  f =       1495.2  |proj g|=        3.9868
#> At iterate     3  f =       1488.9  |proj g|=        2.3586
#> Nonpositive definiteness in Cholesky factorization in formt();
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate     4  f =       1484.2  |proj g|=        3.8827
#> At iterate     5  f =       1484.2  |proj g|=        3.8827
#> 
#> iterations 5
#> function evaluations 27
#> segments explored during Cauchy searches 8
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 3.88267
#> final function value 1484.21
#> 
#> F = 1484.21
#> Warning:  more than 10 function and gradient evaluations
#>    in the last line search
#> final  value 1484.212640 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -1755.11 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       1755.1  |proj g|=       4.2862
#> At iterate     1  f =       1713.9  |proj g|=        7.9737
#> At iterate     2  f =       1538.7  |proj g|=        18.332
#> ys=-3.630e+04  -gs= 3.449e+01, BFGS update SKIPPED
#> At iterate     3  f =       1504.7  |proj g|=        3.3144
#> At iterate     4  f =       1504.1  |proj g|=        3.3011
#> At iterate     5  f =       1503.5  |proj g|=          3.24
#> At iterate     6  f =       1503.3  |proj g|=        3.2605
#> At iterate     7  f =       1503.3  |proj g|=        3.2582
#> At iterate     8  f =       1503.3  |proj g|=        3.2579
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate     9  f =       1493.9  |proj g|=        2.4913
#> At iterate    10  f =       1489.6  |proj g|=        3.6656
#> Nonpositive definiteness in Cholesky factorization in formt();
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate    11  f =       1487.7  |proj g|=       0.39148
#> At iterate    12  f =       1487.7  |proj g|=       0.11049
#> At iterate    13  f =       1487.7  |proj g|=     0.0018184
#> Bad direction in the line search;
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate    14  f =       1487.7  |proj g|=    1.4881e-05
#> 
#> iterations 14
#> function evaluations 19
#> segments explored during Cauchy searches 19
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 1.48808e-05
#> final function value 1487.71
#> 
#> F = 1487.71
#> final  value 1487.713486 
#> converged
#> 
#> optimisation start
#> ------------------
#> * estimation method   : MLE 
#> * optimisation method : BFGS 
#> * analytical gradient : used
#> * trend model : ~1
#> * covariance model : 
#>   - type :  matern3_2 
#>   - nugget : unknown homogenous nugget effect 
#>   - parameters lower bounds :  1e-10 1e-10 
#>   - parameters upper bounds :  19.74013 49.99884 
#>   - upper bound for alpha   :  1 
#>   - best initial criterion value(s) :  -2008.577 
#> 
#> N = 3, M = 5 machine precision = 2.22045e-16
#> At X0, 0 variables are exactly at the bounds
#> At iterate     0  f=       2008.6  |proj g|=       8.4635
#> At iterate     1  f =       1539.1  |proj g|=        7.2027
#> ys=-7.279e+05  -gs= 1.307e+02, BFGS update SKIPPED
#> At iterate     2  f =       1496.8  |proj g|=        1.1548
#> At iterate     3  f =       1496.7  |proj g|=         1.239
#> Nonpositive definiteness in Cholesky factorization in formt();
#>    refresh the lbfgs memory and restart the iteration.
#> At iterate     4  f =       1495.8  |proj g|=         3.948
#> At iterate     5  f =       1495.8  |proj g|=         3.948
#> 
#> iterations 5
#> function evaluations 23
#> segments explored during Cauchy searches 7
#> BFGS updates skipped 1
#> active bounds at final generalized Cauchy point 2
#> norm of the final projected gradient 3.94798
#> final function value 1495.8
#> 
#> F = 1495.8
#> Warning:  more than 10 function and gradient evaluations
#>    in the last line search
#> final  value 1495.795575 
#> converged

print(result_bayes)
#> coconut results
#> Method: bayesian 
#> Mode: minimize 
#> Solution: 0.2002 9.7384 
#> Value: 2.0636 
#> Iterations: 100 
#> Convergence:
```

### initializers + workflows

initializers may come in handy when searching for a global optima &
objectives have many local optimas.

``` r
# Generate initial points using coco_initial
initial_points <- coco_initial(
  n = 10,
  lb = c(-5, -5),
  ub = c(5, 5),
  method = "lhs"
)

# Create base spec
base_spec <- coco_mode(objective = line, mode = "minimize") |>
  coco_method("particle_swarm") |>
  coco_params(
    lower = c(-5, -5),
    upper = c(5, 20),
    pop_size = 30,
    max_iter = 100,
    method_control = list(w = 0.7) # PSO-specific inertia weight
  )

# Run workflow for parameter search
result_workflow <- coco_workflow(base_spec, initial_points, return = "best")
print(result_workflow)
#> coconut results
#> Method: particle_swarm 
#> Mode: minimize 
#> Solution: 0.2 10 
#> Value: 0 
#> Iterations: 100 
#> Convergence: 2
```

*coconut loosely stands for a ‘**c**ollection **o**f
**c**ool/complex/continuous/creative **o**ptimizers as a **n**ice
**u**nified **t**oolkit’.*
