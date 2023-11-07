import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
import 'cancel_noshow_page.dart';


class ResTabBar extends StatefulWidget {
  const ResTabBar({Key? key}) : super(key: key);

  @override
  State<ResTabBar> createState() => _ResTabBarState();
}

class ReservationData {
  final String storeName;
  final String storeAddress;
  final String Peopleid;
  final int numberOfPeople;
  final int reservationYear;
  final int reservationMonth;
  final int reservationDay;
  final int reservationMinute;
  final int reservationHour;

  // 다른 예약 정보 필드들도 추가할 수 있습니다.

  ReservationData({
    required this.storeName,
    required this.storeAddress,
    required this.Peopleid,
    required this.numberOfPeople,
    required this.reservationYear,
    required this.reservationMonth,
    required this.reservationDay,
    required this.reservationMinute,
    required this.reservationHour,
  });
}

class ReservationDataProvider with ChangeNotifier {
  List<ReservationData> _reservations = [];

  List<ReservationData> get reservations => _reservations;


}

class ReservationListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('reser_test').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No reservations available.'));
        } else {
          List<ReservationData> reservations = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return ReservationData(
              storeName: data['storeName'] ?? '',
              storeAddress: data['storeAddress'] ?? '',
              Peopleid: data['Peopleid'] ?? '',
              numberOfPeople: data['numberOfPeople'] ?? '',
              reservationYear: data['reservationYear'] ?? '',
              reservationMonth: data['reservationMonth'] ?? '',
              reservationDay: data['reservationDay'] ?? '',
              reservationMinute: data['reservationMinute'] ?? '',
              reservationHour: data['reservationHour'] ?? '',
              // 다른 예약 정보 필드들도 추가할 수 있습니다.
            );
          }).toList();

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final reservation = reservations[index];
              return ListTile(
                //leading: Image.network(reservation.storeImageUrl), // 가게 이미지 표시
                title: Text('가게 이름: ${reservation.storeName}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('예약 날짜: ${reservation.reservationYear.toString()}년 '
                        '${reservation.reservationMonth.toString()}월 '
                        '${reservation.reservationDay.toString()}일'),
                    Text('예약 시간 : ${reservation.reservationHour.toString()}시'
                        '${reservation.reservationMinute.toString()}분'),
                    Text('예약자: ${reservation.Peopleid}'),

                    Text('예약 인원: ${reservation.numberOfPeople}명'),

                    Text('가게 주소: ${reservation.storeAddress}'),

                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    // 예약 취소 로직을 여기에 추가
                    //_cancelReservation(reservation.id);
                  },
                  child: Text('예약 취소'),
                ),
              );
            },
          );
        }
      },
    );
  }
}


class _ResTabBarState extends State<ResTabBar> {
  int selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("탭바 실습"),
          bottom: TabBar(
            tabs: [
              Tab(text: '나의 알림'),
              Tab(text: '나의 예약'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
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
                  if (selectedIndex == 2) Noshow(),
                ],
              ),
            ),
            // 나의 알림
            Center(child: ReservationListWidget()),
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
                }, child: Icon(Icons.calendar_month, size: 30),),
                InkWell(onTap: () {
                  if (userModel.isLogin) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserMain()));
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
