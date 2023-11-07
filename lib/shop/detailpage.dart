import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_marvel/map/mini.dart';
import 'package:food_marvel/shop/reservationAdd.dart';
import 'package:food_marvel/shop/tabBar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
class DetailPage extends StatefulWidget {

  final String docId; // docId를 받을 변수 추가

  DetailPage({required this.docId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}
class _DetailPageState extends State<DetailPage> {

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageChanged); // 페이지 변경 리스너 추가
    initializeDateFormatting("ko_KR", null);
    _fetchAllUserData(widget.docId);
  }

  List<Map<String, dynamic>> userDataList = [];

  Future<List<Widget>?> _fetchAllUserData(String docId) async {
    try {
      DocumentSnapshot storeSnapshot = await FirebaseFirestore.instance
          .collection('T3_STORE_TBL')
          .doc(docId)
          .get();

      if (storeSnapshot.exists) {
        Map<String, dynamic> storeData = storeSnapshot.data() as Map<String, dynamic>;

        // 해당 상점의 별점 정보 가져오기
        QuerySnapshot starSnapshot = await FirebaseFirestore.instance
            .collection('T3_STORE_TBL')
            .doc(docId)
            .collection('T3_STAR_TBL')
            .get();

        QuerySnapshot storeImgList = await FirebaseFirestore.instance
            .collection('T3_STORE_TBL')
            .doc(docId)
            .collection('T3_STOREIMG_TBL')
            .get();

        List<String> starList = [];
        double x = 0;
        int y = 0;

        if (starSnapshot.docs.isNotEmpty) {
          for (var starDoc in starSnapshot.docs) {
            Map<String, dynamic> starData = starDoc.data() as Map<String, dynamic>;

            starData.forEach((key, value) {
              if (value is String) {
                double? numericValue = double.tryParse(value);
                if (numericValue != null) {
                  starList.add(value);
                  x += numericValue;
                  y++;
                }
              }
            });
          }
          for (var storeImgDoc in storeImgList.docs) {
            Map<String, dynamic> storeImgData = storeImgDoc.data() as Map<String, dynamic>;
            List<String> imgList = storeImgData.values.cast<String>().toList();
            imagePaths.addAll(imgList);
          }
        } else {
          starList.add('0');
        }

        if (y > 0) {
          x = x / y;
        }
        storeData['STARlength'] = y;
        storeData['STARage'] = x.toStringAsFixed(1);
        storeData['STARlist'] = starList;
        storeData['docId'] = docId;
        userDataList.add(storeData);
      } else {
        print('해당 문서를 찾을 수 없습니다.');
      }
    } catch (e) {
      print('데이터를 불러오는 중 오류가 발생했습니다: $e');
    }
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
      body:
      Container(
        child: FutureBuilder<List<Widget>?>(
          future: _fetchAllUserData(widget.docId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                children: [
                  CircularProgressIndicator(),
                ],
              ); // Display a loading indicator if the future is not resolved yet.
            } else {
              return ListView.builder(
                itemCount: userDataList.length,
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
                                  'assets/storePageIMG/${imagePaths[index]}',
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
                                Text('${userDataList[index]['KEYWORD1']}   l',
                                  style: TextStyle(fontSize: 10, color: Colors
                                      .grey),),
                                SizedBox(width: 8,),
                                Text('${userDataList[index]['S_ADDR2']}',
                                    style: TextStyle(fontSize: 10, color: Colors
                                        .grey)),
                              ],
                            ),
                            Text('${userDataList[index]['S_NAME']}',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
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
                                Text('${userDataList[index]['STARage']}',
                                  style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(width: 3,),
                                Text('(${userDataList[index]['STARlength']})',
                                    style: TextStyle(fontSize: 10, color: Colors
                                        .grey)),
                              ],
                            ),
                            Text(''),
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
                                      Text(' 공지',
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

                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(30),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('메뉴', style: TextStyle(fontSize: 20,
                                            fontWeight: FontWeight.bold),),
                                        TextButton(onPressed: (){
                                          Navigator.push(context, MaterialPageRoute(
                                              builder: (_) => TabBarEx(initialTabIndex: 1)));
                                        }, child: Text('전체보기 >',style: TextStyle(fontSize: 12,color: Colors.grey),))
                                      ],
                                    ),
                                  ),
                                  underlineBox(2.0),
                                  Container(
                                    padding: EdgeInsets.only(left: 30,top: 10,right: 30,bottom: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Food', style: TextStyle(fontSize: 15,
                                            fontWeight: FontWeight.bold),),
                                        TextButton(onPressed: (){}, child: Text('9,000~ 4,0000원',style: TextStyle(fontSize: 15,color: Colors.grey),))
                                      ],
                                    ),
                                  ),
                                  underlineBox(1.0),
                                  Container(
                                    padding: EdgeInsets.only(left: 30,top: 10,right: 30,bottom: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('멀봐 ', style: TextStyle(fontSize: 15,
                                            fontWeight: FontWeight.bold),),
                                        TextButton(onPressed: (){}, child: Text('6816351원',style: TextStyle(fontSize: 15,color: Colors.grey),))
                                      ],
                                    ),
                                  ),
                                  underlineBox(1.0),
                                  Container(
                                    padding: EdgeInsets.only(left: 30,top: 10,right: 30,bottom: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('멀봐 ', style: TextStyle(fontSize: 15,
                                            fontWeight: FontWeight.bold),),
                                        TextButton(onPressed: (){}, child: Text('6816351원',style: TextStyle(fontSize: 15,color: Colors.grey),))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            underlineBox(5.0),

                            //사진--------------------

                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(30),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('사진', style: TextStyle(fontSize: 20,
                                            fontWeight: FontWeight.bold),),
                                        TextButton(onPressed: (){
                                          Navigator.push(context, MaterialPageRoute(
                                              builder: (_) => TabBarEx(initialTabIndex: 2)));
                                        }, child: Text('전체보기 >',style: TextStyle(fontSize: 12,color: Colors.grey),))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.asset(
                                              'assets/storePageIMG/BEKMIWOO1.jpeg',
                                              width: 125,
                                            ),
                                            SizedBox(width: 3,),
                                            Image.asset(
                                              'assets/storePageIMG/BEKMIWOO2.jpeg',
                                              width: 125,
                                            ),
                                            SizedBox(width: 3,),
                                            Image.asset(
                                              'assets/storePageIMG/BEKMIWOO3.jpeg',
                                              width: 125,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 7,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.asset(
                                              'assets/storePageIMG/BEKMIWOO4.jpeg',
                                              width: 125,
                                            ),
                                            SizedBox(width: 3,),
                                            Image.asset(
                                              'assets/storePageIMG/BEKMIWOO5.jpeg',
                                              width: 125,
                                            ),
                                            SizedBox(width: 3,),
                                            Image.asset(
                                              'assets/storePageIMG/BEKMIWOO6.jpeg',
                                              width: 125,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10,)
                                      ],
                                    ),
                                  )






                                ],
                              ),
                            ),

                            underlineBox(5.0),
                            //지도
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Text('지도', style: TextStyle(fontSize: 20,
                                          fontWeight: FontWeight.bold),),
                                      SizedBox(
                                        width: 400,
                                        height: 400,
                                        child: GoogleMapPage(initialAddress: '${userDataList[index]['S_ADDR1']} ${userDataList[index]['S_ADDR2']}${userDataList[index]['S_ADDR3']}'), // 여기에 함수를 호출하여 내용을 표시
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),

                            underlineBox(5.0),
                            //상세정보
                            Container(
                              padding: EdgeInsets.all(30),
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text('상세정보', style: TextStyle(fontSize: 20,
                                          fontWeight: FontWeight.bold),),
                                      SizedBox(height: 20,),
                                      Container(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          children: [
                                            Text('주저리주저리'),
                                            Text('주저리주저리'),
                                            Text('주저리주저리'),
                                            Text('주저리주저리'),
                                            Text('주저리주저리'),
                                            Text('주저리주저리'),
                                            Text('주저리주저리'),
                                            Text('주저리주저리'),
                                            Text('주저리주저리'),
                                            Text('주저리주저리'),
                                            Text('주저리주저리'),
                                            Text('주저리주저리'),
                                            Text('주저리주저리'),
                                            Text('주저리주저리'),
                                          ],
                                        ),
                                      ),
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
                },
              );
            }
          },
        ),
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



  void _onPageChanged() {
    setState(() {
      currentPage = _pageController.page!.toInt(); // 현재 페이지 업데이트
    });
  }

/*  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged); // 리스너 제거
    _pageController.dispose();
    super.dispose();
  }*/

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
  List<String> imgtest = ['BEKMIWOO1.jpeg','BEKMIWOO2.jpeg','BEKMIWOO3.jpeg','BEKMIWOO4.jpeg','BEKMIWOO5.jpeg','BEKMIWOO6.jpeg','BEKMIWOO7.jpeg',];
  final List<Map<String, dynamic>> storeList = [
    {
      '제목': '가게이름',
      '별점': '4.8',
      '설명': '가게가 착하고 사장님이 맛있어요\n 가게가 착하고 사장님이 맛있어요',
      '주소': '인천광역시 부평구 부평1동 부흥로 264 동아웰빙타운관리단 9층',
      '카테고리': '레스토랑'
    }
  ];

  final PageController _pageController = PageController();
  final List<String> imagePaths = [ //음식점 사진 리스트
  ];


}




