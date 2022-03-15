# Data processing functions


#' Extract vehicle types, names and total of losses. Only supports RU losses.
#' TBD: losses by type
#' @param xml HTML-document (oryx-website) as xml_document
#' 
#' @examples
#' url <- "https://www.oryxspioenkop.com/2022/02/attack-on-europe-documenting-equipment.html"
#' oryx <- xml2::read_html(url)
#' 
#' 
extract_vehicles_long <- function(xml) {
  vehicles_lines <- map_dfr(1:24, ~ list_vehicles(.x, xml))
  
  vehicles_lines <- vehicles_lines %>%
    mutate(across(everything(), ~ str_replace_all(.x, "\\(.*?\\)", replacement = "")))
  
  ul_split <- str_split(vehicles_lines$ul, ":", simplify = TRUE) %>%
    as.data.frame() %>%
    mutate(across(everything(), .fns = ~ str_trim(.x, side = "both")))
  
  vehicles_lines.split <- vehicles_lines %>%
    transmute(type = h3) %>%
    cbind(ul_split)
  
  vehicles_lines.long <- vehicles_lines.split %>%
    pivot_longer(cols = 2:23, names_to = "col", values_to = "ul") %>%
    select(type, ul) %>%
    filter(ul != "") %>%
    cbind(split_vehicle_info(.$ul)) %>%
    select(-ul) %>%
    mutate(reportdate = Sys.Date(),
           type = forcats::as_factor(type),
           name = as.character(name),
           n = as.numeric(n))
}

#' List vehicle types, names and losses by Xpath selectors.
#' Unfortunately relies only on the current layout of the HTML-document and is highly vulnerable to changes
#'
#' @param i An index ranging from 1 to 24 selecting each vehicle type (h3) and list of vehicles of according type (ul)
#' @param xml HTML-document as xml_document
#' 
#' @examples
#' url <- "https://www.oryxspioenkop.com/2022/02/attack-on-europe-documenting-equipment.html"
#' oryx <- xml2::read_html(url)
#' purrr::map_dfr(1:24, ~ list_vehicles(.x, oryx))
#'
list_vehicles <- function(i, xml = oryx) {
  vehicle_h3 <- xml %>%
    xml2::xml_find_all(paste0("//*[@id='post-body-8087922975012177708']/div[7]/h3[",i+3,"]")) %>%
    html_text()
  
  vehicle_ul <- xml %>%
    xml2::xml_find_all(paste0("//*[@id='post-body-8087922975012177708']/div[7]/ul[",i,"]")) %>%
    html_text()
  
  data.frame(
    "h3" = vehicle_h3,
    "ul" = vehicle_ul)
}

#' Split string by the first occuring whitespace
#' @param string A string beginning with an integer and followed by verbose vehicle name.
#' 
#' @examples
#' str <- "3 A Long Vehicle Name"
#' split_vehicle_info(str)
#'
split_vehicle_info <- function(string) {
  n <- str_extract(string, "^([^\\s]*)")
  name <- str_remove(string, "^([^\\s]*)\\s")
  
  data.frame("name" = name,
             "n" = n)
}
