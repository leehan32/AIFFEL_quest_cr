import torch
import numpy as np
import cv2
import matplotlib.pyplot as plt
from torchvision import models, transforms
from torchvision.models.segmentation import DeepLabV3_ResNet101_Weights
from segment_anything import sam_model_registry, SamAutomaticMaskGenerator

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
    image = cv2.imread(image_path)
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    return image

# 사람(Person) 마스크 생성
def get_person_mask(model, image):
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

    # 사람(Person) 클래스 (ID=15)만 선택
    person_mask = np.where(mask == 15, 1, 0).astype(np.uint8)

    # **모폴로지 연산으로 마스크 정리 (배경 정리)**
    kernel = np.ones((5, 5), np.uint8)
    person_mask = cv2.morphologyEx(person_mask, cv2.MORPH_CLOSE, kernel, iterations=2)  # 작은 구멍 메우기
    person_mask = cv2.morphologyEx(person_mask, cv2.MORPH_OPEN, kernel, iterations=1)  # 작은 노이즈 제거

    return person_mask


# SAM으로 개/고양이 정교한 마스크 추출 (DeepLabV3와 비교)
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

# 아웃포커싱 (배경 블러) 적용
def apply_blur(image, mask):
    blurred = cv2.GaussianBlur(image, (25, 25), 10)
    result = np.where(mask[:, :, None] == 1, image, blurred)
    return result

# 결과 시각화
def visualize_segmentation(image, mask, title="Segmented Result"):
    plt.figure(figsize=(10, 10))
    plt.imshow(image)
    plt.imshow(mask, alpha=0.3, cmap='coolwarm')
    plt.axis("off")
    plt.title(title)
    plt.show()

# 실행 코드
image_path = "C:/Users/dkdle/Desktop/ex3/segtest06.jpg"  # 업로드한 이미지 사용
image = load_image(image_path)

# 모델 로드
deeplab_model = load_deeplab_model()
sam_mask_generator = load_sam_model()

# DeepLabV3로 개/고양이 마스크 생성
pet_mask = get_person_mask(deeplab_model, image)

# SAM으로 정교한 개/고양이 마스크 보정
refined_mask = refine_mask_with_sam(sam_mask_generator, image, pet_mask)

# 아웃포커싱 적용
blurred_image = apply_blur(image, refined_mask)
visualize_segmentation(blurred_image, refined_mask, "Blurred Background - Only Pets")

# 최종 마스크 확인
visualize_segmentation(image, refined_mask, "Final Mask - Only Pets")
