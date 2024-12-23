import 'dart:async';

class CountClock {
  int counter; 
  late Timer timer; 

  CountClock(int m) : counter = m * 1; //생성자 

  void start(Function onComplete) { //onecomplte 타이머가 끝났을때 다음 작업시작작 실행되는 콜백 함수수
    timer = Timer.periodic(Duration(seconds: 1), (timer1) {
      int minutes = counter ~/ 60;
      int seconds = counter % 60;

      print(
        'count: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}');

      counter--;

      if (counter < 0) {
        print('Countdown Complete!');
        timer1.cancel();
        onComplete(); //타이머 0시 콜백백
      }
    });
  }
}


main(){
    CountClock main = CountClock(2);
    CountClock shor = CountClock(2);
    CountClock long = CountClock(2);
   main.start(() {
    shor.start(() {
      main.start(() {
        shor.start(() {
          main.start(() {
            shor.start(() {
              main.start(() {
                long.start(() {
                });
              });
            });
          });
        });
      });
    });
  });
}