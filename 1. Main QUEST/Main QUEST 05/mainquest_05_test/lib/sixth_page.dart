import 'package:flutter/material.dart';
import 'models/travel_data.dart';
import 'services/ai_service.dart';

class SixthPage extends StatefulWidget {
  final TravelData travelData;

  const SixthPage({Key? key, required this.travelData}) : super(key: key);

  @override
  _SixthPageState createState() => _SixthPageState();
}

class _SixthPageState extends State<SixthPage> {
  String? aiResponse;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _generatePlan();
  }

  Future<void> _generatePlan() async {
    try {
      print('Generating travel plan...'); // 디버깅용
      final response = await AIService.generateTravelPlan(widget.travelData);
      print('Response received: $response'); // 디버깅용
      
      setState(() {
        aiResponse = response;
        isLoading = false;
      });
    } catch (e) {
      print('Error occurred: $e'); // 디버깅용
      setState(() {
        aiResponse = """
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
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경화면
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.fill,
            ),
          ),

          // 메인 UI
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI 여행 일정!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: isLoading
                          ? Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                              child: Text(
                                aiResponse ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
