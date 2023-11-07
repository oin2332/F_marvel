import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_marvel/reservation/function/deleteReservation.dart';

class ReservationData {
  final String id;
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
    required this.id,
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
              id: doc.id, // Firestore 문서 ID를 할당합니다.
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
                    // 예약 취소를 확인하기 위한 경고 다이얼로그 표시
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('예약 취소'),
                          content: Text('예약을 취소하시겠습니까?'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('확인'),
                              onPressed: () {
                                Navigator.of(context).pop(); // 다이얼로그 닫기
                                // 예약 취소 로직을 여기에 추가
                                cancelReservation(reservation.id);
                              },
                            ),
                            TextButton(
                              child: Text('취소'),
                              onPressed: () {
                                Navigator.of(context).pop(); // 다이얼로그 닫기
                              },
                            ),

                          ],
                        );
                      },
                    );
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