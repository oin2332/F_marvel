import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_marvel/reservation/MyNotification.dart';
import 'package:food_marvel/reservation/Visit_Cancel.dart';
import 'package:food_marvel/reservation/function/Alarm.dart';
import 'package:food_marvel/reservation/function/cancelReservation.dart';
import 'package:food_marvel/reservation/function/getReservation.dart';
import 'package:food_marvel/reservation/visit_completed_page.dart';
import 'package:food_marvel/reservation/visit_schedule_page.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../board/boardView.dart';
import '../board/timeLine.dart';
import '../main/importbottomBar.dart';
import '../main/mainPage.dart';
import '../search/navSearch.dart';
import '../shop/storePage.dart';
import '../user/userMain.dart';
import '../user/userModel.dart';
import '../user/userUnlogin.dart';
import 'function/cancel_noshow_page.dart';


class ResTabBar extends StatefulWidget {
  const ResTabBar({Key? key}) : super(key: key);

  @override
  State<ResTabBar> createState() => _ResTabBarState();
}

class _ResTabBarState extends State<ResTabBar> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // 앱이 시작될 때 예약 상태를 업데이트합니다.
    updateReservationStatus();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context);
    String? uId = userModel.userId;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            title: Text('예약 관리', style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios)),
          bottom: TabBar(
            tabs: [
              Tab(text: '나의 알림',),
              Tab(text: '나의 예약',),
            ],
            labelColor: Colors.black, // 선택된 탭의 텍스트 색상
            labelStyle: TextStyle(fontWeight: FontWeight.bold), // 선택된 탭의 텍스트 bold
            unselectedLabelColor: Colors.grey, // 선택되지 않은 탭의 텍스트 색상
            indicatorColor: Colors.red, // 선택된 탭 바 색상
          ),
        ),
        body: TabBarView(
          children: [
            // 나의 알림
            Center(child: MyNotification()),
            Container(
              child: Column(
                children: [
                  Container(
                    height: 80,
                    child: Row(
                      children: [
                        const SizedBox(width: 30),
                        buildTabButton(0, '방문예정'),
                        buildTabButton(1, '방문완료'),
                        buildTabButton(2, '취소/노쇼'),
                      ],
                    ),
                  ),
                  // 여기에 방문 예정 페이지 내용 추가
                  if (selectedIndex == 0) Visit_completed_page(),
                  // 여기에 방문 완료 페이지 내용 추가
                  if (selectedIndex == 1) Visit_schedule_page(),
                  // 여기에 취소/노쇼 페이지 내용 추가
                  if (selectedIndex == 2) Visit_Cancel(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 50,
            color: Color.fromRGBO(255, 255, 255, 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));},
                  child: Icon(Icons.home_outlined,size: 30),),
                InkWell(
                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => NavSearch()));
                  }, child: Icon(Icons.search_outlined, size: 30),),
                InkWell(onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TimeLine()));
                },  child: Icon(Icons.message_outlined, size: 28),),
                InkWell(onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ResTabBar()));
                }, child: Icon(Icons.calendar_month, size: 28),),
                InkWell(onTap: () {
                  if (userModel.isLogin) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserMain(userId: uId,)));
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserUnlogin()));
                  }
                }, child: Icon(Icons.person_outline_outlined, size: 30),),
              ],
            ),
          ),
        ),
      ),

    );
  }
  Future<void> updateReservationStatus() async {
    // 현재 시간을 가져옵니다.
    DateTime now = DateTime.now();

    // Firestore에서 예약 목록을 가져옵니다.
    QuerySnapshot<Map<String, dynamic>> reservationSnapshot = await FirebaseFirestore.instance
        .collection('T3_STORE_RESERVATION')
        .where('R_state', isNull: true) // 방문 완료되지 않은 예약만 가져오기
        .get();

    // 예약을 방문 완료로 표시할 조건을 설정합니다.
    int bufferMinutes = 30; // 예약 시간에서 얼마나 이전까지 방문 완료로 표시할지 설정 (예: 30분)
    for (QueryDocumentSnapshot<Map<String, dynamic>> reservationDoc in reservationSnapshot.docs) {
      Map<String, dynamic> data = reservationDoc.data();
      DateTime reservationDateTime =
      DateTime.parse("${data['R_DATE']} ${data['R_TIME']}"); // 문자열로 된 날짜와 시간을 DateTime으로 변환합니다.

      // 예약 시간이 현재 시간보다 이전이고, 현재 시간에서 bufferMinutes 이내인 경우 방문 완료로 표시합니다.
      if (reservationDateTime.isBefore(now) && now.difference(reservationDateTime).inMinutes.abs() <= bufferMinutes) {
        // Firestore에서 해당 예약을 업데이트합니다.
        await FirebaseFirestore.instance.collection('T3_STORE_RESERVATION').doc(reservationDoc.id).update({
          'R_state': 'G', // 'G'는 방문 완료를 나타내는 상태입니다. 적절한 값으로 변경하세요.
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant ResTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 페이지가 업데이트되었을 때 예약 상태를 다시 업데이트합니다.
    updateReservationStatus();
  }

  Widget buildTabButton(int index, String text) {
    return TextButton(
      onPressed: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        width: 85,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: selectedIndex == index ? Colors.black : Colors.transparent,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: selectedIndex == index ? Colors.black : Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

