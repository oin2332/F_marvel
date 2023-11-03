import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';


class ReservationPage extends StatefulWidget {
  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  int selectedNumber = 2;
  Map<CalendarFormat, String> _availableCalendarFormats = {
    CalendarFormat.month: '월',
    CalendarFormat.twoWeeks: '2주',
    CalendarFormat.week: '주',
  };

  DateTime? selectedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko_KR', null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('예약 일정'),
        backgroundColor: Color(0xFFFF6347),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      _selectedDay != null
                          ? DateFormat('yyyy-MM-dd (E)', 'ko_KR').format(_selectedDay!) // 한국어 로케일로 설정
                          : '날짜를 선택하세요', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // 날짜 선택 전에는 표시되지 않음
                    ),

                    Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 3),
                        Text('$selectedNumber인'),
                        IconButton(
                          onPressed: () {
                            _showModalBottomSheet(context);
                          },
                          icon: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            size: 25,
                            color: Color(0xFFFF6347),
                          ),
                        ),
                        SizedBox(width: 13),
                      ],
                    ),
                  ],
                ),
              ),
              underlineBox(0.9),
              Container(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                    // 달력 추가
                    TableCalendar(
                      availableCalendarFormats: _availableCalendarFormats,
                      focusedDay: DateTime.now(),
                      firstDay: DateTime(1800),
                      lastDay: DateTime(3000),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                        });
                      },
                      selectedDayPredicate: (DateTime date) {
                        if (_selectedDay == null) {
                          return false;
                        }
                        return date.year == _selectedDay!.year &&
                            date.month == _selectedDay!.month &&
                            date.day == _selectedDay!.day;
                      },
                      calendarFormat: CalendarFormat.month,
                      // 초기 달력 형식을 월로 설정
                      enabledDayPredicate: (DateTime date) {
                        // 이전 날짜는 비활성화
                        return date.isAfter(DateTime.now());
                      },
                      locale: 'ko_KR',
                      calendarStyle: CalendarStyle(
                        weekendTextStyle: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 80,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);

                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(150, 50)), // 버튼 크기 설정
                      side: MaterialStateProperty.all(BorderSide(color: Colors.black, width: 1)), // 테두리 색 및 너비 설정
                      backgroundColor: MaterialStateProperty.all(Colors.transparent), // 배경색 설정 (투명으로 설정하여 테두리만 보이게 함)
                    ),
                    child: Text(
                      '취소',
                      style: TextStyle(
                        color: Colors.black, // 글자색을 검은색으로 설정
                      ),
                    ),
                  )
                  ,
                  TextButton(
                    onPressed: () {
                      // 예약하기 버튼을 누를 때 날짜와 인원 수를 저장하고 화면을 닫음
                      Navigator.pop(context, {'selectedDate': _selectedDay, 'selectedNumber': selectedNumber});
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color(0xFFFF6347)),
                      minimumSize: MaterialStateProperty.all(Size(150, 50)),
                    ),
                    child: Text(
                      '예약하기',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )

                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget underlineBox(x) {
    return SizedBox(
      width: double.infinity,
      height: x,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey,
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 100,
          child: Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: 12),
                  for (int i = 1; i <= 10; i++) _numberpeople(i.toString()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _numberpeople(String num) {
    bool isSelected = selectedNumber == int.parse(num);

    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  selectedNumber = int.parse(num);
                });
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Text(
                  '$num 명',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                minimumSize: MaterialStateProperty.all(Size(40, 40)),
                backgroundColor: MaterialStateProperty.all(
                  isSelected ? Color(0xFFFF6347) : Colors.white,
                ),
                side: MaterialStateProperty.all(
                  BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
