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


# packages needed by caret ----
library(caret)
library(randomForest)
library(gbm)
# others called by caret in model comparison section below


# init ----

library(tidyverse)
library(here)
library(caret)
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

library(tidyverse)
library(here)
library(caret)
fluimp <- read_csv(here("data", "fluH7N9_china_2013_analysisready.csv"))


fluimp

unknown <- fluimp %>%
  filter(is.na(outcome))
unknown

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

set.seed(27)
modrf <- train(outcome~., data=known, method="rf")
modrf
varImp(modrf, scale=TRUE)
varImp(modrf, scale=TRUE) %>% plot()

set.seed(28)
modgbm <- train(outcome~., data=known, method="gbm", verbose=FALSE)
modgbm
varImp(modrf, scale=TRUE)
varImp(modrf, scale=TRUE) %>% plot()

# compare models
modsum <- resamples(list(gbm=modgbm, rf=modrf))
summary(modsum)


# predict the unknowns
predict(modrf, newdata=unknown)
predict(modrf, newdata=unknown, type="prob")
# get them back in the data
unknown
unknown %>%
  mutate(outcome=predict(modrf, newdata=unknown))

# check that distributions are somewhat similar.
fluimp %>%
  gather(key, value, age, days_to_hospital, days_to_outcome) %>%
  ggplot(aes(outcome, value, fill=factor(female))) + geom_boxplot() + facet_wrap(~key, scale="free_y")
