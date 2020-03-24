# packages
library(INLA)

# data
my_data <- read.csv(
  file = url("https://raw.githubusercontent.com/agila5/INLA_tests/master/Q1/data.csv"), 
  colClasses = c("integer", "character", "character", "numeric", "character")
)

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
  control.predictor = list(compute = TRUE), 
  debug = TRUE
)