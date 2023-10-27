import 'package:flutter/material.dart';
import 'package:food_marvel/shop/tabBar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

import '../main.dart';




class DetailPage extends StatefulWidget {

  DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageChanged); // 페이지 변경 리스너 추가
    initializeDateFormatting("ko_KR", null);
  }
  String _dday = '';
  DateTime? selectedDay;
  DateTime? _selectedDay;
  List<String> path = ['1.jpg', '2.jpg', '1.jpg', '2.jpg'];
  final List<Map<String, dynamic>> storeList = [
    {
      '제목' : '가게이름',
      '별점' : '4.8',
      '설명' : '가게가 착하고 사장님이 맛있어요\n 가게가 착하고 사장님이 맛있어요',
      '주소' : '성수',
      '카테고리' : '레스토랑'
    }
  ];

  final PageController _pageController = PageController();
  final List<String> imagePaths = [ //음식점 사진 리스트
    'assets/33.jpg',
    'assets/33.jpg',
    'assets/44.jfif',
  ];
  int currentPage = 0; // 현재 페이지 번호
  void _onPageChanged() {
    setState(() {
      currentPage = _pageController.page!.toInt(); // 현재 페이지 업데이트
    });
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged); // 리스너 제거
    _pageController.dispose();
    super.dispose();
  }

  Widget underlineBox(x) {
    return SizedBox(
      width: double.infinity,
      height: x,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey[400],
        ),
      ),
    );
  }

  Widget _clockbutton(colock){
    return  Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            TextButton(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0), // 넓이 조절
                child: Text(colock,style: TextStyle(color: Colors.white),),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFFFF6347),), // 배경색을 흰색으로 설정
              ),
            )

          ],
        ),
      ),
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
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
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
                  calendarFormat: CalendarFormat.month, // 초기 달력 형식을 월로 설정
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
                      _numberpeople('2'),SizedBox(width: 6,),
                      _numberpeople('3'),SizedBox(width: 6,),
                      _numberpeople('4'),SizedBox(width: 6,),
                      _numberpeople('5'),SizedBox(width: 6,),
                      _numberpeople('6'),SizedBox(width: 6,),
                      _numberpeople('7'),SizedBox(width: 6,),
                      _numberpeople('8'),SizedBox(width: 6,),
                      _numberpeople('9'),SizedBox(width: 6,),
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

  String peopleCount = '2';

  String getToday() {
    final DateTime now = DateTime.now();
    final String day = DateFormat('E', 'ko_KR').format(now); // 현재 요일을 구합니다.
    return '오늘($day)';
  }
  String getThisMonth() {
    final DateTime now = DateTime.now();
    final String month = DateFormat('MMMM', 'ko_KR').format(now); // 이번 달을 구합니다.
    return '$month';
  }

  String getNextMonth() {
    final DateTime now = DateTime.now();
    final DateTime nextMonth = now.add(Duration(days: 30)); // 현재 날짜에서 30일을 더해 다음 달을 구합니다.
    final String month = DateFormat('MMMM', 'ko_KR').format(nextMonth); // 다음 달을 문자열로 변환합니다.
    return '$month';
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            // 뒤로 가거나 다른 작업 수행
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border),
            onPressed: () {
              // 뒤로 가거나 다른 작업 수행
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: storeList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 400,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: imagePaths.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          imagePaths[index],
                          width: 400,
                          height: 200,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Center(
                      child: Container(
                        height: 30,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              '${currentPage + 1}/${imagePaths.length}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    ,
                  ),
                ],
              ),

              Container(
                padding: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('${storeList[index]['카테고리']}   l',style: TextStyle(fontSize: 10,color: Colors.grey),),
                        SizedBox(width: 8,),
                        Text('${storeList[index]['주소']}',style: TextStyle(fontSize: 10,color: Colors.grey)),
                      ],
                    ),
                    Text('${storeList[index]['제목']}'),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow[600],size: 17,),
                        Icon(Icons.star, color: Colors.yellow[600],size: 17,),
                        Icon(Icons.star, color: Colors.yellow[600],size: 17,),
                        Icon(Icons.star, color: Colors.yellow[600],size: 17,),
                        Icon(Icons.star_half, color: Colors.yellow[600],size: 17,),
                        SizedBox(width: 7,),
                        Text('${storeList[index]['별점']}',style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(width: 3,),
                        Text('@개의 리뷰',style: TextStyle(fontSize: 10,color: Colors.grey)),
                      ],
                    ),
                    Text('${storeList[index]['설명']}'),
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0), // 넓이 조절
                            child: Row(
                              children: [
                                Icon(Icons.call,size: 18,color: Colors.black),
                                SizedBox(width: 3,),
                                Text('전화하기',style: TextStyle(color: Colors.black)),
                              ],
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white), // 배경색을 흰색으로 설정
                            side: MaterialStateProperty.all(BorderSide(color: Colors.black, width: 1)), // 테두리 설정
                          ),
                        ),
                        SizedBox(width: 5,),
                        TextButton(
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0), // 넓이 조절
                            child:  Row(
                              children: [
                                Icon(Icons.location_on,size: 18,color: Colors.black,),
                                SizedBox(width: 3,),
                                Text('위치보기',style: TextStyle(color: Colors.black),),
                              ],
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white), // 배경색을 흰색으로 설정
                            side: MaterialStateProperty.all(BorderSide(color: Colors.black, width: 1)), // 테두리 설정
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),


              underlineBox(5.0),
              //예약 일시 부분

              Container(
                child:  Container(
                  padding: const EdgeInsets.all(30.0),
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('예약 일시' ,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      TextButton(
                        onPressed: () {
                          _showModalBottomSheet(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today_outlined, size: 18, color: Colors.black),
                              SizedBox(width: 8),
                              Text('${_selectedDay != null ? DateFormat('yyyy-MM-dd (E)', 'ko_KR').format(_selectedDay!) : '날짜 선택 안 함'}', style: TextStyle(color: Colors.black),
                              ),
                              Text(' / ',style: TextStyle(color: Colors.black),),
                              Text('${selectedNumber != null ? '$selectedNumber 명' : '인원 선택 안 함'}', style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                          side: MaterialStateProperty.all(BorderSide(color: Colors.black, width: 1)),
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
                              fixedSize: MaterialStateProperty.all(Size(180, 40)), // 버튼의 최소 크기 설정
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0), // 꼭지점을 둥글게 설정
                                side: BorderSide(color:Color(0xFFFF6347), width: 1), // 1픽셀 두꺼운 테두리 설정
                              )),
                              backgroundColor: MaterialStateProperty.all(Colors.white), // 배경색 설정
                            ),
                            child: Center(
                                child :Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(width: 3,),
                                    Text('예약가능 날짜 찾기',style: TextStyle(color:Color(0xFFFF6347)),),
                                    Icon(Icons.keyboard_arrow_right,color:Color(0xFFFF6347),)
                                  ],
                                )

                            ),
                          )
                      ),
                    ],
                  ),
                ),
              ),
            underlineBox(5.0),
              Container(
                child: Column(
                  children: [
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(onPressed: (){}, child: Text('홈',style: TextStyle(color: Colors.black),),),
                        TextButton(onPressed: (){}, child: Text('메뉴',style: TextStyle(color: Colors.black),),),
                        TextButton(onPressed: (){}, child: Text('사진',style: TextStyle(color: Colors.black),),),
                        TextButton(onPressed: (){}, child: Text('리뷰',style: TextStyle(color: Colors.black),),),
                      ],
                    ),
                    SizedBox(height: 10,),

                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: 2,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: 2,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: 2,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: 2,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    //예약오픈일정
                    Container(
                      padding: EdgeInsets.all(30),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('예약 오픈 일정',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                              SizedBox(height: 30,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(width: 20,),
                                      Icon(Icons.access_time,color:Color(0xFFFF6347),),
                                      SizedBox(width: 6,),
                                      Text(getThisMonth()+'1일 14:00',style: TextStyle(color : Color(0xFFFF6347),fontWeight: FontWeight.bold,fontSize: 16),)
                                    ],
                                  ),
                                  SizedBox(height: 3,),
                                  Row(
                                    children: [
                                      SizedBox(width: 50,),
                                      Text(getThisMonth()+'15일 ~ 30일까지 예약이 가능합니다')
                                    ],
                                  ),
                                  SizedBox(height: 24,),

                                  Row(
                                    children: [
                                      SizedBox(width: 20,),
                                      Icon(Icons.access_time,color:Color(0xFFFF6347),),
                                      SizedBox(width: 6,),
                                      Text(getThisMonth()+'15일 14:00',style: TextStyle(color : Color(0xFFFF6347),fontWeight: FontWeight.bold,fontSize: 16),)
                                    ],
                                  ),
                                  SizedBox(height: 3,),
                                  Row(
                                    children: [
                                      SizedBox(width: 50,),
                                      Text(getNextMonth()+'1일 ~ 15일까지 예약이 가능합니다')
                                    ],
                                  ),


                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            underlineBox(5.0),
            //공지--------------------------

                    Container(
                      padding: EdgeInsets.all(30),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text('${storeList[index]['카테고리']} 공지',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                            ],
                          )
                        ],
                      ),
                    ),


            underlineBox(5.0),
                    //편의시설--------------------

                    Container(
                      padding: EdgeInsets.all(30),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('편의시설',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                              SizedBox(height: 32,),
                              Row(
                                children: [
                                  //계단
                                  if(true)
                                  Column(children: [
                                    Image.asset('assets/amenities/stairs.png',width: 50, fit: BoxFit.contain),
                                    Text('계단 있어요'),
                                  ],),
                                  SizedBox(width: 34,),
                                  if(false)
                                  Column(children: [
                                    Image.asset('assets/amenities/stairs.png',width: 50, fit: BoxFit.contain),
                                    Text('계단 없어요'),
                                  ],),

                                  Column(children: [
                                    Image.asset('assets/amenities/floor.png',width: 50, fit: BoxFit.contain),
                                    Text('3층'),
                                  ],),
                                  SizedBox(width: 34,),

                                  if(false)
                                  Column(children: [
                                    Image.asset('assets/amenities/kid.png',width: 50, fit: BoxFit.contain),
                                    Text('키즈존'),
                                  ],),
                                  if(true)
                                  Column(children: [
                                    Image.asset('assets/amenities/nokid.png',width: 50, fit: BoxFit.contain),
                                    Text('NO키즈존'),
                                  ],),
                                  SizedBox(width: 34,),

                                  Column(children: [
                                    Image.asset('assets/amenities/parking.png',width: 50, fit: BoxFit.contain),
                                    Text('주차'),
                                  ],),

                                ],
                              ),
                              SizedBox(height: 35,),
                              Row(
                                children: [
                                  Column( children: [
                                        Image.asset('assets/amenities/toilet.png',width: 50, fit: BoxFit.contain),
                                        Text('화장실'),
                                  ],),
                                  SizedBox(width: 34,),

                                  Column( children: [
                                    Image.asset('assets/amenities/elevator.png',width: 50, fit: BoxFit.contain),
                                    Text('엘리베이터'),
                                    SizedBox(width: 34,),
                                  ],),

                                ],
                              )


                            ],
                          )
                        ],
                      ),
                    ),
                    //계단정보

                    //주차정보

                    underlineBox(5.0),
                    //메뉴--------------------
                    Container(
                      padding: EdgeInsets.all(30),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text('메뉴',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                            ],
                          )
                        ],
                      ),
                    ),

                    underlineBox(5.0),
                    //사진--------------------
                    Container(
                      padding: EdgeInsets.all(30),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text('사진',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                            ],
                          )
                        ],
                      ),
                    ),






          ],
                ),
              )



            ],
          );
        }
      )
    );
  }
}
