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
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {

  double average = 0.0; // STAR 평균값을 저장할 변수
  List<int> starLengthValues = []; // STAR 길이 숫자를 저장할 변수

  Future<void> calculateStarAverage() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot starSnapshot = await firestore.collection("T3_STORE_TBL").doc("STAR").get();

    if (starSnapshot.exists) {
      Map<String, dynamic> starData = starSnapshot.data() as Map<String, dynamic>;

      String starValues = starData['starValues'];
      List<int> starList = starValues.split('').map(int.parse).toList();

      // STAR 값의 평균 계산
      for (int value in starList) {
        average += value;
      }
      average /= starList.length;

      // STAR 길이만큼 변수에 저장
      starLengthValues = List.generate(starList.length, (index) => index + 1);
    } else {
      print("STAR 문서가 존재하지 않습니다.");
    }
  }



  Widget _listUser() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("T3_STORE_TBL").orderBy("timestamp", descending: true).snapshots(),
      ///////////////////users/////////////////////
      //게시글 정렬 후 출력 (orderBy(descending: ,))
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap){
        if(!snap.hasData) {
          return Transform.scale(
            scale: 0.1,
            child: CircularProgressIndicator(strokeWidth: 20),
          );
        }
        return ListView(
          children: snap.data!.docs.map(
                (DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 20),
                        Container(
                          width: 80,
                          height: 110, // 원하는 높이 설정
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Image.asset(
                            'assets/storePageIMG/${data['S_IMG']}',
                            fit: BoxFit.cover,
                          ),
                        ),

                        SizedBox(width: 13),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 280, // 원하는 너비 설정
                              child: InkWell(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${data['S_NAME']}',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    Text('${data['S_SILPLEMONO']}'),
                                    Row(
                                      children: [
                                        Icon(Icons.star, size: 25, color: Colors.yellow[600]),
                                        Text(
                                          '4.7',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          '(123)',
                                          style: TextStyle(fontSize: 11, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${data['S_ADDR1']} ${data['S_ADDR2']} ${data['S_ADDR3']}',
                                      style: TextStyle(fontSize: 11, color: Colors.grey),
                                    ),
                                    Text(
                                      '${data['S_TIME']}',
                                      style: TextStyle(fontSize: 11, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => DetailPage()),
                                  );
                                },
                              ),
                            ),

                            SizedBox(height: 20),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {

                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFFFF6347),
                                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                  ),
                                  child: Text('13:00'),
                                ),
                                SizedBox(width: 6),
                                ElevatedButton(
                                  onPressed: () {

                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFFFF6347),
                                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                  ),
                                  child: Text('18:00'),
                                ),
                                SizedBox(width: 6),
                                ElevatedButton(
                                  onPressed: () {

                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFFFF6347),
                                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                  ),
                                  child: Text('21:00'),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          ).toList(),
        );

      },
    );
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
                //날짜 검색 페이지 로갔따가 돌아오기
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
            Container(
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
                            //검색 추천순 만들기
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
            ),
            SizedBox(height: 10,),
            Expanded(child: _listUser())
          ],
        ),
      ),
    );
  }
}
