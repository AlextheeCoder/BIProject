# Name: Alex MWai Muthee
#Admission NUmber: 131123
#Group: B

rm(list = ls())
cat("\014")


library(data.table)
library(ggplot2)
library(ggridges)
library(grid)
library(gridExtra)
library(GGally)
library(dplyr)
library(ggplot2)
library(tidyr)
library(reshape2)
library(cluster)
library(class)
library(caret)
library(rpart)
library(plumber)
library(randomForest)
library(ggcorrplot)


startup = read.csv("data/startupdata.csv")
View(startup)
names(startup)
head(startup)
class(startup)
summary(startup)
str(startup)


table(startup$state_code)
table(startup$category_code)
table(startup$status)
table(startup$state_code, startup$status)


# Mean
mean(startup$funding_total_usd, na.rm = TRUE)

# Median
median(startup$funding_total_usd, na.rm = TRUE)


# Range
range(startup$funding_total_usd, na.rm = TRUE)

# Quartiles
quantile(startup$funding_total_usd, na.rm = TRUE)

# Variance
var(startup$funding_total_usd, na.rm = TRUE)

# Standard Deviation
sd(startup$funding_total_usd, na.rm = TRUE)


# Correlation
cor(startup$age_first_funding_year, startup$funding_total_usd, use = "complete.obs")

#Annova
anova_model <- aov(funding_total_usd ~ state_code, data = startup)
summary(anova_model)
TukeyHSD(anova_model)






#Issue 3 Data Exploration & Visualization-----------------

#str 
str(startup)

#Scatter plot of latitude and longitude
ggplot(startup, aes(x = longitude, y = latitude)) +
  geom_point() +
  labs(x = "Longitude", y = "Latitude") +
  theme_bw()

#Trend in funding rounds
ggplot(startup, aes(x = funding_rounds)) +
  geom_histogram(fill = "skyblue", color = "white", binwidth = 1) +
  ggtitle("Distribution of Funding Rounds") +
  xlab("Number of Funding Rounds") +
  ylab("Count")

#Regional trends in startup funding 
startup %>% 
  group_by(state_code) %>% 
  summarize(avg_funding = mean(funding_total_usd))%>% 
  ggplot(aes(x=state_code, y=avg_funding)) +
  geom_bar(stat="identity", fill="skyblue", color="White") +
  ggtitle("Average Funding by State") +
  xlab("State") +
  ylab("Average Funding (in USD)")

#Bar plot of category code
ggplot(startup, aes(y = category_code)) +
  geom_bar() +
  labs(y = "Category Code", x = "Count") +
  theme_bw()

#Box plot of funding total by category
ggplot(startup, aes(y = category_code, x = funding_total_usd/1000000)) +
  geom_boxplot() +
  labs(y = "Category Code", x = "Funding Total (Millions of USD)") +
  theme_bw() +
  scale_x_continuous(limits = c(0, 300))


#Bar plot of status by category
ggplot(startup, aes(y = category_code, fill = status)) +
  geom_bar() +
  labs(y = "Category Code", x = "Count") +
  theme_bw() +
  scale_fill_manual(values = c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728"))

#Regional trends in startup funding
startup %>%
  group_by(status) %>%
  summarize(avg_funding = mean(funding_total_usd)) %>%
  ggplot(aes(x = status, y = avg_funding)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "white") +
  ggtitle("Average Funding by Status") +
  xlab("Status") +
  ylab("Average Funding (in USD)")


#Bar chart of count of companies by state:
startup_state <- startup %>%
  group_by(state_code) %>%
  summarise(count = n()) %>%
  arrange(desc(count))

ggplot(startup_state, aes(y = state_code, x = count, fill = state_code)) +
  geom_col() +
  labs(y = "State Code", x = "Count of Companies") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))



# select relevant numeric variables
startup_data_num <- select_if(startup, is.numeric)
# compute correlation matrix
corr_matrix <- cor(startup_data_num, use = "pairwise.complete.obs")




