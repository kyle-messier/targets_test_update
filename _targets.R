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
  store = "/ddn/gs1/group/set/targets_test/"
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
      my_files,
      unlist(list.files("data", full.names = TRUE))
    ),
    tar_target(
      read_data,
      readr::read_csv(my_files),
      pattern = map(my_files)
    ),
  tar_target(
    name = data_format,
    command = tibble(x = read_data$x, y = read_data$y),
    pattern = map(read_data)
    # format = "feather" # efficient storage for large data frames
  ),
  tar_target(
    name = model,
    command = lm(y ~ x, data = data_format),
    pattern = map(data_format)
  ),
  tar_target(
    name = model_coefficients,
    command = coefficients(model),
    pattern = map(model)
  ),
  tar_target(
    name = coefficients_table,
    command = model_coefficients
  )
)
