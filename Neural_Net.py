import numpy as np
import pandas as pd
import torch
import torch.nn as nn
from NeuralNetworkClass import *

class NNMaster(object):

   def __init__(self):
      """
      Init Function to create a new NNMaster object
      Args: NA
      Returns: NA
      """
      #self.NN = Neural_Network()
      y_vals = pd.read_csv('training_data_y.csv')
      x_vals_original = pd.read_csv('training_data_x.csv')
      x_vals_original.columns = ['R1', 'G1', 'B1', 'W1', 'R2', 'G2', 'B2', 'W2', 'R3', 'G3', 'B3', 'W3']
      total_x_train = self.getNewDF_X(x_vals_original)
      total_y_train = self.getNewDF_Y(y_vals) 
      #training data is numpy arrays here
      x_arr = np.asarray(total_x_train,dtype=np.float32)
      y_train = np.asarray(total_y_train,dtype=np.float32)
      #convert training data to tensors and scale it
      x_train = torch.tensor((x_arr), dtype=torch.float)
      self.x_train = self.scaleInputTestData(x_train)
      self.y_train = torch.tensor((y_train), dtype=torch.float) / 100

   def getNewDF_X(self, originalDF):
      """
      Function to get a training data set that is 20x bigger than original for the x training data.
      Takes each RGB value and adds between -10 and 10 units to them, maintaining
      the original weights.
      Args: 
        originalDF : Pandas dataframe that indicates original small training datset
      Returns: 
        returnVal : New Pandas dataframe with 20x more data
      """
       new_temps = [x for x in range(-10, 10, 1)]
       for unit in range(-10, 10, 1):
           new_temps[unit] = originalDF[['R1', 'G1', 'B1', 'R2', 'G2', 'B2', 'R3', 'G3', 'B3']].iloc[:] + unit
           new_temps[unit]['W1'] = originalDF['W1']
           new_temps[unit]['W2'] = originalDF['W2']
           new_temps[unit]['W3'] = originalDF['W3']
       returnVal = pd.concat(new_temps)
       return returnVal

   def getNewDF_Y(self, originalDF):
    """
      Function to get a training data set that is 20x bigger than original for the y training data.
      This simply takes in the y training data and creates the same list 20x so that the
      new RGB values from the expanded x training data matches with the original schemes.
      Args: 
        originalDF : Pandas dataframe that indicates original small training datset
      Returns: 
        returnVal : New Pandas dataframe with 20x more data
      """
       new_temps = [x for x in range(-10, 10, 1)]
       for unit in range(-10, 10, 1):
           new_temps[unit] = originalDF
       returnVal = pd.concat(new_temps)
       return returnVal

   def initialTraining(self, x_training, y_training):
    """
      Sets the x and y values for the NeuralNetMaster object to be the x and y
      total training data sets in tensor format.
      Args: 
        x_training: numpy nd array for x training data
        y_training: numpy nd array for y training data
      Returns: NA
      """
      self.X = torch.tensor((x_training), dtype=torch.float)
      self.y = torch.tensor((y_training), dtype=torch.float)

   def trainData(self, X, y, NeuralNet, epochs):
        """
        Trains the nerual net with the specified number of epochs.
        Saves the neural net weights by calling the saveWeights function.
      Args: 
        X: tensor indicating x training data
        y: tensor indicating y training data
        NeuralNet: NN object
        epochs: number of epochs for training
      Returns: NA
      """
      for i in range(epochs):
         NeuralNet.train(X, y)
      NeuralNet.saveWeights(NeuralNet)

   def scaleInputTestData(self, inputTestData):
      """
      Scales the input data to have values between -1 and 1. Divides all
      values by the maximum value in the tensor.
      Args: 
        inputTestData : numpy nd array or tensor object for x training data
      Returns: scaled tensor of the x training data, ready for input on neural net.
      """
       inputTensor = torch.tensor((inputTestData), dtype=torch.float)
       input_max, _ = torch.max(inputTensor, 0)
       return torch.div(inputTensor, input_max)

   def getPredictionArray(self, inputTestData, NeuralNet):
      """
      Calls the prediction function in the NeuralNet class.
      Args: 
        inputTestData: the input RGB and weight values for the prediction. These
        will come from the kmeans run on the user's uploaded image.
        NeuralNet: The NN object with the save weights from training.
      Returns: 
        predictedValues: array of 3 HSB values, length 9 [H1,S1,B1, H2,S2,B2, H3,S3,B3]
      """
       scaledTestData = self.scaleInputTestData(inputTestData)
       predictedValues = (NeuralNet.predict(scaledTestData) * 100).data.numpy()
       return predictedValues

def neuralRun(testData):
    Master = NNMaster()

    # this is what you call to train neural net
    Master.trainData(Master.x_train, Master.y_train, Master.NN, 100)
    # this is an example of passing in some sort of test data
    #testData = [176, 190, 181, 0.616237231, 92, 93, 79, 0.073493527, 217, 225, 224, 0.310269242]
    print('TEST', Master.getPredictionArray(testData, Master.NN))

def main():
   #create neural net master and neural net
   Master = NNMaster()
   NN = Neural_Network()
   #this is what you call to train neural net
   Master.trainData(Master.x_train, Master.y_train, NN, 100)
   #this is an example of passing in some sort of test data
   testData = [176,190,181,0.616237231,92,93,79,0.073493527,217,225,224,0.310269242]
   print('TEST', Master.getPredictionArray(testData, NN))


if __name__ == "__main__":
    main()

