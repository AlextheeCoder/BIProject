library(adabag)
library(dplyr)
library(e1071)
library(rpart)
library(rpart.plot)
library(caret)
library(ggplot2)
library(ROCit)
library(ggcorrplot)

df<- read.csv("data/startupdata.csv" , stringsAsFactors = F)

head(df)

table(df$state_code)
table(df$category_code)
table(df$status)
table(df$state_code, df$status)

# Isuue 1 --------------------------------------------
# Mean
mean(df$funding_total_usd, na.rm = TRUE)

# Median
median(df$funding_total_usd, na.rm = TRUE)

# Mode is not a built-in function in R, but can be defined like this:
getMode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}
getMode(df$funding_total_usd)

# Range
range(df$funding_total_usd, na.rm = TRUE)

# Quartiles
quantile(df$funding_total_usd, na.rm = TRUE)

# Variance
var(df$funding_total_usd, na.rm = TRUE)

# Standard Deviation
sd(df$funding_total_usd, na.rm = TRUE)


# Correlation
cor(df$age_first_funding_year, df$funding_total_usd, use = "complete.obs")

# Issue 2 ------------------------------------------------------------------
#Annova
anova_model <- aov(funding_total_usd ~ state_code, data = df)
summary(anova_model)
TukeyHSD(anova_model)


#Issue 3 Data Exploration & Visualization-----------------

#str 
str(df)

#Scatter plot of latitude and longitude
ggplot(df, aes(x = longitude, y = latitude)) +
  geom_point() +
  labs(x = "Longitude", y = "Latitude") +
  theme_bw()

#Trend in funding rounds
ggplot(df, aes(x = funding_rounds)) +
  geom_histogram(fill = "skyblue", color = "white", binwidth = 1) +
  ggtitle("Distribution of Funding Rounds") +
  xlab("Number of Funding Rounds") +
  ylab("Count")

#Regional trends in startup funding 
df %>% 
  group_by(state_code) %>% 
  summarize(avg_funding = mean(funding_total_usd))%>% 
  ggplot(aes(x=state_code, y=avg_funding)) +
  geom_bar(stat="identity", fill="skyblue", color="White") +
  ggtitle("Average Funding by State") +
  xlab("State") +
  ylab("Average Funding (in USD)")

#Bar plot of category code
ggplot(df, aes(y = category_code)) +
  geom_bar() +
  labs(y = "Category Code", x = "Count") +
  theme_bw()

#Box plot of funding total by category
ggplot(df, aes(y = category_code, x = funding_total_usd/1000000)) +
  geom_boxplot() +
  labs(y = "Category Code", x = "Funding Total (Millions of USD)") +
  theme_bw() +
  scale_x_continuous(limits = c(0, 300))


#Bar plot of status by category
ggplot(df, aes(y = category_code, fill = status)) +
  geom_bar() +
  labs(y = "Category Code", x = "Count") +
  theme_bw() +
  scale_fill_manual(values = c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728"))

#Regional trends in startup funding
df %>%
  group_by(status) %>%
  summarize(avg_funding = mean(funding_total_usd)) %>%
  ggplot(aes(x = status, y = avg_funding)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "white") +
  ggtitle("Average Funding by Status") +
  xlab("Status") +
  ylab("Average Funding (in USD)")


#Bar chart of count of companies by state:
df_state <- df %>%
  group_by(state_code) %>%
  summarise(count = n()) %>%
  arrange(desc(count))

ggplot(df_state, aes(y = state_code, x = count, fill = state_code)) +
  geom_col() +
  labs(y = "State Code", x = "Count of Companies") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))



# select relevant numeric variables
startup_data_num <- select_if(df, is.numeric)
# compute correlation matrix
corr_matrix <- cor(startup_data_num, use = "pairwise.complete.obs")




# plot correlation heat map
ggcorrplot(corr_matrix, hc.order = TRUE, type = "lower", 
           lab_size = 3, ggtheme = ggplot2::theme_gray, 
           colors = c("#6D9EC1", "white", "#E46726"))


#Issue 4
# Changing the date formats

