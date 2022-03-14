
# R packages used by the project
suppressPackageStartupMessages({
  library(tidyverse)
  library(openssl)
  library(httpuv)
  library(base64enc)
  library(twitteR)
})

#' Negate `%in%`
#'
#' @examples
#' "a" %in% letters
#' "a" %notin% LETTERS
#'
`%notin%` <- Negate(`%in%`)




