# Συνάρτηση που υπολογίζει και επιστρέφει το Μέσο Τετραγωνικό Σφάλμα (Root Mean Squared Error - RMSE)
# Επιστρέφει το Μέσο Τετραγωνικό Σφάλμα πρόβλεψης
calculateRMSE<-function(predictedValues, actualValues){
  err<- sqrt( mean((actualValues - predictedValues)^2)  )
  return( err )
}

kFoldCrossValidation<-function(data, frml, k){
  #τυχαια αναδιαταξη 
  dataset<-data[sample(nrow(data)),]
  #διαχωρισμοσ Κ κομματιων
  folds <- cut(seq(1,nrow(dataset)), breaks=k, labels=FALSE)
  #διανυσμα που αποθηκευει το rmse
  RMSE<-vector()
 
  
  # Επαναλαηπτική διαδικασία όπου κάθε ένα από τα k τμήματα θα 
  #χρησιμοποιηθεί διαδοχικά ως σύνολο ελέγχου για το μοντέλο παλινδρόμησης 
  #και όλα τα υπόλοιπα ως σύνολο εκπαίδευσης.
  # Η διαδικασία θα τερματίσει εάν όλα τα τμήματα έχουν χρησιμοποιηθεί ως σύνολο σλέγχου.
  for(i in 1:k){
    # Καθορισμός του τμήματος ελέγχου για την τρέχουσα επανάληψη 
    testIndexes <- which(folds==i,arr.ind=TRUE)
    # Καθορισμός συνόλου ελέγχου μοντέλου
    testData <- dataset[testIndexes, ]
    # Καθορισμός συνόλου εκπαίδευσης μοντέλου, που θα είναι όλα τα υπόλοιπα
    # πλην των δεδομένων που χρησιμοποιηθούν για έλεγχο
    trainData <- dataset[-testIndexes, ]
    # Εκτίμηση συντελεστών του μοντέλου παλινδρόμησης χρησιμοποιώντας το σύνολο εκπαίδευσης
    candidate.linear.model<-lm( frml, data = trainData)
    # Υπολογισμός των τιμών της εξαρτημένης μεταβλητής που προβλέπει το μοντέλο 
    # για τις τιμές του τρέχοντος συνόλου ελέγχου 
    predicted<-predict(candidate.linear.model, testData)
    # Υπολογισμός σφάλματος RMSE
    error<-calculateRMSE(predicted, testData[, "area"])
    # Αποθήκευση τιμής σφάλματος
    RMSE<-c(RMSE, error)
  }
  # Επιστροφή μέσης τιμής των σφαλμάτων που προέκυψαν απ'όλα τα τμήμα-τα ελέγχου
  return( mean(RMSE) )
}

# Ανάγνωση δεδομένων
setwd("C:/Users/user/Documents/2η μεγαλα δεδομενα/2hErgasia-2022-2023")
fires<-read.csv("forestfires.csv", sep=";", header=T)
#Έλεγχος για δεδομένα που λείπουν (missing values) και αφαίρεση ολόκληρης γραμμής
# σε περίπτωση που μια τουλάχιστον μεταβλητή έχει missing value
fires<-na.omit(fires)


# Τα τέσσερα υποψήφια μοντέλα των οποίων θα αξιολογηθεί η ικανότητα πρόβλεψης της κατανάλωσης καυσίμου
# (mpg - miles per gallon) με τη μέθοδο της διασταυρωτικής επικύρωσης 10-φορές. 
# Τα μοντέλα παλινδρόμησης αποθηκεύονται στο διάνυσμα ως συμβολοσειρές και θα μετατραπούν
# σε τύπους (formula) της R
predictionModels<-vector()
predictionModels[1]<-"area ~ temp+wind+rain"


# Μετά από κάθε διασταυρωμένη επικύρωση, ο μέσος όρος του μέσου τετρα-γωνικού 
# σφάλματος κάθε μοντέλου θα αποθηκευτεί σε διάνυσμα.
modelMeanRMSE<-vector()