df$founded_at <- as.Date(df$founded_at, '%m/%d/%Y')
df$closed_at <- as.Date(df$closed_at, '%m/%d/%Y')
df$first_funding_at <- as.Date(df$first_funding_at, '%m/%d/%Y')
df$last_funding_at <- as.Date(df$last_funding_at, '%m/%d/%Y')

View(df)

# Removing unwanted columns:
df <- subset(df , select = -c(Unnamed..0, Unnamed..6, id, object_id, zip_code, 
                              city, labels , state_code.1))


# issue 5
# Finding and treating the missing values:

missing_count <- colSums(is.na(df))
df_missing <- as.data.frame(missing_count); df_missing

df$age_first_milestone_year <- ifelse(is.na(df$age_first_milestone_year),median(df$age_first_milestone_year,na.rm = T),df$age_first_milestone_year)
df$age_last_milestone_year <- ifelse(is.na(df$age_last_milestone_year),median(df$age_last_milestone_year,na.rm = T),df$age_last_milestone_year)


missing_count_2 <- colSums(is.na(df))
df_missing_2 <- as.data.frame(missing_count_2); df_missing_2

# Removing not required data sets from the environment
rm(df_missing, df_missing_2, missing_count, missing_count_2)


#I have imputed the null values with the median values for these 2 columns


# Finding duplicates:

table(duplicated(df))

# No duplicates are found

# Finding outliers:

# Selecting numerical variable for checking outliers
df_outliers <- subset(df , select = c(relationships,
                                      funding_rounds,
                                      milestones,
                                      avg_participants))
# Boxplot for all these variables
boxplot(df_outliers, main = "Multiple Boxplots", xlab = "Variables", ylab = "Values")


#Treating outliers for Avg_participants variable with  Interquartile Range:

q1 <- quantile(df$avg_participants, probs = 0.25)
q3 <- quantile(df$avg_participants, probs = 0.75)

iqr <- q3-q1
LL_avg_participants <- q1 - 1.5 * iqr
UL_avg_participants <- q3 + 1.5 * iqr

df_clean <- df[df$avg_participants >= LL_avg_participants & df$avg_participants <= UL_avg_participants,]


# Treating outliers for relationships variable with  Interquartile Range:

q1_rel <- quantile(df_clean$relationships, probs = 0.25)
q3_rel <- quantile(df_clean$relationships, probs = 0.75)

iqr_rel <- q3-q1
LL_rel <- q1_rel - 1.5 * iqr_rel
UL_rel <- q3_rel + 1.5 * iqr_rel

df_clean <- df_clean[df_clean$relationships >= LL_rel & df_clean$relationships <= UL_rel,]

# Boxplot for cleaned variables 
df_outliers_clean <- subset(df_clean , select = c(relationships,
                                                  funding_rounds,
                                                  milestones,
                                                  avg_participants))


boxplot(df_outliers_clean, main = "Multiple Boxplots", xlab = "Variables", ylab = "Values")


# Removing unwanted data frames:
rm(df_outliers, df_outliers_clean)


View(df)
df$closed_at <- as.Date(df$closed_at) # Convert to Date if it's not already
median_date <- median(df$closed_at, na.rm = TRUE)
df$closed_at[is.na(df$closed_at)] <- median_date

View(df)
# training & Modelling

#-------------------------Naive Bayes----------------------------------------------------------

# Preparing the data
df_nb <- subset(df_clean, select = -c(name, latitude, longitude, closed_at, category_code))
df_nb[sapply(df_nb, is.character)] <- lapply(df_nb[sapply(df_nb, is.character)], as.factor)

set.seed(2)
trainIndex <- createDataPartition(df_nb$status, p = .70, list = FALSE)
train.dfnb <- df_nb[trainIndex,]
test.dfnb <- df_nb[-trainIndex,]





control.rcv <- trainControl(method = "repeatedcv", number = 10, repeats = 3)
fit.nb.rcv <- train(status ~ ., data = train.dfnb, method = "naive_bayes", trControl = control.rcv)

# Predict and evaluate on test data
predictions.rcv <- predict(fit.nb.rcv, test.dfnb)
cm.rcv <- confusionMatrix(predictions.rcv, test.dfnb$status)
print(cm.rcv)



# --------------------------------------KNN------------------------------------

df_knn <- subset(df_clean,select =-c(name, latitude, longitude, closed_at, category_code))

