import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_marvel/map/mini.dart';
import 'package:food_marvel/shop/reservationAdd.dart';
import 'package:food_marvel/shop/tabBar.dart';
import 'package:food_marvel/shop/test.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main/mainPage.dart';
//import '../reservation/function/bookmark.dart';
import '../reservation/function/bookmark.dart';
import '../user/userModel.dart';
import '../user/userUnlogin.dart';
import 'loading.dart';

class DetailPage extends StatefulWidget {

  final String docId; // docId를 받을 변수 추가

  DetailPage({required this.docId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}
class _DetailPageState extends State<DetailPage> {
  bool isBookmarked = false;
  String? uId;
  String? sId;
  final GlobalKey mapkey = GlobalKey();
  @override
  void initState() {
    super.initState();
    initializeDateFormatting("ko_KR", null);
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    uId = userModel.userId;

    if (uId != null) {
      checkBookmarkStatus(uId!, widget.docId).then((bookmarkStatus) {
        setState(() {
          isBookmarked = bookmarkStatus;
        });
      });
    } else {
      // uId가 null이면 북마크 상태를 초기화하거나 다른 처리를 수행
      // 예: 초기 북마크 상태를 false로 설정
      setState(() {
        isBookmarked = false;
      });
    }
  }

  List<Map<String, dynamic>> userDataList = [];
  List<String> Path = [];
  List<String> menuImg = [];
  Map<String, dynamic> memuMap = {};
  Map<String, dynamic> icon = {};
  Map<String, dynamic> time = {};

  Future<void> _fetchAllUserData(String docId) async {
    try {
      DocumentSnapshot storeSnapshot = await FirebaseFirestore.instance
          .collection('T3_STORE_TBL')
          .doc(docId)
          .get();

      if (storeSnapshot.exists) {
        Map<String, dynamic> storeData =
        storeSnapshot.data() as Map<String, dynamic>;

        // 해당 상점의 별점 정보 가져오기
        QuerySnapshot starSnapshot = await FirebaseFirestore.instance
            .collection('T3_STORE_TBL')
            .doc(docId)
            .collection('T3_STAR_TBL')
            .get();

        // 아이콘이름 가져오기
        QuerySnapshot convenienceSnapshot = await FirebaseFirestore.instance
            .collection('T3_STORE_TBL')
            .doc(docId)
            .collection('T3_CONVENIENCE_TBL')
            .get();
        if (convenienceSnapshot.docs.isNotEmpty) {
          icon = convenienceSnapshot.docs.first.data() as Map<String, dynamic>;
        }

        // 시간 데이터 가져오기
        QuerySnapshot timeSnapshot = await FirebaseFirestore.instance
            .collection('T3_STORE_TBL')
            .doc(docId)
            .collection('T3_TIME_TBL')
            .get();

        QuerySnapshot monuImgList = await FirebaseFirestore.instance
            .collection('T3_STORE_TBL')
            .doc(docId)
            .collection('T3_menuimg_TBL')
            .get();

        if (monuImgList.docs.isNotEmpty) {
          List<dynamic> menuimglist = monuImgList.docs[0].get('r_img_urls'); // 첫 번째 문서의 r_img_urls 필드에서 데이터 가져오기

          // r_img_urls의 각 항목을 imagePaths에 추가
          menuimglist.forEach((imageUrl) {
            if (imageUrl is String) {
              menuImg.add(imageUrl);
            }
          });
        } else {
          print('이미지 목록이 비어 있습니다.');
        }


        if (timeSnapshot.docs.isNotEmpty) {
          time = timeSnapshot.docs.first.data() as Map<String, dynamic>;
        }

        //이미지 가져오기
        QuerySnapshot storeImgList = await FirebaseFirestore.instance
            .collection('T3_STORE_TBL')
            .doc(docId)
            .collection('T3_STOREIMG_TBL')
            .get();


        List<dynamic> imgstore = storeImgList.docs[0].get('r_img_urls'); // 첫 번째 문서의 r_img_urls 필드에서 데이터 가져오기

        // r_img_urls의 각 항목을 imagePaths에 추가
        imgstore.forEach((imageUrl) {
          if (imageUrl is String) {
            Path.add(imageUrl);
          }
        });





        // 메뉴 가져오기
        QuerySnapshot menuSnapshot = await FirebaseFirestore.instance
            .collection('T3_STORE_TBL')
            .doc(docId)
            .collection('T3_MENU_TBL')
            .get();

        if (menuSnapshot.docs.isNotEmpty) {
          memuMap = menuSnapshot.docs.first.data() as Map<String, dynamic>;
        }


        List<String> starList = [];
        double x = 0;
        int y = -1;

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

        // 시간 데이터 가져오기


        userDataList.add(storeData);
      } else {
        print('해당 문서를 찾을 수 없습니다.');
      }
    } catch (e) {
      print('데이터를 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  Future<bool> checkBookmarkStatus(String userId, String docId) async {
    try {
      FirebaseFirestore fs = FirebaseFirestore.instance;
      CollectionReference stores = fs.collection("T3_STORE_TBL");
      DocumentReference bookmarkRef = stores.doc(docId).collection(
          "T3_BOOKMARK_TBL").doc(userId);

      DocumentSnapshot bookmarkDoc = await bookmarkRef.get();

      return bookmarkDoc.exists;
    } catch (e) {
      print('북마크 상태 확인 중 오류 발생: $e');
      return false; // 에러 시 기본값으로 false 반환
    }
  }

  void _scrollToMap() { // 지도보이게끔 이동시켜주는 버튼기능
    Scrollable.ensureVisible(
      mapkey.currentContext!,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: 0.4, // 조절 가능한 값 (0에서 1 사이)
    );
  }


  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context);
    String? userId = userModel.userId;
    uId = userId;

    sId = widget.docId;

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage())
              );
            },
          ),
          actions: [
            IconButton(
              icon: isBookmarked ? Image.asset(
                'assets/bookmark-removebg-preview.png',)
                  : Image.asset('assets/bookmark2-removebg-preview.png',),
              onPressed: () {
                if (uId == null) {
                  // 사용자가 로그인하지 않은 경우
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("로그인이 필요합니다"),
                        content: Text("북마크를 사용하려면 먼저 로그인해야 합니다."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // 다이얼로그 닫기
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserUnlogin()),
                              );
                            },
                            child: Text("로그인하러 가기"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // 다이얼로그 닫기
                            },
                            child: Text("닫기"),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // 사용자가 로그인한 경우 북마크 작업 수행
                  addBookmark(uId!, sId!).then((_) {
                    // 북마크 상태를 확인하고 아이콘을 업데이트
                    checkBookmarkStatus(uId!, sId!).then((bookmarkStatus) {
                      setState(() {
                        isBookmarked = bookmarkStatus;
                      });
                    });
                  });
                }
              },
            ),
          ],
        ),
        body:
        Container(
          child: FutureBuilder<void>(
            future: _fetchAllUserData(widget.docId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingSpinner(),
                  ],
                ); // Display a loading indicator if the future is not resolved yet.
              } else {
                return ListView.builder(
                  itemCount: userDataList.length,
                  itemBuilder: (BuildContext context, int index) {
                    String addrsum = '${userDataList[index]['S_ADDR1']} ${userDataList[index]['S_ADDR2']}${userDataList[index]['S_ADDR3']}';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 300,
                          child: Testimg(docId: widget.docId,), //이미지 슬라이더
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
                                      style: TextStyle(
                                          fontSize: 10, color: Colors
                                          .grey)),
                                ],
                              ),
                              Text('${userDataList[index]['S_NAME']}',
                                style: TextStyle(fontSize: 22,
                                    fontWeight: FontWeight.bold),),
                              SizedBox(height: 8,),
                              Row(
                                children: [
                                  Container(
                                    child: RatingBarIndicator(
                                      rating: double.parse(userDataList[index]['STARage']),
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 25.0,
                                      direction: Axis.horizontal,
                                    ),
                                  ),
                                  SizedBox(width: 7,),
                                  Text('${userDataList[index]['STARage']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),),
                                  SizedBox(width: 3,),
                                  Text('(${userDataList[index]['STARlength']})',
                                      style: TextStyle(
                                          fontSize: 10, color: Colors
                                          .grey)),
                                ],
                              ),
                              SizedBox(height: 15,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      await launch(
                                          "tel: ${userDataList[index]['S_NUMBER']}");
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .all(Colors.white),
                                      side: MaterialStateProperty.all(
                                          BorderSide(
                                              color: Colors.black, width: 1)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.call, size: 18,
                                              color: Colors.black),
                                          SizedBox(width: 3),
                                          Text('전화하기', style: TextStyle(
                                              color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  TextButton(
                                    onPressed: () {
                                      _scrollToMap(); // 버튼이 눌릴 때 _scrollToMap 메소드 호출
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.location_on, size: 18, color: Colors.black,),
                                          SizedBox(width: 3,),
                                          Text('위치보기', style: TextStyle(color: Colors.black),),
                                        ],
                                      ),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.white),
                                      side: MaterialStateProperty.all(
                                        BorderSide(color: Colors.black, width: 1),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        underlineBox(5.0),
                        //예약 일시 부분
                        ReservationAdd(addr: addrsum,
                          sName: userDataList[index]['S_NAME'],
                          doc: widget.docId,
                          time: time,
                          shopId: userDataList[index]['S_ID'],
                        ),
                        underlineBox(5.0),
                        //홈 메뉴 사진 리뷰
                        Container(
                          child: Column(
                            children: [
                              SizedBox(height: 15,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: [
                                  TextButton(onPressed: () {

                                  }, child: Text('홈', style: TextStyle(
                                      color: Colors.black),),),
                                  TextButton(onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (_) =>
                                          TabBarEx(initialTabIndex: 1,
                                            shopInfo : userDataList!,
                                            imgPathList :Path!,
                                            menuImgList : menuImg!,
                                            memuMap : memuMap!,),
                                    ));
                                  }, child: Text('메뉴', style: TextStyle(
                                      color: Colors.black),),),
                                  TextButton(onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (_) =>
                                          TabBarEx(
                                            initialTabIndex: 2,
                                            shopInfo : userDataList!,
                                            imgPathList :Path!,
                                            menuImgList : menuImg!,
                                            memuMap : memuMap!,
                                          ),
                                    ));
                                  }, child: Text('사진', style: TextStyle(
                                      color: Colors.black),),),
                                  TextButton(onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (_) =>
                                          TabBarEx(initialTabIndex: 3,
                                            shopInfo : userDataList!,
                                            imgPathList :Path!,
                                            menuImgList : menuImg!,
                                            memuMap : memuMap!,),
                                    ));
                                    ;
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
                                      color: Color(0xFFFF6347),
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
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
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
                                                Text(
                                                  getThisMonth() + '1일 14:00',
                                                  style: TextStyle(
                                                      color: Color(0xFFFF6347),
                                                      fontWeight: FontWeight
                                                          .bold,
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
                                                Text(
                                                  getThisMonth() + '15일 14:00',
                                                  style: TextStyle(
                                                      color: Color(0xFFFF6347),
                                                      fontWeight: FontWeight
                                                          .bold,
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
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text('공지',
                                          style: TextStyle(fontSize: 20,
                                              fontWeight: FontWeight.bold),),
                                        SizedBox(height: 10,),
                                        Container(
                                            width: 300,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .start,
                                              children: [
                                                Flexible(
                                                    child: RichText(
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                      maxLines: 6,
                                                      strutStyle: StrutStyle(
                                                          fontSize: 16.0),
                                                      text: TextSpan(
                                                          text: '${userDataList[index]['S_MEMO']}',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black,
                                                              height: 1.4,
                                                              fontSize: 12.0,
                                                              fontFamily: 'NanumSquareRegular')),
                                                    )),
                                              ],
                                            ))
                                      ],
                                    )
                                  ],
                                ),
                              ),


                              underlineBox(5.0),
                              //편의시설--------------------
                              Container(
                                padding: EdgeInsets.only(top: 30,left: 30,bottom: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '편의시설',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 30,right: 30,bottom: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    SizedBox(height: 32),
                                    Wrap(
                                      spacing: 10, // 가로 방향의 마진
                                      runSpacing: 10, // 세로 방향의 마진
                                      children: [
                                        if (icon['S_STAIRS'] == true)
                                          Container(
                                            margin: EdgeInsets.all(4),
                                            // 각 아이콘과 텍스트의 마진
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                    'assets/amenities/stairs.png',
                                                    width: 50,
                                                    fit: BoxFit.contain),
                                                Text('계단 있어요'),
                                              ],
                                            ),
                                          ),
                                        if(icon['S_STAIRS'] == false)
                                          Container(
                                            margin: EdgeInsets.all(4),
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                    'assets/amenities/stairs.png',
                                                    width: 50,
                                                    fit: BoxFit.contain),
                                                Text('계단 없어요'),
                                              ],
                                            ),
                                          ),
                                        if(icon['S_FLOOR'])
                                          Container(
                                            margin: EdgeInsets.all(4),
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                    'assets/amenities/floor.png',
                                                    width: 50,
                                                    fit: BoxFit.contain),
                                                Text('${icon['S_FLOORtext']}'),
                                              ],
                                            ),
                                          ),
                                        if (icon['S_KID'])
                                          Container(
                                            margin: EdgeInsets.all(4),
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                    'assets/amenities/kid.png',
                                                    width: 50,
                                                    fit: BoxFit.contain),
                                                Text('키즈존'),
                                              ],
                                            ),
                                          ),
                                        if (icon['S_NOKID'])
                                          Container(
                                            margin: EdgeInsets.all(4),
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                    'assets/amenities/nokid.png',
                                                    width: 50,
                                                    fit: BoxFit.contain),
                                                Text('NO키즈존'),
                                              ],
                                            ),
                                          ),
                                        if(icon['S_PARKING'])
                                          Container(
                                            margin: EdgeInsets.all(4),
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                    'assets/amenities/parking.png',
                                                    width: 50,
                                                    fit: BoxFit.contain),
                                                Text('주차'),
                                              ],
                                            ),
                                          ),
                                        if(icon['S_TOILET'])
                                          Container(
                                            margin: EdgeInsets.all(4),
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                    'assets/amenities/toilet.png',
                                                    width: 50,
                                                    fit: BoxFit.contain),
                                                Text('화장실'),
                                              ],
                                            ),
                                          ),
                                        if(icon['S_ELEVA'])
                                          Container(
                                            margin: EdgeInsets.all(4),
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                    'assets/amenities/elevator.png',
                                                    width: 50,
                                                    fit: BoxFit.contain),
                                                Text('엘리베이터'),
                                              ],
                                            ),
                                          ),
                                        if(icon['S_GROUP'])
                                          Container(
                                            margin: EdgeInsets.all(4),
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                    'assets/amenities/group.png',
                                                    width: 50,
                                                    fit: BoxFit.contain),
                                                Text('단체가능'),
                                              ],
                                            ),
                                          ),
                                        if(icon['S_WR'])
                                          Container(
                                            margin: EdgeInsets.all(4),
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                    'assets/amenities/takeout.png',
                                                    width: 50,
                                                    fit: BoxFit.contain),
                                                Text('포장가능'),
                                              ],
                                            ),
                                          ),

                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              underlineBox(5.0),
                              //메뉴--------------------
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(30),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text(
                                            '메뉴', style: TextStyle(fontSize: 20,
                                              fontWeight: FontWeight.bold),),
                                          TextButton(onPressed: () {
                                            Navigator.push(
                                                context, MaterialPageRoute(
                                              builder: (_) =>
                                                  TabBarEx(initialTabIndex: 1,
                                                    shopInfo : userDataList!,
                                                    imgPathList :Path!,
                                                    menuImgList : menuImg!,
                                                    memuMap : memuMap!,),
                                            ));
                                          },
                                              child: Text('전체보기 >',
                                                style: TextStyle(fontSize: 12,
                                                    color: Colors.grey),))
                                        ],
                                      ),
                                    ),
                                    underlineBox(2.0),
                                    Container(
                                      padding: EdgeInsets.only(left: 30,
                                          top: 10,
                                          right: 30,
                                          bottom: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text(memuMap['S_MENU1'],
                                            style: TextStyle(fontSize: 15,
                                                fontWeight: FontWeight.bold),),
                                          TextButton(onPressed: () {},
                                              child: Text(memuMap['S_MENU1-1'],
                                                style: TextStyle(fontSize: 15,
                                                    color: Colors.grey),))
                                        ],
                                      ),
                                    ),
                                    underlineBox(1.0),
                                    Container(
                                      padding: EdgeInsets.only(left: 30,
                                          top: 10,
                                          right: 30,
                                          bottom: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text(memuMap['S_MENU2'],
                                            style: TextStyle(fontSize: 15,
                                                fontWeight: FontWeight.bold),),
                                          TextButton(onPressed: () {},
                                              child: Text(memuMap['S_MENU2-1'],
                                                style: TextStyle(fontSize: 15,
                                                    color: Colors.grey),))
                                        ],
                                      ),
                                    ),
                                    underlineBox(1.0),
                                    Container(
                                      padding: EdgeInsets.only(left: 30,
                                          top: 10,
                                          right: 30,
                                          bottom: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text(memuMap['S_MENU3'],
                                            style: TextStyle(fontSize: 15,
                                                fontWeight: FontWeight.bold),),
                                          TextButton(onPressed: () {},
                                              child: Text(memuMap['S_MENU3-1'],
                                                style: TextStyle(fontSize: 15,
                                                    color: Colors.grey),))
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
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text(
                                            '사진', style: TextStyle(fontSize: 20,
                                              fontWeight: FontWeight.bold),),
                                          TextButton(onPressed: () {
                                            Navigator.push(
                                                context, MaterialPageRoute(
                                              builder: (_) =>
                                                  TabBarEx(initialTabIndex: 2,
                                                    shopInfo : userDataList!,
                                                    imgPathList :Path!,
                                                    menuImgList : menuImg!,
                                                    memuMap : memuMap!,),
                                            ));
                                          },
                                              child: Text('전체보기 >',
                                                style: TextStyle(fontSize: 12,
                                                    color: Colors.grey),))
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceEvenly,
                                            children: [
                                              Image.network(
                                                Path[0],
                                                width: 125,
                                                height: 100,
                                              ),
                                              SizedBox(width: 3,),
                                              Image.network(
                                                Path[1],
                                                width: 125,
                                                height: 100,
                                              ),
                                              SizedBox(width: 3,),
                                              Image.network(
                                                Path[2],
                                                width: 125,
                                                height: 100,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 7,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceEvenly,
                                            children: [
                                              Image.network(
                                                Path[3],
                                                width: 125,
                                                height: 100,
                                              ),
                                              SizedBox(width: 3,),
                                              Image.network(
                                                Path[4],
                                                width: 125,
                                                height: 100,
                                              ),
                                              SizedBox(width: 3,),
                                              Image.network(
                                                Path[5],
                                                width: 125,
                                                height: 100,
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
                                key: mapkey,
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          '지도',
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 400,
                                          height: 400,
                                          child: GoogleMapPage(
                                            initialAddress:
                                            '${userDataList[index]['S_ADDR1']} ${userDataList[index]['S_ADDR2']}${userDataList[index]['S_ADDR3']}',
                                          ),
                                        ),
                                      ],
                                    ),
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
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          '상세정보', style: TextStyle(fontSize: 20,
                                            fontWeight: FontWeight.bold),),
                                        SizedBox(height: 20,),
                                        Container(
                                          padding: EdgeInsets.all(20),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text('전화번호', style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),),
                                              SizedBox(height: 5,),
                                              Text(
                                                  '${userDataList[index]['S_NUMBER']}'),
                                              SizedBox(height: 25,),

                                              Text('매장소개', style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),),
                                              SizedBox(height: 5,),
                                              Container(
                                                  width: 250,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .start,
                                                    children: [
                                                      Flexible(
                                                          child: RichText(
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            maxLines: 5,
                                                            strutStyle: StrutStyle(
                                                                fontSize: 16.0),
                                                            text: TextSpan(
                                                                text: '${userDataList[index]['S_MEMO']}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    height: 1.4,
                                                                    fontSize: 12.0,
                                                                    fontFamily: 'NanumSquareRegular')),
                                                          )),
                                                    ],
                                                  )),
                                              SizedBox(height: 25,),

                                              Text('안내 및 유의사항',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),),
                                              SizedBox(height: 5,),
                                              Container(
                                                  width: 300,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .start,
                                                    children: [
                                                      Flexible(
                                                          child: RichText(
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            maxLines: 5,
                                                            strutStyle: StrutStyle(
                                                                fontSize: 16.0),
                                                            text: TextSpan(
                                                                text: '${userDataList[index]['S_RE_MEMO']}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    height: 1.4,
                                                                    fontSize: 12.0,
                                                                    fontFamily: 'NanumSquareRegular')),
                                                          )),
                                                    ],
                                                  )),
                                              SizedBox(height: 25,),

                                              Text('홈페이지', style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),),
                                              SizedBox(height: 5,),
                                              Container(
                                                  width: 300,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .start,
                                                    children: [
                                                      Flexible(
                                                          child: RichText(
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            maxLines: 5,
                                                            strutStyle: StrutStyle(
                                                                fontSize: 16.0),
                                                            text: TextSpan(
                                                                text: '${userDataList[index]['S_HOMEPAGE']}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    height: 1.4,
                                                                    fontSize: 12.0,
                                                                    fontFamily: 'NanumSquareRegular')),
                                                          )),
                                                    ],
                                                  )),
                                              SizedBox(height: 40,)

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
}