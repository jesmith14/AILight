import numpy as np
import pandas as pd
import torch
import torch.nn as nn

class Neural_Network(nn.Module):
    def __init__(self, ):
        super(Neural_Network, self).__init__()
        """
        Initialization of the NeuralNet. Calls the super class from the nn.Module
        of PyTorch library. We define the neural net to take in 12 input values and 
        return 9 values. The hidden layer has 3 nodes.
        Args: NA
        Returns: NA
        """
        self.inputSize = 12
        self.outputSize = 9
        self.hiddenSize = 3
        
        # weights
        self.W1 = torch.randn(self.inputSize, self.hiddenSize) # 3 X 2 tensor
        self.W2 = torch.randn(self.hiddenSize, self.outputSize) # 3 X 1 tensor
        
    def forward(self, X):
        """
        Forward function for forward propogation of the neural net. Used for
        training and for predictions.
        Args:
            X : the input values, a tensor of size 12 (for training the tensor size should be [300, 12])
        Returns: 
            o : the predicted values tensor. These indicate the three HSB values, divided by 100. Times by 100 to rescale.
        """
        self.z = torch.matmul(X, self.W1) # 3 X 3 ".dot" does not broadcast in PyTorch
        self.z2 = self.sigmoid(self.z) # activation function
        self.z3 = torch.matmul(self.z2, self.W2)
        o = self.sigmoid(self.z3) # final activation function
        return o
        
    def sigmoid(self, s):
        """
        Helper function for activation function
        Args:
            s : input  value for the node in the next layer, used for activation function.
        Returns: 
            sigmoid of the input for the activation units.
        """
        return 1 / (1 + torch.exp(-s))
    
    def sigmoidPrime(self, s):
        """
        Helper function for back propagation
        Args:
            s : input  value for the node in the previous layer, used for back prop.
        Returns: 
            derivative of sigmoid of the input for changing the weight connection values.
        """
        # derivative of sigmoid
        return s * (1 - s)
    
    def backward(self, X, y, o):
        # y represents the expected values, X represents the input values, o represents the predicted values
        # when we do user backprop, we will pass in the X from the user's kmeans, the o from the predicted hsb values,
        # and the y is the o with any modifications from the user's preferences
        """
        Function for back propagation. Used in training and when the user specifies
        their own lighting preferences to retrain the neural net object and modify
        the weights to match the user's preferences. Calculates the error based on either
        the expected values for training or user preferred values for post back prop.
        Args:
            X : The training x data or testing x data, tensor of size 12 (must be 2D)
            y : training y data (expected values or user specified values) in tensor
            o : original predicted output from the neural net.
        Returns: 
            NA
        """
        self.o_error = y - o # error in output
        self.o_delta = self.o_error * self.sigmoidPrime(o) # derivative of sig to error
        self.z2_error = torch.matmul(self.o_delta, torch.t(self.W2))
        self.z2_delta = self.z2_error * self.sigmoidPrime(self.z2)
        self.W1 += torch.matmul(torch.t(X), self.z2_delta)
        self.W2 += torch.matmul(torch.t(self.z2), self.o_delta)
        
    def train(self, X, y):
        """
        Function for training. Calls forward and backward on training data until epochs are done.
        Modifies the weights of the NN accordingly.
        Args:
            X : The training x data or testing x data, tensor of size 12 (must be 2D)
            y : training y data (expected values or user specified values) in tensor
        Returns: NA
        """
        o = self.forward(X)
        self.backward(X, y, o)
        
    def saveWeights(self, model):
        """
        Saves the neural net in a file called 'NN'.
        This saves all of the trained connection weights.
        Args:
            model : the neural net model
        Returns: NA
        """
        torch.save(model, "NN")
        
    def predict(self, predictValue):
        """
        Prediction function. Returns the HSB values for the predicted lighting
        suggestions for the user.
        Args:
            predictValue : the RGB and weight values from kmeans clustering, tensor of 12
        Returns: 
            predicted: the tensor of 9 indicating the HSB value suggestions.
        """
        predicted = self.forward(predictValue)
        return predicted

        