# convert output as factor
df_knn$state_code <- as.factor(df_knn$state_code)
df_knn$status <- as.factor(df_knn$status)
df_knn$funding_rounds <- as.factor(df_knn$funding_rounds)
df_knn$milestones <- as.factor(df_knn$milestones)
df_knn$is_CA <- as.factor(df_knn$is_CA)
df_knn$is_NY <- as.factor(df_knn$is_NY)
df_knn$is_MA <- as.factor(df_knn$is_MA)
df_knn$is_TX <- as.factor(df_knn$is_TX)
df_knn$is_otherstate <- as.factor(df_knn$is_otherstate)
df_knn$has_VC <- as.factor(df_knn$has_VC)
df_knn$has_angel <- as.factor(df_knn$has_angel)
df_knn$has_roundA <- as.factor(df_knn$has_roundA)
df_knn$has_roundB <- as.factor(df_knn$has_roundB)
df_knn$has_roundC <- as.factor(df_knn$has_roundC)
df_knn$has_roundD <- as.factor(df_knn$has_roundD)
df_knn$is_top500 <- as.factor(df_knn$is_top500)
df_knn$is_software <- as.factor(df_knn$is_software)
df_knn$is_web <- as.factor(df_knn$is_web)
df_knn$is_mobile <- as.factor(df_knn$is_mobile)
df_knn$is_enterprise <- as.factor(df_knn$is_enterprise)
df_knn$is_advertising <- as.factor(df_knn$is_advertising)
df_knn$is_gamesvideo <- as.factor(df_knn$is_gamesvideo)
df_knn$is_ecommerce <- as.factor(df_knn$is_ecommerce)
df_knn$is_biotech <- as.factor(df_knn$is_biotech)
df_knn$is_consulting <- as.factor(df_knn$is_consulting)
df_knn$is_othercategory <- as.factor(df_knn$is_othercategory)
df_knn$status <- as.factor(df_knn$status)

# Split the data into training and testing sets
set.seed(2)  # For reproducible results
# 70% of data for training and 30% for testing
index <- createDataPartition(df_knn$status, p = 0.70, list = FALSE)
train.df_knn <- df_knn[index, ]
test.df_knn <- df_knn[-index, ]


set.seed(2)
ctrl.rcv <- trainControl(method = "repeatedcv", number = 10, repeats = 3)  # 10-fold CV repeated 3 times
knnFit.rcv <- train(status ~ ., data = df_knn, method = "knn", trControl = ctrl.rcv, preProcess = c("center", "scale"), tuneLength = 10)
print(knnFit.rcv)


# Evaluate the Repeated Cross-Validation Model
predictions.rcv <- predict(knnFit.rcv, newdata = test.df_knn)
confusionMatrix(predictions.rcv, test.df_knn$status)





# -------------------------Logistic Regression----------------------------------


df_logit <- df_clean
df_logit$status <- as.factor(df_logit$status)


df[sapply(df, is.character)] <- lapply(df[sapply(df, is.character)], 
                                       as.factor)


set.seed(2)   # for reproducible results
train <- sample(1:nrow(df_logit), (0.6)*nrow(df_logit))
train.df <- df_logit[train,]
test.df <- df_logit[-train,]


logit.reg <- glm(status ~  age_first_funding_year + age_last_funding_year + age_first_milestone_year + 
                   age_last_milestone_year + relationships + funding_rounds + funding_total_usd + milestones + 
                   is_CA + is_NY + is_MA + is_TX + is_otherstate + category_code + is_software + is_web + is_mobile + 
                   is_enterprise + is_advertising + is_gamesvideo + is_ecommerce + is_biotech + is_consulting + 
                   is_othercategory + has_VC + has_angel + has_roundA + has_roundB + has_roundC + has_roundD + 
                   avg_participants + is_top500, data = df_logit, family = "binomial") 


summary(logit.reg)

logitPredict <- predict(logit.reg, train.df, type = "response")
# we choose 0.5 as the cutoff here for 1 vs. 0 classes
logitPredictClass <- ifelse(logitPredict > 0.5, 1, 0)

# For train data
actual <- train.df$status
predict <- logitPredictClass
cm <- table(predict, actual)
cm

