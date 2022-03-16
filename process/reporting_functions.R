# Reporting functions

#' Load dataset by date
#' 
#' @examples 
#' reporting_start <- as.Date("2022-03-14")
#' report_dates <- seq.Date(reporting_start, Sys.Date(), "day")
#' 
#' read_report(Sys.Date())
#' 
read_report <- function(date) {
  file <- here::here(paste0("data/oryx_ru_losses_",date,".csv"))
  read.csv(file = file, stringsAsFactors = FALSE, row.names = 1)
}