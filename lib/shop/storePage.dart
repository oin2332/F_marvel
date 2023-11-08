import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:food_marvel/shop/reservationPage.dart';
import 'package:food_marvel/shop/tabBar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../map/maptotal.dart';
import '../search/headSearch.dart';
import '../search/navSearch.dart';
import 'detailpage.dart';
import 'list.dart';

class ModalData extends ChangeNotifier {

  int currentStep = 1;
  String selectedValue = '';
  int numberOfPeople = 2; // 기본값 설정


  void setCurrentStep(int step) {
    currentStep = step;
    notifyListeners();
  }

  void setSelectedValue(String value) {
    selectedValue = value;
    notifyListeners();
  }

  void setNumberOfPeople(int value) {
    numberOfPeople = value;
    notifyListeners();
  }
}

class StorePage extends StatefulWidget {
  final String category;

  StorePage(this.category, {Key? key}) : super(key: key);

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {

  String? setTime; // 선택된 시간
  String? setday; // 선택된 날짜
  String? setperson; // 선택된 인원 수


  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    currentTime = DateFormat.H().format(now);

    // 이곳에서 변수를 초기화합니다.
    setTime = ''; // 초기에는 빈 문자열
    setday = ''; // 초기에는 빈 문자열
    setperson = ''; // 초기에는 빈 문자열
  }

  String getWeekdayFromDate(DateTime date) {
    final weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final weekdayIndex = date.weekday - 1; // 요일은 1부터 7까지이므로 인덱스로 변환
    return weekdays[weekdayIndex];
  }

  String currentTime = '';

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
        title: Text('${widget.category}'),
        backgroundColor: const Color(0xFFFF6347),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 10),
            InkWell( // InkWell을 사용하여 터치 이벤트 처리
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ReservationPage())).then((data) {
                  if (data != null) {
                    setState(() {
                      setTime = data['selectedDate'];
                      setday = data['selectedTime'];
                      setperson = data['selectedNumber'];
                    });
                  }
                });
              },
              child: Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(width: 20),
                    Icon(Icons.calendar_today_outlined),
                    SizedBox(width: 30),
                    Text('날짜: ${setday ?? '날짜를 선택하세요'}'),
                    SizedBox(width: 30),
                    Text('시간: $setTime : 00'), // 현재 시간 표시
                    SizedBox(width: 30),
                    Text('인원: $setperson명'), // 인원 수 표시
                    Icon(Icons.keyboard_arrow_down),

                  ],
                ),
              ),
            ),
            underlineBox(0.8),

            Row(
              children: [
                Padding(
                    padding:
                    const EdgeInsets.only(left: 10.0, bottom: 10.0),
                    child: Container(
                      height: 24,
                      child: Row(
                          children :[
                            IconButton(onPressed: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => GooGleMap()));
                              },
                              icon:  Icon(Icons.map_outlined),),
                            SizedBox(width: 5,),
                            IconButton(onPressed: (){}, icon: Icon(Icons.tune_rounded)),
                          ]
                      ),
                    )
                ),


                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _menubutton('내주변'),
                          SizedBox(width: 20),
                          _menubutton('지역'),
                          SizedBox(width: 20),
                          _menubutton('몰라'),
                          SizedBox(width: 20),
                          _menubutton('test'),
                          SizedBox(width: 20),
                          _menubutton('test'),
                          SizedBox(width: 20),
                          _menubutton('test'),
                        ],
                      ),
                    ),
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
            Expanded(child: ListsShop(widget.category))
          ],
        ),
      ),
    );
  }
}
