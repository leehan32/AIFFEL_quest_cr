from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
import numpy as np
from tensorflow.keras.applications import VGG16, ResNet50
from tensorflow.keras.applications.vgg16 import preprocess_input as vgg16_preprocess
from tensorflow.keras.applications.resnet50 import preprocess_input as resnet50_preprocess, decode_predictions
from tensorflow.keras.preprocessing.image import img_to_array
from PIL import Image
from io import BytesIO
import os
import h5py
from datetime import datetime

app = FastAPI()

# CORS 설정
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 모델 선택 및 로드
MODEL_TYPE = "vgg16"  # "vgg16" 또는 "resnet50" 선택
if MODEL_TYPE == "vgg16":
    model = VGG16(weights="imagenet")
    preprocess_input = vgg16_preprocess
elif MODEL_TYPE == "resnet50":
    model = ResNet50(weights="imagenet")
    preprocess_input = resnet50_preprocess
else:
    raise ValueError("Unsupported model type")

# 이미지 처리 함수
def prepare_image(image) -> np.ndarray:
    image = image.resize((224, 224))
    image_array = img_to_array(image)
    image_array = np.expand_dims(image_array, axis=0)
    return preprocess_input(image_array)

class JellyfishClassification:
    def __init__(self, model, h5_path="results/predictions.h5"):
        self.model = model
        self.h5_path = h5_path
        os.makedirs(os.path.dirname(h5_path), exist_ok=True)

        # Initialize H5 file
        if not os.path.exists(h5_path):
            with h5py.File(h5_path, "w") as f:
                f.create_dataset("predictions", shape=(0,), maxshape=(None,), dtype=h5py.special_dtype(vlen=str))

    async def predict_class(self, file: UploadFile) -> dict:
        file_data = await file.read()
        image = Image.open(BytesIO(file_data))
        processed_image = prepare_image(image)

        predictions = self.model.predict(processed_image)
        decoded_predictions = decode_predictions(predictions, top=1)[0]

        highest_class = decoded_predictions[0][1]
        self._save_to_h5(f"Class: {highest_class}")

        return {"class": highest_class}

    async def predict_confidence(self, file: UploadFile) -> dict:
        file_data = await file.read()
        image = Image.open(BytesIO(file_data))
        processed_image = prepare_image(image)

        predictions = self.model.predict(processed_image)
        decoded_predictions = decode_predictions(predictions, top=1)[0]

        highest_confidence = float(decoded_predictions[0][2])
        self._save_to_h5(f"Confidence: {highest_confidence:.2f}")

        return {"confidence": highest_confidence}

    def _save_to_h5(self, data: str):
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        entry = f"{timestamp} - {data}"

        with h5py.File(self.h5_path, "a") as f:
            dataset = f["predictions"]
            dataset.resize(dataset.shape[0] + 1, axis=0)
            dataset[-1] = entry

classifier = JellyfishClassification(model)

@app.get("/")
async def root():
    return f"Jellyfish Classifier with {MODEL_TYPE.upper()} Model"

@app.post("/predict_class/")
async def predict_class(file: UploadFile = File(...)):
    return await classifier.predict_class(file)

@app.post("/predict_confidence/")
async def predict_confidence(file: UploadFile = File(...)):
    return await classifier.predict_confidence(file)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="127.0.0.1", port=8000)
