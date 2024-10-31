library(sf)
temp_train = read_sf("data/temp_train.gpkg")
plot(temp_train)

spain = read_sf("data/spain.gpkg")
plot(spain)

library(terra)
predictors = rast("data/predictors.tif")
plot(predictors, axes = FALSE)

temp = extract(predictors, temp_train, ID = FALSE)
temp_train = cbind(temp_train, temp)
head(temp_train)

grid_raster = rast(predictors)
grid_raster


library(rpart)
rpart_model = rpart(temp ~ ., data = st_drop_geometry(temp_train))

plot(rpart_model, margin = 0.2)
text(rpart_model)

temp_pred = predict(predictors, rpart_model)
plot(temp_pred)

library(mlr3)
library(mlr3learners)
library(mlr3spatiotempcv)
lgr::get_logger("mlr3")$set_threshold("warn")

task = mlr3spatiotempcv::as_task_regr_st(temp_train, target = "temp")
task

mlr3::mlr_learners

learner_rpart = mlr3::lrn("regr.rpart")
learner_rpart

mlr_resamplings

resampling = mlr3::rsmp("repeated_cv", folds = 5, repeats = 20)
resampling

rr_cv_rpart = mlr3::resample(task = task,
                            learner = learner_rpart,
                            resampling = resampling)
rr_cv_rpart

mlr_measures

my_measures = c(mlr3::msr("regr.rmse"), mlr3::msr("rsq"))

score_cv_rpart = rr_cv_rpart$score(measures = my_measures)
head(score_cv_rpart)

hist(score_cv_rpart$regr.rmse)

mean(score_cv_rpart$regr.rmse)
mean(score_cv_rpart$rsq)

learner_rpart$train(task)

pred_rpart = terra::predict(predictors, model = learner_rpart, na.rm = TRUE)
plot(pred_rpart)

spcv_resampling = mlr3::rsmp("repeated_spcv_coords", folds = 5, repeats = 20) 

rr_spcv_rpart = mlr3::resample(task = task,
                               learner = learner_rpart,
                               resampling = spcv_resampling)
rr_spcv_rpart

score_spcv_rpart = rr_spcv_rpart$score(measures = my_measures)
head(score_spcv_rpart)

hist(score_spcv_rpart$regr.rmse)

# non-spatial RMSE: 1.14
mean(score_spcv_rpart$regr.rmse) 
# non-spatial R2: 0.82
mean(score_spcv_rpart$rsq)

importance = learner_rpart$importance()
importance

library(ggplot2)
imp_df = data.frame(variable = names(importance), importance = importance)
ggplot(imp_df, aes(x = reorder(variable, importance), y = importance)) +
  geom_col() +
  coord_flip()

library(CAST)
AOA = aoa(predictors, train = st_drop_geometry(temp_train),
          variables = task$feature_names, weight = data.frame(t(importance)),
          verbose = FALSE)
plot(AOA)

plot(AOA[[2]])

plot(AOA[[3]])

library(DALEX)
library(DALEXtra)
regr_exp = DALEXtra::explain_mlr3(learner_rpart,
                                  data = st_drop_geometry(temp_train)[-1],
                                  y = temp_train$temp)

regr_exp_profiles = model_profile(regr_exp)
plot(regr_exp_profiles)

my_obs = st_drop_geometry(temp_train)[42, ]
plot(predict_parts(regr_exp, new_observation = my_obs))

plot(predict_profile(regr_exp, my_obs))

source("R/predict_parts_spatial.R")
regr_pps = predict_parts_spatial(predictors, regr_exp, maxcell = 2000)
plot(regr_pps)

