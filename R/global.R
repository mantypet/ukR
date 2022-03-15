# Load common packages & common functionalities for the entire project

# R packages used by the project
suppressPackageStartupMessages({
  library(tidyverse)
  library(rvest)
  library(xml2)
  library(knitr)
  library(kableExtra)
})

#' Negate `%in%`
#'
#' @examples
#' "a" %in% letters
#' "a" %notin% LETTERS
#'
`%notin%` <- Negate(`%in%`)