# plot correlation heat map
ggcorrplot(corr_matrix, hc.order = TRUE, type = "lower", 
           lab_size = 3, ggtheme = ggplot2::theme_gray, 
           colors = c("#6D9EC1", "white", "#E46726"))






# ----------------------------------Issue 4 & 5--------------------------------------------------------
missing_values <- sapply(startup, function(x) sum(is.na(x) | x == ""))

# Display the results in a dataframe
missing_values_df <- data.frame(Variable = names(missing_values), Missing_Values = missing_values)
knitr::kable(missing_values_df)


#Dropping useless columns: Unnamed: 0, id, Unnamed: 6, state_code.1, object-id

startup <- subset(startup, select = -c(Unnamed..0,id, Unnamed..6,state_code.1,object_id, labels))
View(startup)


#Reformatting the dates
library(lubridate)

parse_dates <- function(date_column) {
  parsed_dates <- mdy(date_column)
  formatted_dates <- format(parsed_dates, "%d/%m/%Y")
  return(formatted_dates)
}

# Executing the function parse_dates to the column "closed_at"
startup$closed_at <- parse_dates(startup$closed_at)

# Executing the function parse_dates to the column "founded_at"
startup$founded_at <- parse_dates(startup$founded_at)

# Executing the function parse_dates to the column "first_funding_at"
startup$first_funding_at <- parse_dates(startup$first_funding_at)

# Executing the function parse_dates to the column "last_funding_at"
startup$last_funding_at <- parse_dates(startup$last_funding_at)

startup$closed_at <- dmy(startup$closed_at)
startup$founded_at <- dmy(startup$founded_at)
startup$first_funding_at <- dmy(startup$first_funding_at)
startup$last_funding_at <- dmy(startup$last_funding_at)

# Dropping illogical lines (closed_date before founded_date):
illogical_lines <- subset(startup, closed_at < founded_at)
View(illogical_lines)

# New dataframe without these lines
startup <- subset(startup, is.na(closed_at) | closed_at >= founded_at)
View (startup)


#Replacing the "status" variable by a categorical variable
startup$status <- ifelse(startup$status == "acquired", 1, ifelse(startup$status == "closed", 0, startup$status))
View(startup)


distinct_categories <- unique(startup$category_code)
print(distinct_categories)


startup$state <- ifelse(startup$is_CA == 1, "California", 
                        ifelse(startup$is_MA == 1, "Massachusetts",
                               ifelse(startup$is_NY == 1, "New York",
                                      ifelse(startup$is_TX == 1, "Texas",
                                             ifelse(startup$is_otherstate == 1, "Other states", "Unknow")))))

state_counts <- table(startup$state)
df_pie <- data.frame(State = names(state_counts), Count = as.numeric(state_counts))

df_pie <- df_pie %>%
  mutate(Percentage = round(100 * Count / sum(Count), 1))



# Diagram creation
pie_chart <- ggplot(data = df_pie, aes(x = "", y = Count, fill = State)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start = 0) +
  geom_text(aes(label = paste(State, "\n", Percentage, "%")), position = position_stack(vjust = 0.5), color = "white", size = 3) +  
  labs(fill = "State", title = "State origin of the selected startups") +  
  scale_fill_discrete(name = "State") +
  theme_void() +
  theme(legend.position = "right", plot.title = element_text(hjust = 0.5))  

print(pie_chart)



# % of startups in each industry
startup$industry <- ifelse(startup$is_web == 1, "Web", 
                           ifelse(startup$is_advertising == 1, "Advertising",
                                  ifelse(startup$is_mobile == 1, "Mobile",
                                         ifelse(startup$is_enterprise == 1, "Enterprise",
                                                ifelse(startup$is_gamesvideo == 1, "Video Games",
                                                       ifelse(startup$is_ecommerce == 1, "Ecommerce",
                                                              ifelse(startup$is_biotech == 1, "Biotech",
                                                                     ifelse(startup$is_consulting == 1, "Consulting",
                                                                            ifelse(startup$is_othercategory == 1, "Other Category",
                                                                                   ifelse(startup$is_software == 1, "Software", "Unknown"))))))))))

