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

split_vehicle <- function(string) {
  n <- str_extract(string, "^([^\\s]*)")
  name <- str_remove(string, "^([^\\s]*)\\s")
  
  data.frame("name" = name,
             "n" = n)
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

ru.rep <- ru %>%
  mutate(across(everything(), ~ str_replace_all(.x, "\\(.*?\\)", replacement = "")))

ul_split <- str_split(ru.rep$ul, ":", simplify = TRUE) %>%
  as.data.frame() %>%
  mutate(across(everything(), .fns = ~ str_trim(.x, side = "both")))

ru.rep.long <- ru.rep %>%
  transmute(type = h3) %>%
  cbind(ul_split) %>%
  pivot_longer(cols = 2:23, names_to = "col", values_to = "ul") %>%
  select(type, ul) %>%
  filter(ul != "") %>%
  cbind(split_vehicle(.$ul)) %>%
  select(-ul) %>%
  mutate(reportdate = Sys.Date(),
         type = forcats::as_factor(type),
         name = as.character(name),
         n = as.numeric(n))

file <- here::here(paste0("data/oryx_ru_losses_",Sys.Date(),".csv"))
write.csv(ru.rep.long, file = file)

ru.rep.long %>%
  ggplot() +
  geom_col(aes(x = type, y = n, fill = name)) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        legend.position = "none")

ru.rep.long %>%
  summarise(sum = sum(n))

ru.rep.long %>%
  group_by(type) %>%
  slice_max(order_by = n, n = 3) %>%
  kable %>%
  kable_styling()

# Test loading previous
file_prev <- here::here(paste0("data/oryx_ru_losses_",Sys.Date()-1,".csv"))
ru.rep.long.prev <- read.csv(file = file_prev, stringsAsFactors = FALSE, row.names = 1)


