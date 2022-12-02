import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


# Multiply two matrices i.e. mat1 * mat2

def matmultiply(mat1,mat2):
    return( np.matmul(mat1, mat2) )
    

# Calculate current value of cost function J(θ).
# indV: matrix of independent variables, first column must be all 1s
# depV: matrix (dimensions nx1)of dependent variable i.e.
def calculateCost(indV, depV, thetas):
    return( np.sum( ((matmultiply(indV, thetas) - depV)**2) / (2*indV.shape[0]) ) )  
    
# Batch gradient descent
# indV:matrix of independent variables, first column must be all 1s
# depV: matrix (dimensions nx1)of dependent variable i.e.
# alpha: value of learning hyperparameter. Default (i.e. if no argument provided)  0.01
# numIters: number of iterations. Default (i.e. if no argument provided) 100
def batchGradientDescent(indV, depV, thetas, alpha = 0.01, numIters = 100, verbose = False):
     calcThetas = thetas
     # we store here the calculated values of J(θ)
     costHistory = pd.DataFrame( columns=["iter", "cost"])
     for i in range(0, numIters):
       # TODO: add here the Θ-update formula.
       #       you may find the matrix form of the θ-update formula
       #       on slide 60 in the course notes Lecture3-Regression.pdf.
       #       Add this update here!
       x=indV
       y=depV
       theta = theta - alpha * (np.dot(x.transpose(), (np.dot(x, theta) - y)) / m)
       print(">>>> Iteration", i, ")")
       print("Calculate thetas...")
       calculate=calculateCost(x,y,thetas)
       print("Calculate cost fuction for new thetas...")
       # After the θ-update, calculate cost calling function calculateCost and
       # store value into costHistory
       # NOTE: .append() is not in-place!
       costHistory = costHistory.append({"iter": i, "cost":1000}, ignore_index=True )
    
     # Done. Return values     
     return calcThetas, costHistory  

# Read the data
communities = pd.read_csv("communities.data", header=None, sep=",", engine='python')

#That's our dependent variable
dependentVar = communities.iloc[:, 127]
communities = communities.iloc[:, [17,26,27,31,32,37,76,90,95] ]

# Check to see if missing values are present.
# NOTE: ? signify missing values
communities = communities[(communities != '?').all(1)]

# Add new column at the beginning representing the constant term b0
communities.insert(0, 'b0', 1)

# Add to a new variable to make the role of the data clearer
independentVars = communities


# Initialize thetas with some random values.
# We'll need (independentVars.shape[1])  theta values, one for each independent variable.
# NOTE: First theta value is coefficient for variable in FIRST column in independent matrix independentVars, second theta variable is coefficient
#       for second column in independent matrix independentVars etc
iniThetas = []
for i in range(0, independentVars.shape[1]):
    iniThetas.append( np.random.rand() )

initialThetas = np.array(iniThetas)

# Everything is ok.
# Run BATCH gradient descent and return 2 values: I) the vector of the estimated coefficients (estimatedCoefficients) and II) the values of the
# cost function (costHistory)
estimatedCoefficients, costHistory = batchGradientDescent(independentVars.to_numpy(), dependentVar.to_numpy(), initialThetas, 0.001, 12)

# Display now the cost function to see if alpha and number of iterations were appropriate.
costHistory.plot.scatter(x="iter", y="cost", color='red')
plt.show()
