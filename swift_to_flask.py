from flask import Flask
from flask import jsonify
from flask import request
from kmeans import *
app = Flask(__name__)

@app.route('/imageUpload',methods=['POST'])
def ImageUpload():
    data = request.data
    filename = 'uploadedImage.jpg'
    with open(filename,'wb') as f:
        f.write(data)
        mainRun()
        return 'success'
    return 'fail'

if __name__ == '__main__':
    app.debug = True
    app.run(host = '0.0.0.0', port = 5000)
