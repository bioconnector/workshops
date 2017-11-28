# credit ----
# Much of this work from https://shiring.github.io/machine_learning/2016/11/27/flu_outcome_ML_post

# A. Kucharski, H. Mills, A. Pinsent, C. Fraser, M. Van Kerkhove, C. A.
# Donnelly, and S. Riley. 2014. Distinguishing between reservoir exposure and
# human-to-human transmission for emerging pathogens using case onset data. PLOS
# Currents Outbreaks. Mar 7, edition 1. doi:
# http://doi.org/10.1371/currents.outbreaks.e1473d9bfc99d080ca242139a06c455f

# A. Kucharski, H. Mills, A. Pinsent, C. Fraser, M. Van Kerkhove, C. A.
# Donnelly, and S. Riley. 2014. Data from: Distinguishing between reservoir
# exposure and human-to-human transmission for emerging pathogens using case
# onset data. Dryad Digital Repository. http://dx.doi.org/10.5061/dryad.2g43n.

# Line list available at http://datadryad.org/resource/doi:10.5061/dryad.2g43n/1


# lead in ideas ----
# do this more simply with iris first?
# show data cleaning / feature extraction, then provide analysis-ready data to use?


# init ----

library(tidyverse)
library(here)
theme_set(theme_bw())
setwd(here("_dev"))


# packages needed by caret ----
library(caret)
library(randomForest)
library(gbm)
library(glmnet)
library(kknn)
# others called by caret in model comparison section below




# create data ----

# create semiclean data ----
outbreaks::fluH7N9_china_2013 %>%
  # remove the two cases where gender or age is missing
  filter(!is.na(gender) & age!="?") %>%
  # Make age numeric
  mutate(age=as.numeric(age)) %>%
  # american english please
  rename(date_of_hospitalization = date_of_hospitalisation) %>%
  # lump all but three of the most common provinces together
  mutate(province=forcats::fct_lump(province, 3)) %>%
  # make the names easier to deal with
  set_names(~gsub("_of_", "_", .)) %>%
  # make this more explicitly a string/factor
  mutate(case_id=paste0("case_", case_id)) %>%
  as_tibble() %>%
  write_csv(here("data", "h7n9.csv"))

flu <- read_csv(here("data", "h7n9.csv"))
flu


# EDA ----

# Read in data
flu <- read_csv(here("data", "h7n9.csv"))
flu

# Feel free to follow along but don't worry if not grokking code here, not doing
# any data transformations that needed later.

# Look at the distribution of death, recovery, and missing, by age
ggplot(flu, aes(age)) +
  geom_density(aes(fill=outcome), alpha=1/3)

# Look at distribution by gender across provinces
ggplot(flu, aes(gender)) +
  geom_bar(aes(fill=outcome), position="dodge") +
  facet_wrap(~province)

# Show the distribution of age by province, colored by outcome. This shows that
# there's a higher rate of death in older individuals but this is only observed
# in Jiangsu and Zhejiang provinces.
ggplot(flu, aes(province, age)) + geom_boxplot(aes(fill=outcome))

# Gather the data where we have the different date variables as a column
flugather <- flu %>%
  gather(key, date, starts_with("date_"))
flugather
# Show how many days passed between onset, hospitalization, and outcome, for each case.
# Lots of missing data points, difficult to draw a conclusion.
ggplot(flugather, aes(date, y=age, color=outcome)) +
  geom_point() +
  geom_path(aes(group=case_id)) +
  facet_wrap(~province)

# features ----

median(flu$date_outcome, na.rm=TRUE)

fludata <- flu %>%
  # make male yes/no if gender is F, then remove gender.
  mutate(male = gender=="m") %>% select(-gender) %>%
  # Was someone ever hospitalized?
  mutate(hospital = !is.na(date_hospitalization)) %>%
  mutate(days_to_hospital = as.numeric(date_hospitalization - date_onset)) %>%
  mutate(days_to_outcome  = as.numeric(date_outcome - date_onset)) %>%
  mutate(early_outcome = date_outcome < median(date_outcome, na.rm=TRUE)) %>%
  select(-starts_with("date")) %>%
  mutate_if(is.logical, as.integer)

fludata

# is this dummy-variable creation necessary or will caret just do it for you? test both ways.
model.matrix(~0+province, data=fludata)

# bind the columns with the original data
cbind(fludata, model.matrix(~0+province, data=fludata))

# turn it into a tibble, remove the province variable
fludata <- cbind(fludata, model.matrix(~0+province, data=fludata)) %>%
  as_tibble() %>%
  select(-province)

fludata

# Remove "province" from the names
names(fludata)
gsub("province", "", names(fludata))
names(fludata) <- gsub("province", "", names(fludata))
fludata



# imputation ----

library(mice)

# "outcome" is what we want to try to predict, but we need to impute missing values in other variables.
# take flu data, remove case id and outcome variable, run mice to impute
fluimp <- fludata %>%
  select(-1, -2) %>%
  mice(print=FALSE) %>%
  complete()

# put the data back together
fluimp <- fludata %>%
  select(1,2) %>%
  cbind(fluimp) %>%
  as_tibble()

fluimp

fluimp %>% write_csv(here("data", "h7n9_analysisready.csv"))


