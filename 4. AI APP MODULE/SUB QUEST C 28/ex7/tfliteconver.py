import tensorflow as tf

# ✅ 1️⃣ 기존 CIFAR-10 Keras 모델 로드
model_path = "saved_model_cifar10//1"  # 기존 모델 경로
model = tf.keras.models.load_model(model_path)  # Keras 모델 불러오기

# ✅ 2️⃣ TensorFlow Lite 변환기 생성
converter = tf.lite.TFLiteConverter.from_keras_model(model)

# ✅ 3️⃣ 최적화 옵션 설정 (필요 시)
converter.optimizations = [tf.lite.Optimize.DEFAULT]  # 모델 크기 최적화

# ✅ 4️⃣ TFLite 모델로 변환
tflite_model = converter.convert()

# ✅ 5️⃣ 변환된 모델 저장
tflite_model_path = "cifar10_model.tflite"
with open(tflite_model_path, "wb") as f:
    f.write(tflite_model)

print(f"✅ 변환된 TFLite 모델이 저장되었습니다: {tflite_model_path}")

# ✅ 6️⃣ 변환된 모델의 서명(Signature) 확인
interpreter = tf.lite.Interpreter(model_path=tflite_model_path)
interpreter.allocate_tensors()

# ✅ 모델 입력/출력 정보 확인
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

print("\n📌 [TFLite 모델 서명 확인]")
print(f"입력 정보: {input_details}")
print(f"출력 정보: {output_details}")
