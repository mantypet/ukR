# Explore example in https://towardsdatascience.com/tidy-web-scraping-in-r-tutorial-and-resources-ac9f72b4fe47
source(here::here("R/global.R"))

print_vehicle <- function(i) {
  vehicle_h3 <- oryx %>%
    xml2::xml_find_all(paste0("//*[@id='post-body-8087922975012177708']/div[7]/h3[",i+3,"]")) %>%
    html_text()
  
  vehicle_ul <- oryx %>%
    xml2::xml_find_all(paste0("//*[@id='post-body-8087922975012177708']/div[7]/ul[",i,"]")) %>%
    html_text()
  
  data.frame(
    "h3" = vehicle_h3,
    "ul" = vehicle_ul)
}

library(rvest)
library(xml2)
library(tidyverse)


url <- "https://www.oryxspioenkop.com/2022/02/attack-on-europe-documenting-equipment.html"
oryx <- read_html(url)

ru_header <- oryx %>%
  xml2::xml_find_all("//*[@id='post-body-8087922975012177708']/div[7]/h3[1]") %>%
  html_text()

ru <- map_dfr(1:24, print_vehicle)


