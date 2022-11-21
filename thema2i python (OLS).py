#read packages

import numpy as np
from sklearn.linear_model import LinearRegression

import pandas as pd
import matplotlib.pyplot as plt

#read files

attrib = pd.read_csv('attributes.csv', delim_whitespace = True)

data = pd.read_csv('communities.data', names = attrib['attributes'])

print(data.shape)

data.head()

#Remove non-predictive features

data = data.drop(columns=['state','county',
                          'community','communityname',
                          'fold'], axis=1)

print(data.shape)
data.head()

#remove missing values etc

from pandas import DataFrame

data = data.replace('?', np.nan)
feat_miss = data.columns[data.isnull().any()]
print(feat_miss)
feat_miss.shape

# Look at the features with missing values

data[feat_miss[0:13]].describe()
data[feat_miss[13:23]].describe()

#OtherPerCap has only one missing value and will be filled by a mean
#value using Imputer from sklearn.preprocessing.
#The others features present many missing values and will be removed
#from the data set.
## Impute mean values for samples with missing values

from sklearn.impute import SimpleImputer

imputer = SimpleImputer(missing_values=np.nan, strategy = 'mean')

imputer = imputer.fit(data[['OtherPerCap']])
data[['OtherPerCap']] = imputer.transform(data[['OtherPerCap']])

data = data.dropna(axis=1)
print(data.shape)
data.head()

data.describe()

data.hist(column = ['ViolentCrimesPerPop'], bins = 30, color = 'blue', alpha = 0.8)
plt.show()

