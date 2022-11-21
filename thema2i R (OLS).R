#useful libraries
library(RCurl)
library(dplyr)

## get column names
# specify the URL for the column names and descriptions
names.file.url <- 'https://archive.ics.uci.edu/ml/machine-learning-databases/communities/communities.names'
names.file.lines <- readLines(names.file.url)
# only keep the attribute names, and discard the rest of the lines
names.dirtylines <- grep("@attribute ", names.file.lines, value = TRUE)
# split on spaces and pick the second word
names <- sapply(strsplit(names.dirtylines, " "), "[[", 2)
# drop the first 5 columns
names <- names[6:length(names)]
## download data and join in names
# specify the URL for the Crime and Communities data CSV
urlfile <-'https://archive.ics.uci.edu/ml/machine-learning-databases/communities/communities.data'
# download the file
downloaded <- getURL(urlfile, ssl.verifypeer=FALSE)
# treat the text data as a steam so we can read from it
connection <- textConnection(downloaded)
# parse the downloaded data as CSV
dataset <- read.csv(connection, header=FALSE, na.strings=c("?"))
# drop irrelevant columns
dataset <- dataset[ ,6:ncol(dataset)]
# drop rows with null columns
dataset <- dataset[rowSums(is.na(dataset)) == 0,]
# fix the column names
colnames(dataset) <- names
# preview the first 5 rows
head(dataset)

#OLS
linear.regression.model <-  linear.regression.model<-lm(ViolentCrimesPerPop ~ medIncome + whitePerCap + blackPerCap + HispPerCap + NumUnderPov + PctUnemployed + HousVacant + MedRent + NumStreet, data=dataset)


#Show/print estimated coefficients only
print( linear.regression.model$coefficients )

# Show/print all results of the linear regression like R-Squared, p-values, F-statistic etc
summary(linear.regression.model)

