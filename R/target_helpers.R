# target helper functions


# my_data_combine <- function(data) {
#     
#   # Read the data from the file
#     data_old <- qs::qread("_targets/objects/data")
#     #Check if data_old and data are the same
#     if (!identical(data_old, data)) {
#       print("combine-fun-A")
#       # If they are not, combine the data from the previous targets
#       data_combined <- dplyr::bind_rows(data_old, data)
#     } else {
#       # If they are the same, return the data
#       data_combined <- data
#       print("combine-fun-B")
#     }
#   
#   return(data_combined)
# }


