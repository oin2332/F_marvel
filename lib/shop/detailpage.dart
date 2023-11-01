import 'package:flutter/material.dart';
import 'package:food_marvel/shop/reservationAdd.dart';
import 'package:food_marvel/shop/tabBar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';




class DetailPage extends StatefulWidget {

  DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}



class _DetailPageState extends State<DetailPage> {

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
                            Text('${storeList[index]['카테고리']}   l',
                              style: TextStyle(fontSize: 10, color: Colors
                                  .grey),),
                            SizedBox(width: 8,),
                            Text('${storeList[index]['주소']}',
                                style: TextStyle(fontSize: 10, color: Colors
                                    .grey)),
                          ],
                        ),
                        Text('${storeList[index]['제목']}'),
                        Row(
                          children: [
                            Icon(
                              Icons.star, color: Colors.yellow[600], size: 17,),
                            Icon(
                              Icons.star, color: Colors.yellow[600], size: 17,),
                            Icon(
                              Icons.star, color: Colors.yellow[600], size: 17,),
                            Icon(
                              Icons.star, color: Colors.yellow[600], size: 17,),
                            Icon(Icons.star_half, color: Colors.yellow[600],
                              size: 17,),
                            SizedBox(width: 7,),
                            Text('${storeList[index]['별점']}',
                              style: TextStyle(fontWeight: FontWeight.bold),),
                            SizedBox(width: 3,),
                            Text('@개의 리뷰',
                                style: TextStyle(fontSize: 10, color: Colors
                                    .grey)),
                          ],
                        ),
                        Text('${storeList[index]['설명']}'),
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () {
                                _makePhoneCall('tel:01012341234');
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0), // 넓이 조절
                                child: Row(
                                  children: [
                                    Icon(Icons.call, size: 18,
                                        color: Colors.black),
                                    SizedBox(width: 3,),
                                    Text('전화하기',
                                        style: TextStyle(color: Colors.black)),
                                  ],
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.white), // 배경색을 흰색으로 설정
                                side: MaterialStateProperty.all(BorderSide(
                                    color: Colors.black, width: 1)), // 테두리 설정
                              ),
                            ),
                            SizedBox(width: 5,),
                            TextButton(
                              onPressed: () {},
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0), // 넓이 조절
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on, size: 18,
                                      color: Colors.black,),
                                    SizedBox(width: 3,),
                                    Text('위치보기',
                                      style: TextStyle(color: Colors.black),),
                                  ],
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.white), // 배경색을 흰색으로 설정
                                side: MaterialStateProperty.all(BorderSide(
                                    color: Colors.black, width: 1)), // 테두리 설정
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),


                  underlineBox(5.0),
                  //예약 일시 부분

                  ReservationAdd(),

                  underlineBox(5.0),

                  //홈 메뉴 사진 리뷰

                  Container(
                    child: Column(
                      children: [
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(onPressed: () {

                            }, child: Text('홈', style: TextStyle(
                                color: Colors.black),),),
                            TextButton(onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (_) =>
                                      TabBarEx(initialTabIndex: 1)));
                            }, child: Text('메뉴', style: TextStyle(
                                color: Colors.black),),),
                            TextButton(onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (_) =>
                                      TabBarEx(initialTabIndex: 2)));
                            }, child: Text('사진', style: TextStyle(
                                color: Colors.black),),),
                            TextButton(onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (_) =>
                                      TabBarEx(initialTabIndex: 3)));
                            }, child: Text('리뷰', style: TextStyle(
                                color: Colors.black),),),
                          ],
                        ),
                        SizedBox(height: 10,),

                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.25,
                              height: 2,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.25,
                              height: 2,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.25,
                              height: 2,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.25,
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
                                  Text('예약 오픈 일정', style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),),
                                  SizedBox(height: 30,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(width: 20,),
                                          Icon(Icons.access_time,
                                            color: Color(0xFFFF6347),),
                                          SizedBox(width: 6,),
                                          Text(getThisMonth() + '1일 14:00',
                                            style: TextStyle(
                                                color: Color(0xFFFF6347),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),)
                                        ],
                                      ),
                                      SizedBox(height: 3,),
                                      Row(
                                        children: [
                                          SizedBox(width: 50,),
                                          Text(getThisMonth() +
                                              '15일 ~ 30일까지 예약이 가능합니다')
                                        ],
                                      ),
                                      SizedBox(height: 24,),

                                      Row(
                                        children: [
                                          SizedBox(width: 20,),
                                          Icon(Icons.access_time,
                                            color: Color(0xFFFF6347),),
                                          SizedBox(width: 6,),
                                          Text(getThisMonth() + '15일 14:00',
                                            style: TextStyle(
                                                color: Color(0xFFFF6347),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),)
                                        ],
                                      ),
                                      SizedBox(height: 3,),
                                      Row(
                                        children: [
                                          SizedBox(width: 50,),
                                          Text(getNextMonth() +
                                              '1일 ~ 15일까지 예약이 가능합니다')
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
                                  Text('${storeList[index]['카테고리']} 공지',
                                    style: TextStyle(fontSize: 20,
                                        fontWeight: FontWeight.bold),),
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
                                  Text('편의시설', style: TextStyle(fontSize: 20,
                                      fontWeight: FontWeight.bold),),
                                  SizedBox(height: 32,),
                                  Row(
                                    children: [
                                      //계단
                                      if(true)
                                        Column(children: [
                                          Image.asset(
                                              'assets/amenities/stairs.png',
                                              width: 50, fit: BoxFit.contain),
                                          Text('계단 있어요'),
                                        ],),
                                      SizedBox(width: 34,),
                                      if(false)
                                        Column(children: [
                                          Image.asset(
                                              'assets/amenities/stairs.png',
                                              width: 50, fit: BoxFit.contain),
                                          Text('계단 없어요'),
                                        ],),

                                      Column(children: [
                                        Image.asset(
                                            'assets/amenities/floor.png',
                                            width: 50, fit: BoxFit.contain),
                                        Text('3층'),
                                      ],),
                                      SizedBox(width: 34,),

                                      if(false)
                                        Column(children: [
                                          Image.asset(
                                              'assets/amenities/kid.png',
                                              width: 50, fit: BoxFit.contain),
                                          Text('키즈존'),
                                        ],),
                                      if(true)
                                        Column(children: [
                                          Image.asset(
                                              'assets/amenities/nokid.png',
                                              width: 50, fit: BoxFit.contain),
                                          Text('NO키즈존'),
                                        ],),
                                      SizedBox(width: 34,),

                                      Column(children: [
                                        Image.asset(
                                            'assets/amenities/parking.png',
                                            width: 50, fit: BoxFit.contain),
                                        Text('주차'),
                                      ],),

                                    ],
                                  ),
                                  SizedBox(height: 35,),
                                  Row(
                                    children: [
                                      Column(children: [
                                        Image.asset(
                                            'assets/amenities/toilet.png',
                                            width: 50, fit: BoxFit.contain),
                                        Text('화장실'),
                                      ],),
                                      SizedBox(width: 34,),

                                      Column(children: [
                                        Image.asset(
                                            'assets/amenities/elevator.png',
                                            width: 50, fit: BoxFit.contain),
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
                                  Text('메뉴', style: TextStyle(fontSize: 20,
                                      fontWeight: FontWeight.bold),),
                                ],
                              )
                            ],
                          ),
                        ),
                        underlineBox(5.0),

                        Container(
                          padding: EdgeInsets.all(30),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Text('사진', style: TextStyle(fontSize: 20,
                                      fontWeight: FontWeight.bold),),
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
                                  Text('지도', style: TextStyle(fontSize: 20,
                                      fontWeight: FontWeight.bold),),
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


  int currentPage = 0; // 현재 페이지 번호
  String peopleCount = '2';

  Map<CalendarFormat, String> _availableCalendarFormats = {
    CalendarFormat.month: '월',
    CalendarFormat.twoWeeks: '2주',
    CalendarFormat.week: '주',
  };

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
    final DateTime nextMonth = now.add(
        Duration(days: 30)); // 현재 날짜에서 30일을 더해 다음 달을 구합니다.
    final String month = DateFormat('MMMM', 'ko_KR').format(
        nextMonth); // 다음 달을 문자열로 변환합니다.
    return '$month';
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageChanged); // 페이지 변경 리스너 추가
    initializeDateFormatting("ko_KR", null);
  }

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

  void _makePhoneCall(String phoneNumber) async {
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      print('전화 걸기에 실패했습니다.');
    }
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


  List<String> path = ['1.jpg', '2.jpg', '1.jpg', '2.jpg'];
  final List<Map<String, dynamic>> storeList = [
    {
      '제목': '가게이름',
      '별점': '4.8',
      '설명': '가게가 착하고 사장님이 맛있어요\n 가게가 착하고 사장님이 맛있어요',
      '주소': '성수',
      '카테고리': '레스토랑'
    }
  ];

  final PageController _pageController = PageController();
  final List<String> imagePaths = [ //음식점 사진 리스트
    'assets/33.jpg',
    'assets/33.jpg',
    'assets/44.jfif',
  ];


}




