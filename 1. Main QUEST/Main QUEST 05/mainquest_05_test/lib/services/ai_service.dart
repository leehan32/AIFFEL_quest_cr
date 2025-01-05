import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/travel_data.dart';

class AIService {
  // 서버 주소 (로컬 서버의 IP 주소와 포트를 설정)
  static const String baseUrl = 'http://192.168.0.75:8000'; // 서버 IP와 포트 확인 필요

  static Future<String> generateTravelPlan(TravelData travelData) async {
    try {
      print('Starting API request...');

      final url = Uri.parse('$baseUrl/generate_travel_plan');
      print('Request URL: $url'); // 요청 URL 출력

      final requestBody = {
        'prompt': travelData.generatePrompt(),
      };
      print('Request body: ${json.encode(requestBody)}'); // 요청 본문 출력

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      ).timeout(
        const Duration(seconds: 30),
      );

      print('Response status: ${response.statusCode}'); // 응답 상태 코드 출력
      print('Response body: ${response.body}'); // 응답 본문 출력

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['response'];
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in generateTravelPlan: $e'); // 더미 데이터터
      return """
3일간의 오사카 여행 일정입니다:

1일차:
- 오전 (09:00-10:00): 서울에서 오사카로 출발, 간사이 공항 도착
- 오후 (13:00-16:00): 오사카 성 관광
- 저녁 (18:00-21:00): 도톤보리 거리 탐방, 이치란 라멘에서 저녁 식사

2일차:
- 오전 (09:00-12:00): 유니버셜 스튜디오 재팬
- 점심 (12:00-13:00): 유니버셜 스튜디오 내 식사
- 오후 (13:00-17:00): 유니버셜 스튜디오 계속
- 저녁 (18:00-20:00): 오사카 닌텐도 숍 방문, 닌텐도 월드 체험

3일차:
- 오전 (09:00-11:00): 소라니와 온천에서 휴식
- 점심 (12:00-13:30): 우메다 백화점에서 초밥 점심
- 오후 (14:00-16:00): 신세카이 돈키호테에서 쇼핑
- 저녁 (19:00): 간사이 공항에서 서울로 출발

이동 동선을 최적화하여 배치했습니다.
각 장소는 교통편으로 30분 이내 거리에 있습니다.
""";
    }
  }
}
