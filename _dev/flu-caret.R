# credit ----
# Much of this work from https://shiring.github.io/machine_learning/2016/11/27/flu_outcome_ML_post

# init ----

library(tidyverse)
library(here)
theme_set(theme_bw())
setwd(here("_dev"))

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
  write_csv(here("data", "fluH7N9_china_2013.csv"))

flu <- read_csv(here("data", "fluH7N9_china_2013.csv"))
flu


# EDA ----
flu <- read_csv(here("data", "fluH7N9_china_2013.csv"))
flu

ggplot(flu, aes(age)) +
  geom_density(aes(fill=outcome), alpha=1/4) +
  geom_rug(aes(color=outcome))

ggplot(flu, aes(gender)) +
  geom_bar(aes(fill=outcome), position="dodge") +
  facet_wrap(~province)

flugather <- flu %>%
  gather(group, date, starts_with("date_"))
flugather

ggplot(flugather, aes(date, age)) +
  geom_point(aes(color=outcome, shape=gender)) +
  facet_grid(group~province)

ggplot(flugather, aes(date, y=age, color=outcome)) +
  geom_point() +
  geom_path(aes(group=case_id)) +
  facet_wrap(~province)

# features ----

median(flu$date_outcome, na.rm=TRUE)

fludata <- flu %>%
  # make female yes/no if gender is F, then remove gender. necessary?
  mutate(female = gender=="f") %>% select(-gender) %>%
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

fludata <- cbind(fludata, model.matrix(~0+province, data=fludata)) %>%
  as_tibble() %>%
  select(-province) %>%
  set_names(~gsub("province", "", .))

fludata

# imputation ----

library(mice)

fluimp <- fludata %>%
  select(-1, -2) %>%
  mice(print=FALSE) %>%
  complete()

fluimp <- fludata %>%
  select(1,2) %>%
  cbind(fluimp) %>%
  as_tibble()

fluimp

fluimp %>% write_csv(here("data", "fluH7N9_china_2013_analysisready.csv"))


# test/train/validation ----

fluimp <- read_csv(here("data", "fluH7N9_china_2013_analysisready.csv"))

fluimp

unknown <- fluimp %>%
  filter(is.na(outcome))

known <- fluimp %>%
  filter(!is.na(outcome))

# n <- nrow(known)
# sample(n, size=n*2/3)
# sample(n, size=n*2/3)
#
# set.seed(42)
# sample(n, size=n*2/3)
# set.seed(42)
# sample(n, size=n*2/3)
#

# library(mlr)
# lrn <- makeLearner("classif.lda")
# task <- makeClassifTask(data=known, target="outcome")
# model <- train(lrn, task, subset=trainindex)
# pred <- predict(model, task, subset=testindex)
# pred
#
# performance(pred, measures = list(mmce, acc))

control <- trainControl(method="repeatedcv", number=10, repeats=10)

known %>% select(-case_id) %>% mutate_at(vars(female, hospital, early_outcome:Zhejiang), factor)

set.seed(27)
model <- train(outcome~., data=known %>% select(-case_id), method="rf", preProcess=NULL, trControl=control)

importance <- varImp(model, scale=TRUE)
plot(importance)
?varImpPlot
