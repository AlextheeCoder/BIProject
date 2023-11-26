library(httr)
library(jsonlite)


base_url <- "http://127.0.0.1:5022/predict_startup"


params <- list(
  funding_total_usd = "1000000",  
  funding_rounds = "5",          
  milestones = "3",              
  category_code = "music",         
  state = "CA",                  
  industry = "software"          
)


query_url <- modify_url(url = base_url, query = params)
print(query_url)


model_prediction <- GET(query_url)


model_prediction_raw <- content(model_prediction, as = "text", encoding = "utf-8")
jsonlite::fromJSON(model_prediction_raw)


get_startup_predictions <- function(funding_total_usd, funding_rounds, milestones, category_code, state, industry) {
  params <- list(
    funding_total_usd = as.character(funding_total_usd),
    funding_rounds = as.character(funding_rounds),
    milestones = as.character(milestones),
    category_code = category_code,
    state = state,
    industry = industry
  )
  query_url <- modify_url(url = base_url, query = params)
  model_prediction <- GET(query_url)
  model_prediction_raw <- content(model_prediction, as = "text", encoding = "utf-8")
  jsonlite::fromJSON(model_prediction_raw)
}


get_startup_predictions(1000000, 5, 3, "music", "CA", "software")
get_startup_predictions(100, 5, 3, "music", "CA", "software")
