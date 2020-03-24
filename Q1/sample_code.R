# packages
library(INLA)

# data
my_data <- read.csv(
  file = url("https://raw.githubusercontent.com/agila5/INLA_tests/master/Q1/data.csv"), 
  colClasses = c("integer", "character", "character", "numeric", "character")
)

# Mod1: Hurdle - Poisson model with no random effect. Takes approx 1.5 minutes
# but runs fine.
mod1 <- inla(
  formula = number_of_car_crashes ~ highway + lanes, 
  family = "zeroinflatedpoisson0",
  data = my_data,
  E = highway_length,
  verbose = TRUE,
  control.inla = list(strategy = "gaussian"), 
  control.predictor = list(compute = TRUE)
)
summary(mod1)

# The problem is here
# Mod2: The same as Mod1 but with an unstrucutred random component on the hours.
# Error.
mod2 <- inla(
  formula = number_of_car_crashes ~ highway + lanes + 
    f(hour_character, model = "iid"), 
  family = "zeroinflatedpoisson0",
  data = my_data,
  E = highway_length,
  verbose = TRUE,
  control.inla = list(strategy = "gaussian"), 
  control.predictor = list(compute = TRUE)
)

# Mod3 is the same as Mod2 with without control.predictor = list(compute =
# TRUE). There is no error here, I don't know why.
mod3 <- inla(
  formula = number_of_car_crashes ~ highway + lanes + 
    f(hour_character, model = "iid"), 
  family = "zeroinflatedpoisson0",
  data = my_data,
  E = highway_length,
  verbose = TRUE,
  control.inla = list(strategy = "gaussian")
)
summary(mod3)

# Moreover if I reduce the number of obs then also mod2 runs just fine. 
set.seed(24032020)
my_data2 <- my_data[sample(seq.int(1, nrow(my_data)), nrow(my_data) / 16), ]

mod2 <- inla(
  formula = number_of_car_crashes ~ highway + lanes + 
    f(hour_character, model = "iid"), 
  family = "zeroinflatedpoisson0",
  data = my_data2,
  E = highway_length,
  verbose = TRUE,
  control.inla = list(strategy = "gaussian"), 
  control.predictor = list(compute = TRUE)
)
summary(mod2)

# sessioninfo()
# R version 3.6.3 (2020-02-29)
# Platform: x86_64-pc-linux-gnu (64-bit)
# Running under: Ubuntu 16.04.6 LTS
# 
# Matrix products: default
# BLAS:   /usr/lib/openblas-base/libblas.so.3
# LAPACK: /usr/lib/libopenblasp-r0.2.18.so
# 
# locale:
# [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C               LC_TIME=en_US.UTF-8       
# [4] LC_COLLATE=en_US.UTF-8     LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
# [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                  LC_ADDRESS=C              
# [10] LC_TELEPHONE=C             LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
# 
# attached base packages:
# [1] parallel  stats     graphics  grDevices utils     datasets  methods   base     
# 
# other attached packages:
# [1] INLA_19.09.03 sp_1.4-0      Matrix_1.2-18
# 
# loaded via a namespace (and not attached):
# [1] lattice_0.20-40    fansi_0.4.1        withr_2.1.2        packrat_0.5.0      crayon_1.3.4      
# [6] assertthat_0.2.1   grid_3.6.3         MatrixModels_0.4-1 cli_2.0.2          rstudioapi_0.11   
# [11] splines_3.6.3      tools_3.6.3        glue_1.3.1         compiler_3.6.3     sessioninfo_1.1.1 
