import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class ReservationAdd extends StatefulWidget {
  const ReservationAdd({super.key});

  @override
  State<ReservationAdd> createState() => _ReservationAddState();
}

class _ReservationAddState extends State<ReservationAdd> {


  DateTime? selectedDay;
  DateTime? _selectedDay;
  int? selectedNumber;

  Map<CalendarFormat, String> _availableCalendarFormats = {
    CalendarFormat.month: '월',
    CalendarFormat.twoWeeks: '2주',
    CalendarFormat.week: '주',
  };

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 900,
          child: Container(
            child: Column(
              children: [
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


                SizedBox(height: 15
                  ,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(width: 12,),
                      _numberpeople('1'),
                      SizedBox(width: 6,),
                      _numberpeople('2'), SizedBox(width: 6,),
                      _numberpeople('3'), SizedBox(width: 6,),
                      _numberpeople('4'), SizedBox(width: 6,),
                      _numberpeople('5'), SizedBox(width: 6,),
                      _numberpeople('6'), SizedBox(width: 6,),
                      _numberpeople('7'), SizedBox(width: 6,),
                      _numberpeople('8'), SizedBox(width: 6,),
                      _numberpeople('9'), SizedBox(width: 6,),
                      _numberpeople('10'),

                    ],
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 모달 닫기
                  },
                  child: Text('확인'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _numberpeople(String num) {
    bool isSelected = selectedNumber == int.parse(num); // 현재 숫자가 선택된 숫자와 같은지 확인
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
              },
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Text(
                  '$num명',
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

  Widget _clockbutton(colock) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            TextButton(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0), // 넓이 조절
                child: Text(colock, style: TextStyle(color: Colors.white),),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Color(0xFFFF6347),), // 배경색을 흰색으로 설정
              ),
            )

          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('예약 일시',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            TextButton(
              onPressed: () {
                _showModalBottomSheet(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 18,
                        color: Colors.black),
                    SizedBox(width: 8),
                    Text('${_selectedDay != null
                        ? DateFormat('yyyy-MM-dd (E)', 'ko_KR').format(
                        _selectedDay!)
                        : '날짜 선택 안 함'}', style: TextStyle(color: Colors.black),
                    ),
                    Text(' / ', style: TextStyle(color: Colors.black),),
                    Text('${selectedNumber != null
                        ? '$selectedNumber 명'
                        : '인원 선택 안 함'}', style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                side: MaterialStateProperty.all(
                    BorderSide(color: Colors.black, width: 1)),
              ),
            ),

            SizedBox(height: 8,),
            Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _clockbutton('11:00'),
                    SizedBox(width: 8,),
                    _clockbutton('13:00'),
                    SizedBox(width: 8,),
                    _clockbutton('14:00'),
                    SizedBox(width: 8,),
                    _clockbutton('15:00'),
                    SizedBox(width: 8,),
                    _clockbutton('16:00'),
                    SizedBox(width: 8,),
                    _clockbutton('17:00'),
                    SizedBox(width: 8,),
                    _clockbutton('19:00'),
                    SizedBox(width: 8,),
                    _clockbutton('20:00'),
                    SizedBox(width: 8,),
                    _clockbutton('21:00'),
                    SizedBox(width: 8,),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15,),

            Center(
                child: TextButton(
                  onPressed: () {
                    //
                  },
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size(180, 40)),
                    // 버튼의 최소 크기 설정
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // 꼭지점을 둥글게 설정
                      side: BorderSide(
                          color: Color(0xFFFF6347), width: 1), // 1픽셀 두꺼운 테두리 설정
                    )),
                    backgroundColor: MaterialStateProperty.all(
                        Colors.white), // 배경색 설정
                  ),
                  child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(width: 3,),
                          Text('예약가능 날짜 찾기', style: TextStyle(color: Color(
                              0xFFFF6347)),),
                          Icon(Icons.keyboard_arrow_right,
                            color: Color(0xFFFF6347),)
                        ],
                      )

                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