industry_counts <- table(startup$industry)
df_pie <- data.frame(Industry = names(industry_counts), Count = as.numeric(industry_counts))

df_pie <- df_pie %>%
  mutate(Percentage = round(100 * Count / sum(Count), 1))

# Diagram creation
pie_chart <- ggplot(data = df_pie, aes(x = "", y = Count, fill = Industry)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start = 0) +
  geom_text(aes(label = paste(Industry, "\n", Percentage, "%")), position = position_stack(vjust = 0.5), color = "white", size = 3) +  
  labs(fill = "Industry", title = "Industries overview among the selected startups") +  
  scale_fill_discrete(name = "Industry") +
  theme_void() +
  theme(legend.position = "right", plot.title = element_text(hjust = 0.5))  

print(pie_chart)


startup$status_text <- ifelse(startup$status == 1, "Acquired", "Not acquired")

# Number of acquired/non-acquired startups
status_counts <- table(startup$status_text)

df_bar <- data.frame(Status = names(status_counts), Count = as.numeric(status_counts))

# Diagram creation
bar_chart <- ggplot(data = df_bar, aes(x = Status, y = Count, fill = Status)) +
  geom_bar(stat = "identity") +
  labs(x = "Status", y = "Number of startups", title = "Number of acquired VS non-acquired startups") +
  scale_fill_manual(values = c("Acquired" = "blue", "Non-Acquired" = "red"),
                    labels = c("Acquired", "Non-Acquired")) +  
  geom_text(aes(label = Count), position = position_stack(vjust = 0.5), color = "black", size = 3, vjust = -0.5) +  
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))  

print(bar_chart)


scatter_plot_log <- ggplot(startup, aes(x = funding_rounds, y = log(funding_total_usd))) +
  geom_point() +
  labs(x = "Number of Funding Rounds", y = "Log of Total Funding in USD", 
       title = "Scatter Plot: Funding vs. Funding Rounds") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))

# Displaying the scatter plot with logarithmic transformation for better understanding
print(scatter_plot_log)


categories <- c("is_software", "is_web", "is_advertising", "is_mobile", "is_enterprise", "is_gamesvideo", "is_ecommerce", "is_consulting", "is_biotech", "is_othercategory")

# Vectors initialization 
count_vector_acquired <- numeric(length(categories))
count_vector_non_acquired <- numeric(length(categories))

# Loop accross all industries
for (i in seq_along(categories)) {
  category <- categories[i]
  count_vector_acquired[i] <- sum(startup[[category]] == 1 & startup$status == 1)
  count_vector_non_acquired[i] <- sum(startup[[category]] == 1 & startup$status == 0)
}

# Dataframe with the results
acquisitions_by_industry <- data.frame(Category = categories, Acquired = count_vector_acquired, Non_acquired = count_vector_non_acquired)
print(acquisitions_by_industry)

# Restructing
results_melted <- melt(acquisitions_by_industry, id.vars = "Category")

# Diagram creation
acquisitions_diagram <- ggplot(results_melted, aes(x = Category, y = value, fill = variable)) +
  geom_bar(position = "dodge", stat = "identity") +
  labs(x = "Industry", y = "Number of startups",
       title = "Number of Acquired and Non Acquired Startups by Industry",
       fill = "Status") +
  scale_fill_manual(values = c("blue", "red"), labels = c("Acquired", "Non Acquired")) +
  scale_x_discrete(labels = c("Software", "Web", "Advertising", "Mobile", "Enterprise", "Games/Video", "E-commerce", "Consulting", "Biotech", "Other")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))

