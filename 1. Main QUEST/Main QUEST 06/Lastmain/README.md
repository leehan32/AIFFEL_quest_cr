###  **U-Net 성능 감소 시험 정리**  

---

## ✅ **1. 의료영상 데이터 전체리 및 Augmentation 파이프라인**  
**목표:**  
- 데이터 전체리 및 증가(Augmentation)을 통해 모델 성능 향상  

**진행한 작업:**  
 `tf.data.Dataset`을 활용한 데이터 파이프라인 구성  
 `resize`, `scaling`, `grayscale 변환` 적용  
 `flip, shift` 등의 Augmentation 추가  
 데이터세트 `shuffle` 및 `batching` 처리 완료  

**결과:**  
- Augmentation이 정상적으로 반영된 `tf.data.Dataset`이 구성되어서, 학습 중 데이터 변형이 올바르게 적용되며 확인함 ✅  

---

## ✅ **2. U-Net 감소 모델 구현 및 성능 비교**  
**모델 3개의 비교:**  
| 모델 | 주요 특징 |  
|------|----------|  
| **(1) 일반 U-Net** | 기본 U-Net 구조 사용 |  
| **(2) Pretrained U-Net** | VGG16 Encoder 적용 |  
| **(3) Encoder-Decoder** | 간단한 CNN Encoder-Decoder 사용 |  

**모델 학습 과정 확인:**  
 학습 로그를 통해 loss 감소 확인  
 `learning rate scheduler` 적용으로 학습 안정화  
학습이 정상적으로 진행되였고, `Pretrained U-Net`이 기존 U-Net 대비 더 빠른 수리와 같은 경험을 보임  

**Validation 성능 비교:**  
- `mean IoU`(Intersection over Union) 평가 결과:  
  - 기존 U-Net보다 `Pretrained U-Net`이 **더 높은 IoU 값**을 기록  
  - Encoder-Decoder 모델은 가장 낮은 성능을 보임  

---

## ✅ **3. 학습 과정 및 테스트 결과 비교 분석**  
**(1) Loss 그래프 비교**  
 3개 모델의 학습 및 검증 `loss`를 시각화하여 비교  
 `Pretrained U-Net`이 가장 안정적으로 수리함  

**(2) mean IoU 계산 결과 비교**  
 각 모델의 IoU 점수를 비교하여 성능 차이 확인  
 `Pretrained U-Net`이 기존 U-Net 대비 향상된 IoU 점수를 기본  

**(3) Segmentation 결과 시각화**  
 `Input Image - Ground Truth Mask - Predicted Mask` 비교  
 `Pretrained U-Net`이 **가장 선명한 분합 결과**를 보였으며, Encoder-Decoder 모델은 가장 헤어질리면 예측 결과를 보임  

---

##  **결론 및 감소 방향**  
###  **최종 모델 선택: Pretrained U-Net (VGG16 기반)**  
- 기존 U-Net 대비 성능 감소 확인  
- 학습 속도 및 정확도가 떨어진다  


📊 **결론:**  
**"Pretrained U-Net을 사용하면 의료 영상 segmentation에서 기존 U-Net 대비 더 나은 성능을 얻을 수 있다"** 

