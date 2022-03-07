source(here::here("R/db_readers.R"))

#' @examples 
#' 
#' con <- db_common()
#' pop <- read_population(con, vuosi = 2019)
#' pop_agegroup <- pop_add_agegroup(pop)
#' str(pop_agegroup)
#' thlDbDisconnect(con)
pop_add_agegroup <- function(pop) {
  pop <- pop %>% mutate(ikaryhma = case_when(
    ika < 18 ~ "0-17", 
    18 <= ika & ika < 65 ~ "18-64",
    TRUE ~ "65+"
  ))
  pop

}