# Διασταυρωμένη επικύρωση 10-φορές για κάθε ένα από τα 
# τέσσερα υποψήφια μοντέλα.
for (k in 1:length(predictionModels)){
  # Δισταυρωμένη επικύρωση 10-πτυχών για το γραμμικό μοντέλο παλιν-δρόμησης k
  modelErr<-kFoldCrossValidation(fires, as.formula(predictionModels[k]), 10)
  
  # Αποθήκευση του μέσου σφάλματος
  modelMeanRMSE<-c(modelMeanRMSE, modelErr)
  print( sprintf("Linear regression model [%s]: prediction error [%f]", predictionModels[k], modelErr ) )
}

linear.regression.model<-lm(area ~temp+wind+rain, data=fires)
print(linear.regression.model$coefficients)
summary(linear.regression.model)

####################################################################################
#ομοιως με την πανω διαδικασια αλλα τωρα για 3_2
setwd("C:/Users/user/Documents/2η μεγαλα δεδομενα/2hErgasia-2022-2023")
fires<-read.csv("forestfires.csv", sep=";", header=T)
#Έλεγχος για δεδομένα που λείπουν (missing values) και αφαίρεση ολόκληρης γραμμής
# σε περίπτωση που μια τουλάχιστον μεταβλητή έχει missing value
fires<-na.omit(fires)
fires_3_2<-subset(fires, fires$area<3.2)
linear.regression.model<-lm(area ~temp+wind+rain, data=fires_3_2)
print(linear.regression.model$coefficients)
summary(linear.regression.model)
# Επιστρέφει το Μέσο Τετραγωνικό Σφάλμα πρόβλεψης
calculateRMSE<-function(predictedValues, actualValues){
  err<- sqrt( mean((actualValues - predictedValues)^2)  )
  return( err )
}

# Συνάρτηση που υλοποιεί τον αλγόριθμο της διασταρωμένης επικύρωσης k-πτυχών.
kFoldCrossValidation<-function(data, frml, k){
  # Τυχαία αναδιάταξη 
  dataset<-data[sample(nrow(data)),]
  #Δημιουργία k
  folds <- cut(seq(1,nrow(dataset)), breaks=k, labels=FALSE)
  # Διάνυσμα όπου αποθηκεύεται το Μέσο Τετραγωικο σφαλμα
  RMSE<-vector()
  }
  
#ομοιως με τον παραπανω ελεγχο for
for(i in 1:k){
  # Καθορισμός του τμήματος ελέγχου για την τρέχουσα επανάληψη 
  testIndexes <- which(folds==i,arr.ind=TRUE)
  # Καθορισμός συνόλου ελέγχου μοντέλου
  testData <- dataset[testIndexes, ]
  # Καθορισμός συνόλου εκπαίδευσης μοντέλου, που θα είναι όλα τα υπόλοιπα
  # πλην των δεδομένων που χρησιμοποιηθούν για έλεγχο
  trainData <- dataset[-testIndexes, ]
  # Εκτίμηση συντελεστών του μοντέλου παλινδρόμησης χρησιμοποιώντας το σύνολο εκπαίδευσης
  candidate.linear.model<-lm( frml, data = trainData)
  # Υπολογισμός των τιμών της εξαρτημένης μεταβλητής που προβλέπει το μοντέλο 
  # για τις τιμές του τρέχοντος συνόλου ελέγχου 
  predicted<-predict(candidate.linear.model, testData)
  # Υπολογισμός σφάλματος RMSE
  error<-calculateRMSE(predicted, testData[, "area"])
  # Αποθήκευση τιμής σφάλματος
  RMSE<-c(RMSE, error)
}
# Επιστροφή μέσης τιμής των σφαλμάτων που προέκυψαν απ'όλα τα τμήμα-τα ελέγχου
return( mean(RMSE) )
}

predictionModels<-vector()
predictionModels[1]<-"area~temp+wind+rain"

#RMSE in a vector
modelMeanRMSE<-vector()

#10 fold cross val. for each potential model
for (k in 1:length(predictionModels)){
  modelErr<-kFoldCrossValidation(fires_3_2, as.formula(predictionModels[k]), 10)
  
  # Αποθήκευση του μέσου σφάλματος
  modelMeanRMSE<-c(modelMeanRMSE, modelErr)
  print( sprintf("Linear regression model [%s]: prediction error [%f]", predictionModels[k], modelErr ) )
}




  