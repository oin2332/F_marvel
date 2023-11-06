import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_marvel/reservation/visit_completed_page.dart';
import 'package:food_marvel/reservation/visit_schedule_page.dart';
import 'package:provider/provider.dart';

import '../board/boardView.dart';
import '../main/importbottomBar.dart';
import '../shop/storePage.dart';
import 'cancel_noshow_page.dart';


class ResTabBar extends StatefulWidget {
  const ResTabBar({Key? key}) : super(key: key);

  @override
  State<ResTabBar> createState() => _ResTabBarState();
}

class ReservationData {
  final String storeName;
  final String storeAddress;
  // 다른 예약 정보 필드들도 추가할 수 있습니다.

  ReservationData({required this.storeName, required this.storeAddress});
}

class ReservationDataProvider with ChangeNotifier {
  List<ReservationData> _reservations = [];

  List<ReservationData> get reservations => _reservations;

  Future<void> fetchReservations() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collection('reser_test').get();

    _reservations = querySnapshot.docs
        .map((doc) => ReservationData(
      storeName: doc['storeName'] ?? '',
      storeAddress: doc['storeAddress'] ?? '',
      // 다른 예약 정보 필드들도 추가할 수 있습니다.
    ))
        .toList();

    notifyListeners();

    // 예약 정보 리스트 출력
    _reservations.forEach((reservation) {
      print('Store Name: ${reservation.storeName}');
      print('Store Address: ${reservation.storeAddress}');
      // 다른 예약 정보 필드들도 출력할 수 있습니다.
    });
  }
}

class ReservationListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final reservationProvider =
    Provider.of<ReservationDataProvider>(context, listen: false);
    reservationProvider.fetchReservations();

    return Consumer<ReservationDataProvider>(
      builder: (context, provider, child) {
        final reservations = provider.reservations;

        return ListView.builder(
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            final reservation = reservations[index];
            return ListTile(
              title: Text(reservation.storeName),
              subtitle: Text(reservation.storeAddress),
              // 다른 예약 정보 필드들도 여기에 추가할 수 있습니다.
            );
          },
        );
      },
    );
  }
}


class _ResTabBarState extends State<ResTabBar> {
  int selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
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
        bottomNavigationBar: BottomNavBar(),
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