print(acquisitions_diagram)




selected_vars <- startup[, c("age_first_funding_year", "age_last_funding_year", "milestones", "funding_total_usd","funding_rounds")]
scaled_data <- scale(selected_vars)



# Hierarchical clustering
dist_matrix <- dist(scaled_data)
hclust_model <- hclust(dist_matrix, method = "ward.D2")

# Assessing the silhouette scores for models with 2 to 10 clusters
num_clusters <- 2:10
sil_widths <- numeric(length(num_clusters))

# Loop on the different numbers of clusters
for (k in num_clusters) {
  cluster_assignments <- cutree(hclust_model, k)
  
  # Calculate silhouette matrix
  sil <- silhouette(cluster_assignments, dist = dist_matrix)
  
  # Extract silhouette widths from the sil matrix
  sil_widths[k - 1] <- mean(sil[, "sil_width"])
}

# Optimal number of clusters
optimal_clusters <- which.max(sil_widths) + 1
cat("Optimal number of clusters:", optimal_clusters, "\n")

# Plot silhouette scores
plot(num_clusters, sil_widths, type = "b", pch = 19, xlab = "Number of Clusters", ylab = "Average Silhouette Width", main = "Silhouette Scores for Different Numbers of Clusters")



# Imputing for missing data (closedt_at)

startup$closed_at <- as.Date(startup$closed_at) # Convert to Date if it's not already
median_date <- median(startup$closed_at, na.rm = TRUE)
startup$closed_at[is.na(startup$closed_at)] <- median_date


missing_count <- colSums(is.na(startup))
startup_missing <- as.data.frame(missing_count); startup_missing

startup$age_first_milestone_year <- ifelse(is.na(startup$age_first_milestone_year),median(startup$age_first_milestone_year,na.rm = T),startup$age_first_milestone_year)
startup$age_last_milestone_year <- ifelse(is.na(startup$age_last_milestone_year),median(startup$age_last_milestone_year,na.rm = T),startup$age_last_milestone_year)


missing_count_2 <- colSums(is.na(startup))
startup_missing_2 <- as.data.frame(missing_count_2); startup_missing_2

# Removing not required data sets from the environment
rm(startup_missing, startup_missing_2, missing_count, missing_count_2)


# ------------------------------Training and Modelling--------------------------------------------------------------


# Defining  the features and the target variable
features <- c("funding_total_usd", "funding_rounds", "milestones", "category_code", "state", "industry", "status")
dataset <- startup[, features]

# Convert categorical variables to factors
for (col in c("category_code", "state", "industry", "status")) {
  dataset[, col] <- as.factor(dataset[, col])
}

set.seed(7) 
train_indices <- sample(1:nrow(dataset), 0.7 * nrow(dataset))
train_data <- dataset[train_indices, ]
test_data <- dataset[-train_indices, ]


tree_model <- rpart(status ~ ., data = train_data, method = "class")

predictions_tree <- predict(tree_model, newdata = train_data, type = "class")

confusion_matrix_tree <- table(Predicted = predictions_tree, Actual = train_data$status)
print(confusion_matrix_tree)
accuracy_tree <- sum(diag(confusion_matrix_tree)) / sum(confusion_matrix_tree)
print(paste("Accuracy of Decision Tree model:", accuracy_tree))





#-----------------------------------------------Clustering(unsupervised)----------------------------------------------------
# Select features for clustering
df_cluster <- startup

cluster_features <- scale(df_cluster[, c("funding_total_usd", "milestones", "funding_rounds")]) # adjust features as needed

# Determine the optimal number of clusters (k)
set.seed(7)
wss <- sapply(1:10, function(k){kmeans(cluster_features, k, nstart = 20)$tot.withinss})
plot(1:10, wss, type = "b", xlab = "Number of Clusters", ylab = "Total Within Sum of Squares")

