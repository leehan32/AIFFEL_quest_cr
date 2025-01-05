import 'package:flutter/material.dart';
import 'sixth_page.dart'; 
import 'models/travel_data.dart';

class FifthPage extends StatelessWidget {
  final TravelData travelData;
  
  const FifthPage({Key? key, required this.travelData}) : super(key: key);
  
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
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 상단 요약 정보
                        Text(
                          '여행 요약',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 날짜 정보
                            Text(
                              '2025-01-02 ~ 2025-01-05',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            // 인원수
                            Row(
                              children: [
                                Text(
                                  '2',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(Icons.person, color: Colors.white),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // 저장된 이미지 그리드뷰
                        Text(
                          '선택한 포토 스팟',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 3 / 4,
                          ),
                          itemCount: 4, // 예시 이미지 개수
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.transparent,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Image.network(
                                        index == 0 ? 'assets/1.jpg' :
                                        index == 1 ? 'assets/2.jpg' :
                                        index == 2 ? 'assets/3.jpg' :
                                        'assets/7.jpg',
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        index == 0 ? '#소라니와 온천' :
                                        index == 1 ? '#오사카 성' :
                                        index == 2 ? '#도톤 보리' :
                                        '#닌텐도 월드',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 16),

                        // 저장된 리스트뷰
                        Text(
                          '선택한 탐험 장소',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 5, // 예시 리스트 개수
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  index == 0 ? 'assets/9.jpg' :
                                  index == 1 ? 'assets/11.jpg' :
                                  index == 2 ? 'assets/10.jpg' :
                                  index == 3 ? 'assets/14.jpg' :
                                  'assets/8.jpg',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                '장소 ${index + 1}',
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                index == 0 ? '일본 유명 체인점' :
                                index == 1 ? '로컬 맛집' :
                                index == 2 ? '오사카 최대의 닌텐도 숍' :
                                index == 3 ? '신세카이의 거대한 돈키호테' :
                                '유니버셜 스튜디오의 핫한 장소!',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                // 하단 버튼
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                          ),
                          onPressed: () {
                            // TODO: 요약된 정보 저장
                          },
                          child: Text(
                            '계획 저장',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SixthPage(travelData: travelData),
                              ),
                            );
                          },
                          child: Text(
                            'AI로 여행 경로 생성',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
