class TravelData {

  String? firstPageSpot;


  List<String> secondPageSpots = [];


  String? departureLocation;
  String? destination;
  String? departureTime;
  int numberOfTravelers = 2;
  String? travelDates;
  int travelDays = 0; 


  List<String> fourthPageSpots = [];

  // 여행 정보를 바탕으로 프롬프트 생성
  String generatePrompt() {
    return '''
여행 정보:
날짜: $travelDates
일수: $travelDays일
인원: $numberOfTravelers명
출발: $departureLocation
도착: $destination
출발시간: $departureTime

선택한 관광지:
- $firstPageSpot
${secondPageSpots.map((spot) => '- $spot').join('\n')}

추가 방문희망 장소:
${fourthPageSpots.map((spot) => '- $spot').join('\n')}

위 정보를 바탕으로 $travelDays일간의 효율적인 여행 일정을 만들어주세요.
''';
  }
}
