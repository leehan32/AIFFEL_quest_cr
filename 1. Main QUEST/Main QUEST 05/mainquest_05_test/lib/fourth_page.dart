import 'package:flutter/material.dart';
import 'fifth_page.dart'; 
import 'models/travel_data.dart';

class FourthPage extends StatefulWidget {
  final TravelData travelData;
  
  const FourthPage({Key? key, required this.travelData}) : super(key: key);
  
  @override
  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  // 선택된 카테고리
  String selectedCategory = 'Restaurants';

  // 데이터 맵 (카테고리별 장소 데이터)
  final Map<String, List<Map<String, String>>> categoryData = {
    'Restaurants': [
      {'name': 'Restaurant A', 'description': 'Delicious food!', 'image': 'assets/9.jpg'},
      {'name': 'Restaurant B', 'description': 'Great ambiance.', 'image': 'assets/12.jpg'},
    ],
    'Cafes': [
      {'name': 'Cafe A', 'description': 'Cozy coffee spot.', 'image': 'https://picsum.photos/200/300?random=3'},
      {'name': 'Cafe B', 'description': 'Best pastries!', 'image': 'https://picsum.photos/200/300?random=4'},
    ],
    'Shopping Malls': [
      {'name': 'Mall A', 'description': 'All-in-one shopping.', 'image': 'assets/10.jpg'},
      {'name': 'Mall B', 'description': 'High-end brands.', 'image': 'assets/14.jpg'},
    ],
    'Photo Spots': [
      {'name': 'Spot A', 'description': 'Scenic views.', 'image': 'assets/IMG_0487.jpg'},
      {'name': 'Spot B', 'description': 'Great for Instagram.', 'image': 'assets/8.jpg'},
    ],
  };

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
                // 상단 제목 및 검색창
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '가고싶은 곳을 더 골라봐요!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 31, 30, 30),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search for places...',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),

                // 카테고리 버튼
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCategoryButton('Restaurants'),
                      _buildCategoryButton('Cafes'),
                      _buildCategoryButton('Shopping Malls'),
                      _buildCategoryButton('Photo Spots'),
                    ],
                  ),
                ),

                // 이미지 그리드
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2열 그리드
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 3 / 4,
                    ),
                    itemCount: categoryData[selectedCategory]!.length,
                    itemBuilder: (context, index) {
                      final location = categoryData[selectedCategory]![index];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Image.network(
                                  location['image']!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  location['name']!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  location['description']!,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 하단 버튼
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 48.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      widget.travelData.fourthPageSpots = [
                        '이치란 라멘',
                        '오사카 우메다 백화점 초밥',
                        '유니버셜 스튜디오',
                        '오사카 닌텐도 숍',
                        '신세카이 돈키호테'
                      ];
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FifthPage(travelData: widget.travelData),
                        ),
                      );
                    },
                    child: Text(
                      '저장하고 넘어가기',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: selectedCategory == category
                ? Colors.blue
                : Colors.white.withOpacity(0.3),
            child: Icon(
              _getCategoryIcon(category),
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(height: 8),
          Text(
            category,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Restaurants':
        return Icons.restaurant;
      case 'Cafes':
        return Icons.local_cafe;
      case 'Shopping Malls':
        return Icons.shopping_cart;
      case 'Photo Spots':
        return Icons.photo;
      default:
        return Icons.place;
    }
  }
}