# Choose k based on the plot and train the model
optimal_k <- 3 # for example
kmeans_result <- kmeans(cluster_features, optimal_k, nstart = 20)
df_cluster$cluster <- kmeans_result$cluster


# Assign the most frequent status to each cluster
predicted_status_per_cluster <- aggregate(status ~ cluster, data = df_cluster, FUN = function(x) {
  names(which.max(table(x)))
})
names(predicted_status_per_cluster) <- c("cluster", "predicted_status")
df_cluster$predicted_status <- predicted_status_per_cluster[df_cluster$cluster, "predicted_status"]
confusion_matrix_kmeans <- table(Predicted = df_cluster$predicted_status, Actual = df_cluster$status)
accuracy_kmeans <- sum(diag(confusion_matrix_kmeans)) / sum(confusion_matrix_kmeans)
print(paste("Accuracy of K-Means Clustering:", accuracy_kmeans))






#------------------------------------------------Random Forest------------------------------------


df_rf <- startup

# Define features
features <- c("funding_total_usd", "funding_rounds", "milestones", "category_code", "state", "industry")
dataset2 <- df_rf[, c(features, "status")]

# Convert categorical variables to factors
for (col in c("category_code", "state", "industry", "status")) {
  dataset2[, col] <- as.factor(dataset2[, col])
}

set.seed(7)
train_indices <- sample(1:nrow(dataset2), 0.7 * nrow(dataset2))
train_data <- dataset2[train_indices, ]
test_data <- dataset2[-train_indices, ]
rf_model <- randomForest(x = train_data[, features], 
                         y = train_data$status,
                         ntree = 100)


prediction_rf <- predict(rf_model, newdata = test_data)
confusion_matrix_rf <- table(Predicted = prediction_rf, Actual = test_data$status)
print(confusion_matrix_rf)
accuracy_rf <- sum(diag(confusion_matrix_rf)) / sum(confusion_matrix_rf)
print(paste("Accuracy of Random Forest model:", accuracy_rf))



# ------------------------------------Ensambles---------------------------------------

predictions_tree <- predict(tree_model, newdata = test_data, type = "class")
predictions_rf <- predict(rf_model, newdata = test_data)

# Combine the predictions (Majority Voting)
combined_predictions <- data.frame(predictions_tree, predictions_rf)

# Determine the final predictions based on majority voting
final_predictions <- apply(combined_predictions, 1, function(x) {
  names(which.max(table(x)))
})
confusion_matrix_ensemble <- table(Predicted = final_predictions, Actual = test_data$status)
accuracy_ensemble <- sum(diag(confusion_matrix_ensemble)) / sum(confusion_matrix_ensemble)
print(paste("Accuracy of Ensemble model:", accuracy_ensemble))

# ----------------------------------------Saving & testing the models-------------------------------------------------------------------

saveRDS(tree_model, "models/tree_model.rds")
saveRDS(rf_model, "models/rf_model.rds")
new_data <- startup
tree_model <- readRDS("models/tree_model.rds")
rf_model <- readRDS("models/rf_model.rds")
features <- c("funding_total_usd", "funding_rounds", "milestones", "category_code", "state", "industry", "status")
dataset2 <- new_data[, c(features, "status")]
for (col in c("category_code", "state", "industry", "status")) {
  dataset2[, col] <- as.factor(dataset2[, col])
}


predictions_tree <- predict(tree_model, dataset2, type = "class")
predictions_rf <- predict(rf_model, dataset2)
combined_predictions <- data.frame(predictions_tree, predictions_rf)
final_predictions <- apply(combined_predictions, 1, function(x) {
  names(which.max(table(x)))
})
print(final_predictions)


category_code_levels <- levels(train_data$category_code)
state_levels <- levels(train_data$state)
industry_levels <- levels(train_data$industry)

print(category_code_levels)
print(state_levels)
print(industry_levels)
class(rf_model)

