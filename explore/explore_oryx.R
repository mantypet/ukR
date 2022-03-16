# Web scraping Russian vehicle losses from https://www.oryxspioenkop.com/2022/02/attack-on-europe-documenting-equipment.html
# by implementing the example in https://towardsdatascience.com/tidy-web-scraping-in-r-tutorial-and-resources-ac9f72b4fe47

source(here::here("R/global.R"))
source(here::here("process/transformations.R"))
source(here::here("process/reporting_functions.R"))

# Read and transform RU vehicle losses from Oryx website
url <- "https://www.oryxspioenkop.com/2022/02/attack-on-europe-documenting-equipment.html"
oryx <- xml2::read_html(url)
ru.rep.long <- extract_vehicles_long(oryx)


# Read header to validate totals
ru_header <- oryx %>%
  xml2::xml_find_all("//*[@id='post-body-8087922975012177708']/div[7]/h3[1]") %>%
  html_text()

# Save daily
file <- here::here(paste0("data/oryx_ru_losses_",Sys.Date(),".csv"))
write.csv(ru.rep.long, file = file)

# Test plot
ru.rep.long %>%
  ggplot() +
  geom_col(aes(x = type, y = n, fill = name)) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        legend.position = "none")

# Test totals
ru.rep.long %>%
  summarise(sum = sum(n))
ru_header

# Test tabulation
ru.rep.long %>%
  group_by(type) %>%
  slice_max(order_by = n, n = 3) %>%
  kable %>%
  kable_styling()

# Test loading previous dataset
reporting_start <- as.Date("2022-03-14")
report_dates <- seq.Date(reporting_start, Sys.Date(), "day")

ru_losses <- map_dfr(report_dates, read_report)
