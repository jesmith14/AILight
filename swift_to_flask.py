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

    # TESTING BACK PROPOGATION 

        inputList = [176, 190, 181, 0.6162372307, 92, 93, 79, 0.0734935274411679, 217, 225, 224, 0.310269241904131]
        outputList = [211, 2, 97, 204, 3, 100, 204, 12, 99]

        userList = [56, 54, 100, 204, 3, 100, 204, 12, 99]

        callBackProp(inputList, outputList, userList)
        backPropValues = Master.getPredictionArray(inputList,NN)
        print("BACK PROP VALS: " + str(backPropValues))

        return jsonify(values=returnVals)
    return jsonify(error='Request Failed')

@app.route('/backPropInit',methods=['POST'])
def backPropInit():

    NN = torch.load("NN")

    data = request.data
    inputList = data[0]
    outputList = data[1]
    userList = data[2]
    callBackProp(inputList, outputList, userList, NN)

    return jsonify(resp= "Backpropogation Neural Net Started Success")


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

    NeuralNet.backward(X, y, o)

    NeuralNet.saveWeights(NeuralNet)

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
