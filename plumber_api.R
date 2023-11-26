library(plumber)
library(caret)

# Load the model
# I chose the desicion tree because it is the most accurate
tree_model <- readRDS("models/tree_model.rds")


category_code_levels <- c("advertising", "analytics", "automotive", "biotech", "cleantech", "consulting",
                          "ecommerce", "education", "enterprise", "fashion", "finance", "games_video",
                          "hardware", "health", "hospitality", "manufacturing", "medical", "messaging",
                          "mobile", "music", "network_hosting", "news", "other", "photo_video",
                          "public_relations", "real_estate", "search", "security", "semiconductor",
                          "social", "software", "sports", "transportation", "travel", "web")

state_levels <- c("California", "Massachusetts", "New York", "Other states", "Texas", "Unknow")

industry_levels <- c("Advertising", "Biotech", "Consulting", "Ecommerce", "Enterprise", "Mobile",
                     "Other Category", "Software", "Video Games", "Web")

#* @apiTitle Startup Prediction Model API
#* @apiDescription Predict startup success

#* @param funding_total_usd Total funding in USD
#* @param funding_rounds Number of funding rounds
#* @param milestones Number of milestones
#* @param category_code Category code of the startup
#* @param state State where the startup is located
#* @param industry Industry of the startup
#* @get /predict_startup
function(funding_total_usd, funding_rounds, milestones, category_code, state, industry) {
  to_be_predicted <- data.frame(
    funding_total_usd = as.numeric(funding_total_usd),
    funding_rounds = as.numeric(funding_rounds),
    milestones = as.numeric(milestones),
    category_code = factor(category_code, levels = category_code_levels ),
    state = factor(state, levels = state_levels ),
    industry = factor(industry, levels = industry_levels)
  )
  

  predictions_tree <- predict(tree_model, to_be_predicted, type = "class")
  return(predictions_tree)
}
