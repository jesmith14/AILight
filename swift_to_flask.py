from flask import Flask
from flask import jsonify
from flask import request
from kmeans import *
from Neural_Net import *
import os
app = Flask(__name__)
#Master = None
@app.route('/startNeuralNet',methods=['POST'])
def StartNeuralNet():
    neuralNetFile = "NN"
    Master = NNMaster()
    if(os.path.isfile(neuralNetFile) == False):
        NN = Neural_Network()
        Master.trainData(Master.x_train, Master.y_train, NN, 100)
    return jsonify(resp= "Neural Net Started Success")
@app.route('/imageUpload',methods=['POST'])
def ImageUpload():
    data = request.data
    neuralNetFile = "NN"
    Master = NNMaster()
    if (os.path.isfile(neuralNetFile) == False):
        NN = Neural_Network()
        Master.trainData(Master.x_train, Master.y_train, NN, 100)
    else:
        NN = torch.load(neuralNetFile)
    filename = 'uploadedImage.jpg'
    with open(filename,'wb') as f:
        f.write(data)
        f.close()
        #time.sleep()
        color1=[]
        color2=[]
        color3=[]
        weights = mainRun()
        rbgArray = getArray(weights)
        color1.append(weights[0][1][0])
        color1.append(weights[0][1][1])
        color1.append(weights[0][1][2])
        color2.append(weights[1][1][0])
        color2.append(weights[1][1][1])
        color2.append(weights[1][1][2])
        color3.append(weights[2][1][0])
        color3.append(weights[2][1][1])
        color3.append(weights[2][1][2])
        finalValues = Master.getPredictionArray(rbgArray,NN)
        returnVals = []
        for value in finalValues:
            returnVals.append(int(value))
        print('RETURNED VALUES FOR HSB', returnVals)
        #finalValues = neuralRun(rbgArray)
        #return jsonify(color1=color1,color2=color2,color3=color3)
        return jsonify(values=returnVals)
    return jsonify(error='Request Failed')
def getArray(weights):
    array = []
    for item in weights:
        #[(0, (47, 42, 23)), (0, (171, 172, 176)), (0, (106, 103, 101))]
        #[176,190,181,0.616237231,92,93,79,0.073493527,217,225,224,0.310269242]
        array.extend(list(item[1]))
        array.append(item[0])
    #print("Formatted list for Neural Net: " + str(array));
    return array
if __name__ == '__main__':
    app.debug = True
    app.run(host = '0.0.0.0', port = 5000)
