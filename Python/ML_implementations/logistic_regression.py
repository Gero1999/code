import numpy as np
from math import exp

# Sigmoid function
def sigmoid(z):
    return 1 / (1 + np.exp(-z))

# Cost function (Cross-Entropy Loss)
def compute_cost(theta, X, y):
    m = len(y)
    h = sigmoid(X @ theta)
    cost = (-1 / m) * (y.T @ np.log(h) + (1 - y).T @ np.log(1 - h))
    return cost

# Gradient Descent for Logistic Regression
def gradient_descent(theta, X, y, alpha, num_iters):
    m = len(y)
    cost_history = []

    for _ in range(num_iters):
        h = sigmoid(X @ theta)
        gradient = (X.T @ (h - y)) / m
        theta -= alpha * gradient
        cost = compute_cost(theta, X, y)
        cost_history.append(cost)
    
    return theta, cost_history


## Practical example
# Sample data
X = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
Y = np.array([[0, 1, 1]])

# Initialize parameters
parameters = initialize_parameters([3, 2, 1])

# Forward propagation
AL, caches = forward_propagation(X, parameters)

# Compute cost
cost = compute_cost(AL, Y)

# Backward propagation
grads = backward_propagation(AL, Y, caches)

# Update parameters
learning_rate = 0.01
parameters = update_parameters(parameters, grads, learning_rate)
