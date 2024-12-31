import tensorflow as tf
from tensorflow.keras.models import load_model
from PIL import Image
import numpy as np
import os
import json
from flask import Flask, request, jsonify

app = Flask(__name__)
model = load_model('./saved_model/crop_disease_model.h5')

def preprocess_image(image_path):
    image = Image.open(image_path).resize((128, 128))
    image = np.array(image) / 255.0
    return np.expand_dims(image, axis=0)

@app.route('/analyze', methods=['POST'])
def analyze_image():
    if 'image' not in request.files:
        return jsonify({'error': 'No file uploaded'}), 400

    file = request.files['image']
    file_path = os.path.join('./uploads', file.filename)
    file.save(file_path)

    processed_image = preprocess_image(file_path)
    predictions = model.predict(processed_image)
    
    result = {
        "crop": "Corn",
        "disease": "Blight",
        "confidence": str(predictions[0][0]),
        "suggestions": "Apply proper fungicides."
    }
    os.remove(file_path)
    return jsonify(result)

if __name__ == '__main__':
    app.run(debug=True, port=5000)
