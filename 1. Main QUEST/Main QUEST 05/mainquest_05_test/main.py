from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import BaseModel
import openai

# FastAPI 앱 초기화
app = FastAPI()

# CORS 설정
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# OpenAI API 키 설정
## openai.api_key = " OpenAI API 키를 입력하세요"  

# API 테스트 엔드포인트
@app.get("/test")
async def test_api():
    return {"message": "API is working!"}

# 여행 프롬프트 모델
class TravelPrompt(BaseModel):
    prompt: str

# 여행 계획 생성 엔드포인트
@app.post("/generate_travel_plan")
async def generate_travel_plan(travel_prompt: TravelPrompt):
    try:
        print(f"Received prompt: {travel_prompt.prompt}")

        # OpenAI API 호출
        response = await openai.ChatCompletion.acreate(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": "당신은 전문 여행 플래너입니다. 상세하고 실용적인 여행 일정을 만들어주세요."},
                {"role": "user", "content": travel_prompt.prompt}
            ]
        )

        # OpenAI 응답 처리
        result = response['choices'][0]['message']['content']
        print(f"Generated response: {result}")

        # UTF-8 인코딩 명시적으로 설정하여 응답 반환
        return JSONResponse(content={"response": result}, headers={"Content-Type": "application/json; charset=utf-8"})

    except Exception as e:
        print(f"Error during OpenAI API call: {str(e)}")
        return JSONResponse(
            content={"response": "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요."},
            headers={"Content-Type": "application/json; charset=utf-8"}
        )

# 서버 실행 확인용
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
