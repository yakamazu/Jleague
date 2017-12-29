# library
library(dplyr)

# read data
train <- read.csv('/home/bonju/deepanalytics/jleague/train.csv')
train_add <- read.csv('/home/bonju/deepanalytics/jleague/train_add.csv')
condition <- read.csv('/home/bonju/deepanalytics/jleague/condition.csv')
condition_add <- read.csv('/home/bonju/deepanalytics/jleague/condition_add.csv')
stadium <- read.csv('/home/bonju/deepanalytics/jleague/stadium.csv')
test <- read.csv('/home/bonju/deepanalytics/jleague/test.csv')
sample <- read.csv('/home/bonju/deepanalytics/jleague/sample_submit.csv')

# union add_data
train_all <- dplyr::union(train, train_add)
condition_all <- dplyr::union(condition, condition_add)

# inner join 
input_train_tmp <- dplyr::inner_join(train_all, condition_all, by=c("id" = "id"))
input_train <- dplyr::inner_join(input_train_tmp, stadium, by=c("stadium" = "name"))
input_test_tmp <- dplyr::inner_join(test, condition_all, by=c("id" = "id"))
input_test <- dplyr::inner_join(input_test_tmp, stadium, by=c("stadium" = "name"))

#confirm data type
class(input_train$time)
sapply(input_train, class)
sapply(input_test, class)

#convert_2factor
#input_train$weather <- as.factor(input_train$weather)
#input_train$stage <- as.factor(input_train$stage)
#input_train$match <- as.factor(input_train$match)
#input_test$weather <- as.factor(input_test$weather)
#input_test$stage <- as.factor(input_test$stage)
#input_test$match <- as.factor(input_test$match)

#add new column(time_hour, match_num, humidity_num, yobi, weather)
input_train <- input_train %>% dplyr::mutate(time_h = substr(input_train$time, 1, 2))
input_train <- input_train %>% dplyr::mutate(match_num = substr(input_train$match, 2, 3))
input_train <- input_train %>% dplyr::mutate(humidity_num = as.numeric(sub("%", "", input_train$humidity)))
input_train <- input_train %>% dplyr::mutate(yobi = sub("^.*・", "", sub("\\)", "", sub("^.*\\(", "", input_train$gameday))))
input_train <- input_train %>% dplyr::mutate(weather_1 = substr(input_train$weather, 1, 1))
#input_train <- input_train %>% dplyr::mutate(weather_sunny = if (grep("晴", input_train$weather) > 0) {1} else {0})

input_test <- input_test %>% dplyr::mutate(time_h = substr(input_test$time, 1, 2))
input_test <- input_test %>% dplyr::mutate(match_num = substr(input_test$match, 2, 3))
input_test <- input_test %>% dplyr::mutate(humidity_num = as.numeric(sub("%", "", input_test$humidity)))
input_test <- input_test %>% dplyr::mutate(yobi = sub("^.*・", "", sub("\\)", "", sub("^.*\\(", "", input_test$gameday))))
input_test <- input_test %>% dplyr::mutate(weather_1 = substr(input_test$weather, 1, 1))

#input_train$time_h <- as.factor(input_train$time_h)
#input_train$match_num <- as.factor(input_train$match_num)
#input_test$time_h <- as.factor(input_test$time_h)
#input_test$match_num <- as.factor(input_test$match_num)

# create regression model
doinsu.lm <- lm(y ~ stage + time_h + capa + match_num + temperature + humidity_num + yobi + away +weather_1, data=input_train)

summary(doinsu.lm)
kekka <- input_test %>% dplyr::mutate(y = predict(doinsu.lm, newdata=input_test)) %>% select(id, y)

#export csv
write.csv(kekka, "export.csv", quote=FALSE, row.names=FALSE)

