from flask import Flask
from flask import jsonify
from flask import request
from kmeans import *
import os
app = Flask(__name__)
@app.route('/imageUpload',methods=['POST'])
def ImageUpload():
    data = request.data
    filename = 'uploadedImage.jpg'
    with open(filename,'wb') as f:
        f.write(data)
        f.close()
        #time.sleep()
        color1=[]
        color2=[]
        color3=[]
        weights = mainRun()
        color1.append(weights[0][1][0])
        color1.append(weights[0][1][1])
        color1.append(weights[0][1][2])
        color2.append(weights[1][1][0])
        color2.append(weights[1][1][1])
        color2.append(weights[1][1][2])
        color3.append(weights[2][1][0])
        color3.append(weights[2][1][1])
        color3.append(weights[2][1][2])
        test = jsonify(color1=color1,color2=color2,color3=color3)
        return jsonify(color1=color1,color2=color2,color3=color3)
    return jsonify(error='Request Failed')

if __name__ == '__main__':
    app.debug = True
    app.run(host = '0.0.0.0', port = 5000)
