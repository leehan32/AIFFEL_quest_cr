from fastapi import FastAPI, UploadFile, File
from typing import Optional

app = FastAPI()

class JellyfishClassification:
    def __init__(self):
        self.model = None  # 모델 선언 부분
        
    def predict(self, image) -> dict:
        # 가장 높은 확률의 class를 출력하는 기능 구현
        return {"class": "predicted_class", "probability": 0.95}
    
    def check_prediction(self, image, class_name: str) -> bool:
        # 해당 클래스로 예측된 확률이 어느정도인지 출력하는 기능 구현
        return True

classifier = JellyfishClassification()

@app.post("/predict")
async def predict_jellyfish(file: UploadFile = File(...)):
    # 노선페이지를 참고하여 LMS에 jellyfish라는 폴더를 만듭니다
    image_bytes = await file.read()
    result = classifier.predict(image_bytes)
    return result

@app.post("/verify")
async def verify_class(file: UploadFile = File(...), class_name: str):
    # 제공된 이미지를 업로드합니다
    image_bytes = await file.read()
    result = classifier.check_prediction(image_bytes, class_name)
    return {"is_matching": result}
