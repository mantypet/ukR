
# R packages used by the project
suppressPackageStartupMessages({
  library(tidyverse)
  library(openssl)
  library(httpuv)
  library(base64enc)
  library(twitteR)
})

#' Get local Twitter API keys
#' 
#' 
get_api_keys <- function() {
  local <- here::here("local/local.R")
  stopifnot(file.exists(local))

  source(local)
  
  list("api_key" = api_key,
       "api_secret" = api_secret,
       "bearer_token" = bearer_token,
       "access_token" = access_token,
       "access_token_secret" = access_token_secret)
}

#' Setup Twitter Oaut local
#' 

setup_twitter_oauth_local() {
  api_keys <- get_api_keys()
  foo <- setup_twitter_oauth(consumer_key = api_keys$api_key,
                      consumer_secret = api_keys$api_secret,
                      access_token = api_keys$access_token,
                      access_secret = api_keys$access_token_secret)
  origop <- options("httr_oauth_cache")
  options(httr_oauth_cache = TRUE)
}


