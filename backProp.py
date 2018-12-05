import numpy as np
import pandas as pd
import torch
import torch.nn as nn
from NeuralNetworkClass import *
from flask import Flask
from flask import jsonify
from flask import request
from kmeans import *
import os

def callBackProp(inputList, outputList, userList, NeuralNet):

	#inputList = (r1, g1, b1, w1, r2, g2, b2, w2, r3, g, b3, w3) -- input colors from k-means
	#ouputList = (h1, s1, b1, h2, s2, b2, h3, s3, b3) -- list of colors that program selects

	#userList = (h1, s1, b1, h2, s2, b2, h3, s3, b3) -- list of colors that user chooses

	# INPUTS - X

	r1 = inputList[0]
	g1 = inputList[1]
	b1 = inputList[2]
	w1 = inputList[3]

	r2 = inputList[4]
	g2 = inputList[5]
	b2 = inputList[6]
	w2 = inputList[7]

	r3 = inputList[8]
	g3 = inputList[9]
	b3 = inputList[10]
	w3 = inputList[11]

	# OUTPUTS - y

	h1 = outputList[0]
	s1 = outputList[1]
	b1 = outputList[2]

	h2 = outputList[3]
	s2 = outputList[4]
	b2 = outputList[5]

	h3 = outputList[6]
	s3 = outputList[7]
	b3 = outputList[8]

	# CORRECT VALUES CHOSEN BY USER

	uh1 = userList[0]
	us1 = userList[1]
	ub1 = userList[2]

	uh2 = userList[3]
	us2 = userList[4]
	ub2 = userList[5]

	uh3 = userList[6]
	us3 = userList[7]
	ub3 = userList[8]


	X = torch.tensor(([r1], [g1], [b1], [w1], [r2], [g2], [b2], [w2], [r3], [g3], [b3], [w3]), dtype=torch.float)
	y = torch.tensor(([h1], [s1], [b1], [h2], [s2], [b2], [h3], [s3], [b3]), dtype=torch.float)

	o = torch.tensor(([uh1], [us1], [ub1], [uh2], [us2], [ub2], [uh3], [us3], [ub3]), dtype=torch.float)

	NeuralNet..backward(X, y, o)

	NeuralNet.saveWeights(model)


app = Flask(__name__)
@app.route('/backPropInit',methods=['POST'])
def backPropInit():
	data = request.data
	inputList = data[0]
	outputList = data[1]
	userList = data[2]
	callBackProp(inputList, outputList, userList, NeuralNet)



if __name__ == '__main__':
    app.debug = True
    app.run(host = '0.0.0.0', port = 5000)





	
