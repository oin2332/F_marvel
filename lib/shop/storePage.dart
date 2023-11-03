import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:food_marvel/shop/reservationPage.dart';
import 'package:food_marvel/shop/tabBar.dart';

import '../map/maptotal.dart';
import '../search/headSearch.dart';
import '../search/navSearch.dart';
import 'detailpage.dart';
import 'list.dart';

class ModalData extends ChangeNotifier {


  int currentStep = 1;
  String selectedValue = '';

  void setCurrentStep(int step) {
    currentStep = step;
    notifyListeners();
  }

  void setSelectedValue(String value) {
    selectedValue = value;
    notifyListeners();
  }
}

class StorePage extends StatefulWidget {
  StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {

  @override
  void initState() {
    super.initState();
    fetchAllUserData();
  }

  List<Map<String, dynamic>> userDataList = [];

  void fetchAllUserData() async {
    try {
      QuerySnapshot storeSnapshot = await FirebaseFirestore.instance
          .collection('T3_STORE_TBL')
          .get();


      if (storeSnapshot.docs.isNotEmpty) {
        for (var storeDoc in storeSnapshot.docs) {
          Map<String, dynamic> storeData = storeDoc.data() as Map<String, dynamic>;
          String docId = storeDoc.id;

          // 해당 상점의 별점 정보 가져오기
          QuerySnapshot starSnapshot = await FirebaseFirestore.instance
              .collection('T3_STORE_TBL')
              .doc(docId)
              .collection('T3_STAR_TBL')
              .get();

          List<String> starList = [];
          double x = 0;
          int y = 0;

          if (starSnapshot.docs.isNotEmpty) {
            for (var starDoc in starSnapshot.docs) {
              Map<String, dynamic> starData = starDoc.data() as Map<String, dynamic>;

              starData.forEach((key, value) {
                if (value is String) {
                  // 문자열을 숫자로 변환하여 평균을 계산합니다
                  double numericValue = double.parse(value);
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
          userDataList.add(storeData);
        }
        setState(() {

        });
      } else {
        print('상점 데이터를 찾을 수 없습니다.');

      }
    } catch (e) {
      print('데이터를 불러오는 중 오류가 발생했습니다: $e');

    }
  }
  bool isSortedByRating = false;
  void sortListByRating() {
    if (isSortedByRating) {
      // 이미 정렬되어 있다면, 역순으로 정렬합니다.
      userDataList.sort((a, b) {
        double ratingA = double.parse(a['STARage'] ?? '0');
        double ratingB = double.parse(b['STARage'] ?? '0');
        return ratingB.compareTo(ratingA);
      });
    } else {
      // 정렬되어 있지 않다면, 별점순으로 정렬합니다.
      userDataList.sort((a, b) {
        double ratingA = double.parse(a['STARage'] ?? '0');
        double ratingB = double.parse(b['STARage'] ?? '0');
        return ratingA.compareTo(ratingB);
      });
    }
    isSortedByRating = !isSortedByRating; // 토글 상태 업데이트
  }

  void _showModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 900, // 원하는 높이로 설정
          child: Container(
            child: Column(
              children: [
                Text('이곳에 모달 내용을 원하는 형식으로 배치합니다.'),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 모달 닫기
                  },
                  child: Text('닫기'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }




  //----------------------------------------------------------



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

  Widget _menubutton(String text) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // 타원형 모양을 위한 값
        ),
        primary: Colors.white, // 배경색을 흰색으로 설정
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black, // 글씨를 검은색으로 설정
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DB 카테고리 이름'),
        backgroundColor: const Color(0xFFFF6347),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 10),
            InkWell( // InkWell을 사용하여 터치 이벤트 처리
              onTap:(){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ReservationPage()));

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(width: 20),
                  Icon(Icons.calendar_today_outlined),
                  SizedBox(width: 30),
                  Text('날짜'),
                  SizedBox(width: 30),
                  Text('시간'),
                  SizedBox(width: 30),
                  Text('2명'),
                  SizedBox(width: 100),
                  IconButton(onPressed: () {}, icon: Icon(Icons.keyboard_arrow_down)),
                ],
              ),
            ),
            underlineBox(0.8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [// 지도 / 카테고리(옵션) 변경 아이콘
                IconButton(onPressed: (){   Navigator.push(context, MaterialPageRoute(builder: (context) => GooGleMap()));}, icon:  Icon(Icons.map_outlined),), //지도
                IconButton(onPressed: (){}, icon: Icon(Icons.tune_rounded)), // 옵션변경(카테고리)
                SingleChildScrollView( // 스크롤 가능한 버튼 리스트
                  scrollDirection: Axis.horizontal, // 수평 스크롤
                  child: Row(
                    children: [
                      _menubutton('내주변'),
                      SizedBox(width: 20),
                      _menubutton('지역'),
                      SizedBox(width: 20),
                      _menubutton('다른 버튼'),
                      // 필요한 만큼 버튼 추가
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 5,),
            underlineBox(5.0),
            /*Container( 나중에 당장 급한게 많다 나중에 시간남으면 확인
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 20,),
                        Text('@개', style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 18),),
                        Text('의 매장', style: TextStyle(color: Colors.grey,fontSize: 18),),

                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: (){
                            sortListByRating();
                          },
                          child: Row(
                            children: [
                              Icon(Icons.view_headline),
                              Text('추천순'),
                              Icon(Icons.expand_more),
                              SizedBox(width: 15,),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),*/
            SizedBox(height: 10,),
            Expanded(child: ListsShop(searchResults: [],))
          ],
        ),
      ),
    );
  }
}
