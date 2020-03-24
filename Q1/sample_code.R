# packages
library(INLA)

# data
my_data <- read.csv(
  file = url("https://raw.githubusercontent.com/agila5/INLA_tests/master/Q1/data.csv"), 
  colClasses = c("integer", "character", "character", "numeric", "character")
)

# Mod1: Hurdle - Poisson model with no random effect. Runs fine. 
mod1 <- inla(
  formula = number_of_car_crashes ~ highway + lanes, 
  family = "zeroinflatedpoisson0",
  data = my_data,
  E = highway_length,
  verbose = FALSE,
  control.inla = list(strategy = "gaussian"), 
  control.predictor = list(compute = TRUE)
)
summary(mod1)

# Mod2: The same as Mod1 but with an unstrucutred random component on the hours. Error. 
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

# Mod3 is the same as Mod2 with without control.predictor = list(compute = TRUE)
mod3 <- inla(
  formula = number_of_car_crashes ~ highway + lanes + 
    f(hour_character, model = "iid"), 
  family = "zeroinflatedpoisson0",
  data = my_data,
  E = highway_length,
  verbose = TRUE,
  control.inla = list(strategy = "gaussian")
)

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