# test/train/validation ----

library(tidyverse)
library(here)
library(caret)
fluimp <- read_csv(here("data", "h7n9_analysisready.csv"))


fluimp

# these are samples with unknown data we'll use later to predict
unknown <- fluimp %>%
  filter(is.na(outcome))
unknown

# samples with known outcomes
known <- fluimp %>%
  filter(!is.na(outcome)) %>%
  select(-case_id)
known

# bootstrapping or CV?

# see useR talk 2013 from Kuhn
# http://www.edii.uclm.es/~useR-2013/Tutorials/kuhn/user_caret_2up.pdf

# Bootstrapping takes a random sample with replacement. The random sample is the
# same size as the original data set. Samples may be selected more than once and
# each sample has a 63.2% chance of showing up at least once. Some samples won't
# be selected and these samples will be used to predict performance. The process
# is repeated multiple times (say 30?100).

# ?train
# control <- trainControl(method="repeatedcv", number=10, repeats=10)
# set.seed(27)
# modrf <- train(outcome~., data=known, method="rf", preProcess=NULL, trControl=control)

# random forest
set.seed(42)
modrf <- train(outcome~., data=known, method="rf")
modrf
varImp(modrf, scale=TRUE)
varImp(modrf, scale=TRUE) %>% plot()

# gradient boosting
set.seed(43)
modgbm <- train(outcome~., data=known, method="gbm", verbose=FALSE)
modgbm
varImp(modgbm, scale=TRUE)
varImp(modgbm, scale=TRUE) %>% plot()

# compare models
modsum <- resamples(list(gbm=modgbm, rf=modrf))
summary(modsum)

# LASSO / Elastic-Net Regularized Generalized Linear Models
set.seed(44)
modlasso <- train(outcome~., data=known, method="glmnet")
modlasso

# k-nearest neighbors
set.seed(45)
modknn <- train(outcome~., data=known, method="kknn")
modknn


# compare models
modsum <- resamples(list(gbm=modgbm, rf=modrf, lasso=modlasso, knn=modknn))
summary(modsum)
bwplot(modsum)


# predict the unknowns
predict(modrf, newdata=unknown)
# get them back in the data
unknown
unknown %>%
  mutate(outcome=predict(modrf, newdata=unknown))

# Prediction probabilities
predict(modrf, newdata=unknown, type="prob") %>% head()

# # sum up prediction probabilities
# predict(modrf, newdata=unknown, type="prob")
# data.frame(rf    = predict(modrf,    newdata=unknown, type="prob"),
#            gbm   = predict(modgbm,   newdata=unknown, type="prob"),
#            knn   = predict(modknn,   newdata=unknown, type="prob"),
#            lasso = predict(modlasso, newdata=unknown, type="prob")) %>%
#   as_tibble() %>%
#   mutate(sumdeath = rf.Death + gbm.Death + knn.Death + lasso.Death,
#          sumrecover = rf.Recover + gbm.Recover + knn.Recover + lasso.Recover,
#          log2ratio=log2(sumdeath/sumrecover)) %>%
#   mutate(outcome=case_when(
#     log2ratio > 1 ~ "Death",
#     log2ratio < -1 ~ "Recover",
#     TRUE ~ "UNCERTAIN"
#   )) %>% View


# check that distributions are somewhat similar.
fluimp %>%
  gather(key, value, age, days_to_hospital, days_to_outcome) %>%
  ggplot(aes(outcome, value, fill=factor(male))) + geom_boxplot() + facet_wrap(~key, scale="free_y")




# flu forecasting with prophet --------------------------------------------

# devtools::install_github("hrbrmstr/cdcfluview")
library(tidyverse)
library(cdcfluview)
age_group_distribution(years=2015)
geographic_spread(2015)
?hospitalizations
?ilinet

ili <- ilinet()
ili
ili <- ili %>% select(week_start, ilitotal, total_patients)
ili

pi <- pi_mortality(coverage_area = "national")
pi
pi <- pi %>% transmute(week_start=wk_start+1, fludeaths=number_influenza, pneumoniadeaths=number_pneumonia, all_deaths)
pi

ilidata <- ili %>%
  left_join(pi, by="week_start") %>%
  filter(!is.na(week_start)) %>%
  filter(week_start>="2003-01-01" & week_start<="2017-10-31")

ilidata %>% write_csv(here::here("data", "ilinet.csv"))


library(tidyverse)
ilidata
ilidata %>% tail
ggplot(ilidata, aes(week_start, ilitotal)) + geom_line()
ggplot(ilidata, aes(week_start, fludeaths)) + geom_line()


ilidata

library(prophet)
ilidata
?prophet
m <- ilidata %>%
  select(ds=week_start, y=ilitotal) %>%
  prophet
future <- make_future_dataframe(m, periods=365*5)
forecast <- predict(m, future)
tail(forecast)
plot(m, forecast)
prophet_plot_components(m, forecast)
prophet:::plot.prophet

m <- ilidata %>%
  filter(!is.na(fludeaths)) %>%
  select(ds=week_start, y=fludeaths) %>%
  prophet
future <- make_future_dataframe(m, periods=365*5)
forecast <- predict(m, future)
tail(forecast)
plot(m, forecast)
prophet_plot_components(m, forecast)
