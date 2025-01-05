import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'fourth_page.dart'; 
import 'models/travel_data.dart';

class ThirdPage extends StatefulWidget {
  final TravelData travelData;

  const ThirdPage({Key? key, required this.travelData}) : super(key: key);

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  String departureLocation = '서울'; // 기본값: 서울
  String destination = '오사카'; // 기본값: 오사카
  String departureTime = '오전'; // 기본값: 오전
  int numberOfTravelers = 1; // 기본값: 1
  DateTimeRange? travelDates;

  // 여행 일수 계산
  int get travelDays {
    if (travelDates == null) return 0;
    return travelDates!.end.difference(travelDates!.start).inDays + 1;
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.fill,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            '여행 일정을 적어주세요',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 79, 79, 79),
                            ),
                          ),
                        ),
                        Text(
                          '출발지',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        DropdownButton<String>(
                          value: departureLocation,
                          items: ['서울', '인천', '부산'].map((location) {
                            return DropdownMenuItem(
                              value: location,
                              child: Text(
                                location,
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              departureLocation = value!;
                            });
                          },
                          dropdownColor: Colors.white,
                          underline: Container(
                            height: 1,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '도착지',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        DropdownButton<String>(
                          value: destination,
                          items: ['오사카', '도쿄', '삿포로'].map((location) {
                            return DropdownMenuItem(
                              value: location,
                              child: Text(
                                location,
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              destination = value!;
                            });
                          },
                          dropdownColor: Colors.white,
                          underline: Container(
                            height: 1,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Travel Duration',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        GestureDetector(
                          onTap: () async {
                            DateTimeRange? picked = await showDateRangePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData.dark(),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setState(() {
                                travelDates = picked;
                              });
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white.withOpacity(0.8),
                            ),
                            child: Text(
                              travelDates == null
                                  ? 'Select start and end date'
                                  : '${formatDate(travelDates!.start)} ~ ${formatDate(travelDates!.end)} (${travelDays}일)',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
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
                      widget.travelData.departureLocation = departureLocation;
                      widget.travelData.destination = destination;
                      widget.travelData.departureTime = departureTime;
                      widget.travelData.numberOfTravelers = numberOfTravelers;
                      widget.travelData.travelDates = travelDates == null
                          ? ''
                          : '${formatDate(travelDates!.start)} ~ ${formatDate(travelDates!.end)}';
                      widget.travelData.travelDays = travelDays;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FourthPage(travelData: widget.travelData),
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
}