tp <- cm[2,2]
tn <- cm[1,1]
fp <- cm[2,1]
fn <- cm[1,2]
# accuracy
(tp + tn)/(tp + tn + fp + fn)
# TPR = Recall = Sensitivity
tp/(fn+tp)
# TNR = Specificity
tn/(fp+tn)
# FPR
fp/(fp+tn)
# FNR
fn/(fn+tp)




logitPredict_test <- predict(logit.reg, test.df, type = "response")
logitPredictClass <- ifelse(logitPredict_test > 0.5, 1, 0)

actual_test <- test.df$status
predict <- logitPredictClass
cm <- table(predict, actual_test)
cm

# consider class "1" as positive
tp <- cm[2,2]
tn <- cm[1,1]
fp <- cm[2,1]
fn <- cm[1,2]
# accuracy
(tp + tn)/(tp + tn + fp + fn)
# TPR = Recall = Sensitivity
tp/(fn+tp)
# TNR = Specificity
tn/(fp+tn)
# FPR
fp/(fp+tn)
# FNR
fn/(fn+tp)



# ----------------------
# Ensure both are factors
logitPredictClass <- factor(logitPredictClass)
test.df$status <- factor(test.df$status)

# Set the same levels for both factors
levels(logitPredictClass) <- levels(test.df$status)

# Now, compute the confusion matrix
logit_metrics <- confusionMatrix(logitPredictClass, test.df$status)$byClass[c("Sensitivity", "Specificity", "Pos Pred Value", "Neg Pred Value", "Precision", "Recall", "F1")]

# Print the metrics
print(logit_metrics)


#----------------------------


# For Naive Bayes
nb_metrics <- cm.rcv$byClass[c("Sensitivity", "Specificity", "Pos Pred Value", "Neg Pred Value", "Precision", "Recall", "F1")]

# For KNN
knn_metrics <- confusionMatrix(predictions.rcv, test.df_knn$status)$byClass[c("Sensitivity", "Specificity", "Pos Pred Value", "Neg Pred Value", "Precision", "Recall", "F1")]

# For Logistic Regression
logit_metrics <- confusionMatrix(logitPredictClass, test.df$status)$byClass[c("Sensitivity", "Specificity", "Pos Pred Value", "Neg Pred Value", "Precision", "Recall", "F1")]


# Combine metrics into a data frame
model_comparison <- data.frame(
  NaiveBayes = nb_metrics,
  KNN = knn_metrics,
  LogisticRegression = logit_metrics
)

# Print comparison
print(model_comparison)









# Assuming you have the train.df and test.df datasets ready

# 1. Train Base Models - Already done
# Checking the type in the original training dataset
str(df_knn$funding_rounds)

# Converting the type in train.df to match
train.df$funding_rounds <- as.factor(train.df$funding_rounds)

# 2. Create Predictions on Training Set
nb_pred_train <- predict(fit.nb.rcv, train.df, type = "raw")
knn_pred_train <- predict(knnFit.rcv, train.df, type = "raw")
logit_pred_train <- ifelse(predict(logit.reg, train.df, type = "response") > 0.5, 1, 0)

# Combine predictions for training
train_predictions <- data.frame(nb_pred_train, knn_pred_train, logit_pred_train)

# 3. Train Meta-Model (e.g., Logistic Regression)
meta_model <- glm(status ~ ., data = train_predictions, family = "binomial")

# 4. Create Predictions on Test Set
nb_pred_test <- predict(fit.nb.rcv, test.df, type = "raw")
knn_pred_test <- predict(knnFit.rcv, test.df, type = "raw")
logit_pred_test <- ifelse(predict(logit.reg, test.df, type = "response") > 0.5, 1, 0)

# Combine predictions for testing
test_predictions <- data.frame(nb_pred_test, knn_pred_test, logit_pred_test)

# 5. Use Meta-Model for Final Prediction
final_pred <- predict(meta_model, test_predictions, type = "response")
final_pred_class <- ifelse(final_pred > 0.5, 1, 0)

# Evaluate the final model
final_cm <- confusionMatrix(factor(final_pred_class, levels = levels(test.df$status)), test.df$status)

# Print the final model performance
print(final_cm)

