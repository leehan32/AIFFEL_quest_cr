import 'package:flutter/material.dart';
import 'third_page.dart'; 
import 'models/travel_data.dart';

class SecondPage extends StatefulWidget {
  final TravelData travelData;
  
  const SecondPage({Key? key, required this.travelData}) : super(key: key);
  
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  // 선택된 아이템 저장
  List<bool> selectedItems = List.generate(6, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경화면
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.fill, // 배경화면 전체를 채움
            ),
          ),

          // 메인 UI
          SafeArea(
            child: Column(
              children: [
                // 상단 제목
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '사진은 여행의 꽃 더많은 스팟!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 1, 1, 1),
                    ),
                  ),
                ),

                // 이미지 그리드 뷰
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2열 그리드
                      crossAxisSpacing: 10, // 열 간격
                      mainAxisSpacing: 10, // 행 간격
                      childAspectRatio: 3 / 4, // 각 항목 비율
                    ),
                    itemCount: 6, // 총 이미지 수
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedItems[index] = !selectedItems[index];
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selectedItems[index]
                                  ? Colors.blue // 선택된 경우 파란 테두리
                                  : Colors.transparent, // 선택되지 않은 경우 투명
                              width: 3,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              'assets/${index + 2}.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 하단 버튼
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 이전 페이지로 돌아가는 버튼
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              '뒤로가기',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),

                      // "Next" 버튼: 세 번째 페이지로 이동
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                            ),
                            onPressed: () {
                              widget.travelData.secondPageSpots = ['오사카 성', '도톤 보리', '닌텐도 월드'];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ThirdPage(travelData: widget.travelData),
                                ),
                              );
                            },
                            child: Text(
                              '저장하고 넘어가기',
                              style: TextStyle(color: Colors.white),
                            ),
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
