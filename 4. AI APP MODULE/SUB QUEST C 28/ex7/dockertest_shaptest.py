import shap
import numpy as np
import json
import requests
import tensorflow as tf
import matplotlib.pyplot as plt

# CIFAR-10 데이터 로드
(X_train, y_train), (_, _) = tf.keras.datasets.cifar10.load_data()

# CIFAR-10 클래스 이름
cifar10_labels = [
    "airplane", "automobile", "bird", "cat", "deer",
    "dog", "frog", "horse", "ship", "truck"
]

# SHAP을 사용할 샘플 이미지 선택
image_index = 15  # 원하는 인덱스로 변경 가능
sample_image = X_train[image_index] / 255.0  # 정규화

# 모델이 요구하는 입력 형식으로 변환
data = json.dumps({"signature_name": "serving_default", "instances": [sample_image.tolist()]})

# TensorFlow Serving REST API 요청
headers = {"content-type": "application/json"}
response = requests.post("http://localhost:8501/v1/models/cifar10_model:predict", data=data, headers=headers)
predictions = response.json()["predictions"]
predicted_class = np.argmax(predictions)

# SHAP 모델 해석을 위한 함수
def model_predict(X):
    X_list = X.tolist()
    data = json.dumps({"signature_name": "serving_default", "instances": X_list})
    response = requests.post("http://localhost:8501/v1/models/cifar10_model:predict", data=data, headers=headers)
    return np.array(response.json()["predictions"])

# SHAP explainer 생성 (올바른 방식)
explainer = shap.Explainer(model_predict, data=X_train[:100] / 255.0, masker=shap.maskers.Image("inpaint_telea", X_train[0].shape))

# SHAP 값을 계산
shap_values = explainer(sample_image.reshape(1, 32, 32, 3))

# SHAP 시각화
plt.figure(figsize=(8, 8))
shap.image_plot(shap_values, sample_image.reshape(1, 32, 32, 3))

# 예측 결과 출력
print(f"✅ 예측된 클래스: {cifar10_labels[predicted_class]} (ID: {predicted_class})")



print(np.array(shap_values).shape)  # 확인


# 예측된 클래스(truck)만 확인
plt.figure(figsize=(8, 8))
shap.image_plot([shap_values[0][pred_class]], sample_image.reshape(1, 32, 32, 3))
