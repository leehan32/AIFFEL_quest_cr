import torch
import numpy as np
import cv2
import matplotlib.pyplot as plt
from torchvision import models, transforms
from torchvision.models.segmentation import DeepLabV3_ResNet101_Weights
from segment_anything import sam_model_registry, SamAutomaticMaskGenerator
from PIL import Image

# 디바이스 설정 (가능하면 GPU 사용)
device = "cuda" if torch.cuda.is_available() else "cpu"

# SAM 모델 로드
def load_sam_model():
    model_type = "vit_h"  # SAM 모델 종류
    checkpoint_path = "C:/Users/dkdle/Desktop/ex3/sam_vit_h_4b8939.pth"  # 로컬 경로
    sam = sam_model_registry[model_type](checkpoint=checkpoint_path)
    sam.to(device)
    mask_generator = SamAutomaticMaskGenerator(sam)
    return mask_generator

# DeepLabV3 모델 로드
def load_deeplab_model():
    model = models.segmentation.deeplabv3_resnet101(weights=DeepLabV3_ResNet101_Weights.DEFAULT).to(device).eval()
    return model

# 이미지 로드
def load_image(image_path):
    image = cv2.imread(image_path, cv2.IMREAD_UNCHANGED)
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    return image

# DeepLabV3로 개/고양이 영역 찾기
def get_pet_mask(model, image):
    preprocess = transforms.Compose([
        transforms.ToPILImage(),
        transforms.Resize((512, 512)),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
    ])

    input_tensor = preprocess(image).unsqueeze(0).to(device)
    with torch.no_grad():
        output = model(input_tensor)['out'][0]
    
    mask = output.argmax(0).byte().cpu().numpy()
    mask = cv2.resize(mask, (image.shape[1], image.shape[0]))

    # DeepLabV3의 클래스 ID (배경: 0, 고양이: 8, 개: 12)
    pet_mask = np.where((mask == 8) | (mask == 12), 1, 0).astype(np.uint8)

    # **모폴로지 연산 적용하여 마스크 다듬기 (배경 정리)**
    kernel = np.ones((5, 5), np.uint8)
    pet_mask = cv2.morphologyEx(pet_mask, cv2.MORPH_CLOSE, kernel, iterations=2)  # 작은 구멍 메우기
    pet_mask = cv2.morphologyEx(pet_mask, cv2.MORPH_OPEN, kernel, iterations=1)  # 작은 노이즈 제거

    return pet_mask

# SAM으로 개/고양이 정교한 마스크 추출
def refine_mask_with_sam(mask_generator, image, pet_mask):
    masks = mask_generator.generate(image)

    refined_mask = np.zeros_like(pet_mask)
    for mask in masks:
        mask_array = mask['segmentation']
        overlap = np.sum(np.logical_and(mask_array, pet_mask)) / np.sum(mask_array)

        # **DeepLabV3 마스크와 50% 이상 겹치는 마스크만 유지 (배경 제거 목적)**
        if overlap > 0.5:
            refined_mask = np.logical_or(refined_mask, mask_array).astype(np.uint8)

    return refined_mask

# 배경 제거 및 투명한 PNG 저장
def save_chroma_key_image(image, mask, output_path):
    # 원본 이미지를 RGBA (투명 포함)로 변환
    rgba_image = np.dstack((image, np.ones(image.shape[:2], dtype=np.uint8) * 255))

    # 배경을 투명하게 설정 (0: 투명, 1: 유지)
    rgba_image[:, :, 3] = mask * 255

    # 저장 (PNG 포맷)
    output_image = Image.fromarray(rgba_image)
    output_image.save(output_path)

# 실행 코드
image_path = "C:/Users/dkdle/Desktop/ex3/segtest07.jpg"  # 업로드한 이미지 사용
output_path = "C:/Users/dkdle/Desktop/ex3/chroma_key_pets2.png"  # 크로마키된 이미지 저장 경로

image = load_image(image_path)

# 모델 로드
deeplab_model = load_deeplab_model()
sam_mask_generator = load_sam_model()

# DeepLabV3로 개/고양이 마스크 생성
pet_mask = get_pet_mask(deeplab_model, image)

# SAM으로 정교한 개/고양이 마스크 보정
refined_mask = refine_mask_with_sam(sam_mask_generator, image, pet_mask)

# 크로마키된 이미지 저장 (배경 제거)
save_chroma_key_image(image, refined_mask, output_path)

# 저장된 이미지 경로 출력
output_path
