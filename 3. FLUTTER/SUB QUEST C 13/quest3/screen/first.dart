import 'package:flutter/material.dart';

class FirstScreen extends StatefulWidget {
  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  bool is_cat = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Page'),
        leading: Icon(Icons.pets),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Next'),
              onPressed: () async {                
                final returnval = await Navigator.pushNamed(
                  context, 
                  '/two',
                  arguments: false, );  
                if (returnval != null && returnval is bool) {
                  setState(() {
                    is_cat = returnval;
                  });
                }
              },
            ),
            IconButton(
              icon: Image.asset('assets/pic/8.png'),
              iconSize: 300, 
              onPressed: () {
                print('is_cat: $is_cat');
              },
            ),
          ],
        ),
      ),
    );
  }
}



/*
## 디버깅 기록

- **최소 페이지 설정시 route 연결 오류 부분 → 해결**
- **전달된 데이터를 받는 방식 : 첫 단계 디폴트된 bool 값을 받는 방식과 그것에 대한 정의의 위치 설정 →  해결**
- 1페이지 setState에서 2페이지 context의 true를 받고 returnval 하지 못한 부분 → 해결



 회고
- 비교적 간단해 보이는 로직이지만 실제로 페어프로그래밍 과정에서 학습한 내용 중에 다시 상기하거나 서칭하는데 소요되는 시간들이 있었다.
- 퀘스트라는 환경에서 얻을 수 있었던 점 : 학습과정에서 확실히 인지된 것과 그렇지 못했던 부분이 무엇인지 깨달을 수 있고 부족한 부분을 더 이해하고 개선해가는 과정이 될 수 있었다.
- 추가 시도해 보면 좋을 부분 : route 대신에 onGenerateRoute 적용해보기. pop대신에
*/