# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) # Load other packages as needed.

# Set target options:
tar_option_set(
  packages = c("tibble"), # packages that your targets need to run
  format = "qs",
  repository = "local" # where to store the target data
  #
  # For distributed computing in tar_make(), supply a {crew} controller
  # as discussed at https://books.ropensci.org/targets/crew.html.
  # Choose a controller that suits your needs. For example, the following
  # sets a controller with 2 workers which will run as local R processes:
  #
  #   controller = crew::crew_controller_local(workers = 2)
  #
  # Alternatively, if you want workers to run on a high-performance computing
  # cluster, select a controller from the {crew.cluster} package. The following
  # example is a controller for Sun Grid Engine (SGE).
  # 
  #   controller = crew.cluster::crew_controller_sge(
  #     workers = 50,
  #     # Many clusters install R as an environment module, and you can load it
  #     # with the script_lines argument. To select a specific verison of R,
  #     # you may need to include a version string, e.g. "module load R/4.3.0".
  #     # Check with your system administrator if you are unsure.
  #     script_lines = "module load R"
  #   )
  #
  # Set other options as needed.
)


tar_config_set(
  store = "_targets/"
)
# tar_make_clustermq() is an older (pre-{crew}) way to do distributed computing
# in {targets}, and its configuration for your machine is below.
#options(clustermq.scheduler = "multicore")

# tar_make_future() is an older (pre-{crew}) way to do distributed computing
# in {targets}, and its configuration for your machine is below.
#future::plan(future.callr::callr)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
# source("other_functions.R") # Source other scripts as needed.

# Replace the target list below with your own:
list(
  tar_target(
      start_range,
      command = 1:13
    ),
    tar_target(
      parse_range,
      command = {
        result <- split(start_range, ceiling(seq_along(start_range) / 2)) 
        result
      }
    ),
  tar_target(
    name = data_model,
    command = dnorm(seq(-3, 3, by = 0.1), parse_range[[1]][1], parse_range[[1]][2]), #nolint
    pattern = map(parse_range),
    iteration = "list"
  ),
  tar_target(
    name = sum_model,
    command = sum(data_model),
    pattern = map(data_model),
    iteration = "list"
  ), 
  tar_target(
    name = cat_model, 
    command = dplyr::bind_cols(sum_model)
  )
)
