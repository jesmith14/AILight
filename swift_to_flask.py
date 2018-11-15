from flask import Flask
from flask import jsonify
from flask import request
import base64
app = Flask(__name__)

@app.route('/imageUpload',methods=['POST'])
def ImageUpload():
    data = request.data
    filename = 'uploadedImage.jpg'
    with open(filename,'wb') as f:
        f.write(data)
        return 'success'
    return 'fail'
'''
    if file:
        return(ImageReceived(file))
    return "Fail"

@app.route('/imageReceived',methods=['GET'])
def ImageReceived(file):
    if(file):
        print("FILE TYPE: " + str(type(8file)))
        return "FILE TYPE: " + str(type(file))
    return "Failed"
'''
if __name__ == '__main__':
    app.debug = True
    app.run(host = '0.0.0.0', port = 5000)
