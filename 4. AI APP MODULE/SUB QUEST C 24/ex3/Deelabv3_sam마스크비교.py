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
# SAM 모델 로드
def load_sam_model():
    model_type = "vit_h"  # SAM 모델 종류 (기본값: ViT-H)
    checkpoint_path = "C:/Users/dkdle/Desktop/ex3/sam_vit_h_4b8939.pth"  # 사전 학습된 체크포인트
    sam = sam_model_registry[model_type](checkpoint=checkpoint_path)
    sam.to(device="cuda" if torch.cuda.is_available() else "cpu")

    # 자동 마스크 생성기 (AutoMask)
    mask_generator = SamAutomaticMaskGenerator(sam)
    return mask_generator

# DeepLabV3 모델 로드
def load_deeplab_model():
    model = models.segmentation.deeplabv3_resnet101(weights=DeepLabV3_ResNet101_Weights.DEFAULT).to(device).eval()
    return model

# 이미지 로드 및 전처리
def load_image(image_path):
    image = cv2.imread(image_path)
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    return image

# DeepLabV3 세그멘테이션 수행
def segment_with_deeplab(model, image):
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
    return cv2.resize(mask, (image.shape[1], image.shape[0]))

# SAM 기반 세그멘테이션 수행
def segment_with_sam(mask_generator, image):
    masks = mask_generator.generate(image)  # SAM 자동 세그멘테이션 수행
    return masks

# 시각화 함수 (DeepLabV3 + SAM 비교)
def visualize_comparison(image, deeplab_mask, sam_masks):
    fig, axs = plt.subplots(1, 3, figsize=(18, 6))

    # 원본 이미지
    axs[0].imshow(image)
    axs[0].axis("off")
    axs[0].set_title("Original Image")

    # DeepLabV3 결과
    axs[1].imshow(image)
    axs[1].imshow(deeplab_mask, alpha=0.5, cmap='jet')  # DeepLabV3의 결과 오버레이
    axs[1].axis("off")
    axs[1].set_title("DeepLabV3 Segmentation")

    # SAM 결과 (다양한 마스크를 색상으로 표현)
    mask_layer = np.zeros_like(image, dtype=np.uint8)
    unique_colors = plt.get_cmap("tab10", len(sam_masks))  # SAM의 여러 마스크에 색 부여

    for i, mask in enumerate(sam_masks):
        mask_array = mask['segmentation']
        color = tuple(int(c * 255) for c in unique_colors(i)[:3])
        mask_layer[mask_array] = color
    
    blended_sam = cv2.addWeighted(image, 0.6, mask_layer, 0.4, 0)
    axs[2].imshow(blended_sam)
    axs[2].axis("off")
    axs[2].set_title("SAM Segmentation")

    plt.show()

# 실행 코드 (로컬에서 실행)
if __name__ == "__main__":
    image_path = "C:/Users/dkdle/Desktop/ex3/segtest07.jpg"  # 이미지 파일 경로 (로컬 설정 필요)
    image = load_image(image_path)

    # 모델 로드
    deeplab_model = load_deeplab_model()
    sam_mask_generator = load_sam_model()

    # 각 모델 적용
    deeplab_mask = segment_with_deeplab(deeplab_model, image)
    sam_masks = segment_with_sam(sam_mask_generator, image)

    # 결과 시각화
    visualize_comparison(image, deeplab_mask, sam_masks)
