import os
import pandas as pd
from pandas import DataFrame as df

#read data
train = pd.read_csv("/home/bonju/deepanalytics/jleague/train.csv")
train_add = pd.read_csv("/home/bonju/deepanalytics/jleague/train_add.csv")
condition = pd.read_csv("/home/bonju/deepanalytics/jleague/condition.csv")
condition_add = pd.read_csv("/home/bonju/deepanalytics/jleague/condition_add.csv")
stadium = pd.read_csv("/home/bonju/deepanalytics/jleague/stadium.csv")
test = pd.read_csv("/home/bonju/deepanalytics/jleague/test.csv")
sample = pd.read_csv("/home/bonju/deepanalytics/jleague/sample_submit.csv")

#union add_data
train_all = pd.concat([train, train_add])
condition_all = pd.concat([condition, condition_add])

#inner join condition and stadium
input_train_tmp = pd.merge(train_all, condition_all, how='inner', on="id")
input_train = pd.merge(input_train_tmp, stadium, how='inner', left_on="stadium", right_on="name")
input_test_tmp = pd.merge(test, condition_all, how='inner', on="id")
input_test = pd.merge(input_test_tmp, stadium, how='inner', left_on="stadium", right_on="name")

#drop dupulicate columns
del input_train["stadium"]
del input_train["home_team"]
del input_train["away_team"]
del input_test["stadium"]
del input_test["home_team"]
del input_test["away_team"]

input_train.dtypes

# create regression model



