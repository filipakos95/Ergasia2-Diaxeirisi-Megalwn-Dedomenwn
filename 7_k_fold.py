from sklearn.linear_model import LinearRegression
from math import sqrt # We'll need sqrt()
import statistics # for mean()
from sklearn.metrics import mean_squared_error # for mean_squared_error which calculates 
from sklearn.model_selection import KFold # import KFold
from sklearn.preprocessing import PolynomialFeatures
import numpy as np
import pandas as pd


# Read the data
hhData = pd.read_csv("forestfires.csv", header=0, sep=",", engine='python')

#sampling
#hhData = hhData.sample(frac=1).reset_index(drop=True)

kf = KFold(n_splits=10)

# Create an empty array where we will store the calculated RMSE values
# so that we may be able to 
allRMSE = np.empty(shape=[0, 1])

# Just a variable to count at which tests we are
testNumber = 0

for train_index, test_index in kf.split(hhData):

 # Next test
 testNumber += 1
 
 # Use the current indexes train_index and test_index to get the actual observations for the
 # training and testing of the model respectively.

 # From the original, complete dataset get the data with which we will use TRAIN our model (aka the training set),
 # i.e. estimate the coefficients. We get the rows designated by train_index and all their columns/variables
 trainingData = hhData.iloc[train_index,:]

 # From the original, complete dataset get the data with which we will TEST our model, i.e. estimate its
 # accuracy. This is the "unknown" dataset.
 # Note: we do know the value of the dependent variable FoodExpenditure for the testing set
 # and hence we will be able to estimate the prediction error/accuracy
 testData = hhData.iloc[test_index,:]

 # Use the training data to estimate the coefficients of the multiple linear regression model.
 # The model we will estimate is: FoodExpenditure = b1Income + b2FamilySize + b0
 lm = LinearRegression(normalize=False, fit_intercept=True)

 # Since the linear regression model has as independent variables Income and FamilySize,
 # we get these variables from the training dataset.
 # The method .fit() does the actual estimation of the coefficients for the linear regression
 # model using OLS (Ordinary Least Squares).
 # The first argument of the .fit() method are the values of the independent variables -in our case
 # trainingData.loc[:,['Income','FamilySize']] - and the second
 # argument are the values of the dependent variable, here trainingData.loc[:,['FoodExpenditure']].
 estimatedModel = lm.fit(trainingData.loc[:,['temp','wind','rain']], trainingData.loc[:,['area']])

 # Coefficients have been estimated. Take a look at them. Not that it is important but heck, why not.
 # NOTE: the coefficients are returned (.coef_) as an array. The two numbers you'll see when
 # printing .coef_  must be interpreted as follows: first number is the coefficient
 # for Income, second number the coefficient for FamilySize. The estimated constant term b0 can retrieved 
 # via the .intercept_ variable.
 print(">>>Iteration ", testNumber, sep='')
 print("\tEstimated coefficients:")
 print("\t\tb1=", estimatedModel.coef_[0][0] , sep='')
 print("\t\tb2=", estimatedModel.coef_[0][1] , sep='') 
 print("\t\tb0=", estimatedModel.intercept_, sep='')
    
 predictedExpenditure = estimatedModel.predict(testData.loc[:,['temp','wind','rain']])

 # Calculate the Root Mean Squared Error (RMSE) for this testing set.
 # We have the real values of the dependent variable from the original dataset
 # which is testData.loc[:,['FoodExpenditure']] and the model's predicted values in predictedExpenditure
 # IMPORTANT: Please note the following: the function mean_squared_error() calculate the MSE NOT the RMSE. In
 # order to get the RMSE, we need to square the value returned by mean_squared_error(). See your notes on
 # how MSE and RMSE differ.
 RMSE = sqrt(mean_squared_error(testData.loc[:,['area']], predictedExpenditure))

 # Display the RMSE value
 print("\t\tModel RMSE=", RMSE, sep='')
 
 # Also, store the calculated RMSE value into an array, so that we can calculate the mean error after k-fold cross
 # validation has been finished 
 allRMSE = np.append(allRMSE, RMSE)

testNumber = 0



print("\n=======================================================")
print(" Final result: Mean RMSE of tests:", statistics.mean(allRMSE), sep='' )
print("=======================================================")

#filtering for area < 3.2
hhData_2 = hhData.loc[hhData['area'] < 3.2]

for train_index, test_index in kf.split(hhData_2):

 # Next test
 testNumber += 1
 
 # Use the current indexes train_index and test_index to get the actual observations for the
 # training and testing of the model respectively.

 # From the original, complete dataset get the data with which we will use TRAIN our model (aka the training set),
 # i.e. estimate the coefficients. We get the rows designated by train_index and all their columns/variables
 trainingData = hhData.iloc[train_index,:]

 # From the original, complete dataset get the data with which we will TEST our model, i.e. estimate its
 # accuracy. This is the "unknown" dataset.
 # Note: we do know the value of the dependent variable FoodExpenditure for the testing set
 # and hence we will be able to estimate the prediction error/accuracy
 testData = hhData.iloc[test_index,:]

 # Use the training data to estimate the coefficients of the multiple linear regression model.
 # The model we will estimate is: FoodExpenditure = b1Income + b2FamilySize + b0
 lm = LinearRegression(normalize=False, fit_intercept=True)

 # Since the linear regression model has as independent variables Income and FamilySize,
 # we get these variables from the training dataset.
 # The method .fit() does the actual estimation of the coefficients for the linear regression
 # model using OLS (Ordinary Least Squares).
 # The first argument of the .fit() method are the values of the independent variables -in our case
 # trainingData.loc[:,['Income','FamilySize']] - and the second
 # argument are the values of the dependent variable, here trainingData.loc[:,['FoodExpenditure']].
 estimatedModel = lm.fit(trainingData.loc[:,['temp','wind','rain']], trainingData.loc[:,['area']])

 # Coefficients have been estimated. Take a look at them. Not that it is important but heck, why not.
 # NOTE: the coefficients are returned (.coef_) as an array. The two numbers you'll see when
 # printing .coef_  must be interpreted as follows: first number is the coefficient
 # for Income, second number the coefficient for FamilySize. The estimated constant term b0 can retrieved 
 # via the .intercept_ variable.
 print(">>>Iteration ", testNumber, sep='')
 print("\tEstimated coefficients:")
 print("\t\tb1=", estimatedModel.coef_[0][0] , sep='')
 print("\t\tb2=", estimatedModel.coef_[0][1] , sep='') 
 print("\t\tb0=", estimatedModel.intercept_, sep='')
    
 predictedExpenditure = estimatedModel.predict(testData.loc[:,['temp','wind','rain']])

 # Calculate the Root Mean Squared Error (RMSE) for this testing set.
 # We have the real values of the dependent variable from the original dataset
 # which is testData.loc[:,['FoodExpenditure']] and the model's predicted values in predictedExpenditure
 # IMPORTANT: Please note the following: the function mean_squared_error() calculate the MSE NOT the RMSE. In
 # order to get the RMSE, we need to square the value returned by mean_squared_error(). See your notes on
 # how MSE and RMSE differ.
 RMSE = sqrt(mean_squared_error(testData.loc[:,['area']], predictedExpenditure))

 # Display the RMSE value
 print("\t\tModel RMSE=", RMSE, sep='')
 
 # Also, store the calculated RMSE value into an array, so that we can calculate the mean error after k-fold cross
 # validation has been finished 
 allRMSE = np.append(allRMSE, RMSE)


print("\n=======================================================")
print(" Final result: Mean RMSE of tests:", statistics.mean(allRMSE), sep='' )
print("=======================================================")

