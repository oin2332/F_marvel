import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_marvel/reservation/function/cancelReservation.dart';
import 'package:food_marvel/user/userModel.dart';
import 'package:provider/provider.dart';

class ReservationData {
  final String id;
  final String storeName;
  final String storeAddress;
  final String Peopleid;
  final int numberOfPeople;
  final String reservationDate;
  final String reservationTime;



  // 다른 예약 정보 필드들도 추가할 수 있습니다.

  ReservationData({
    required this.id,
    required this.storeName,
    required this.storeAddress,
    required this.Peopleid,
    required this.numberOfPeople,
    required this.reservationDate,
    required this.reservationTime,
    required state,

  });
}

class ReservationDataProvider with ChangeNotifier {
  List<ReservationData> _reservations = [];

  List<ReservationData> get reservations => _reservations;


}

class ReservationFListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userModel = Provider.of<UserModel>(context); // UserModel 인스턴스 가져오기
    String? userId = userModel.userId; // 현재 사용자의 ID 가져오기

    if (userId == null) {
      // 사용자가 로그인하지 않은 경우 로그인 화면 또는 다른 처리를 표시할 수 있습니다.
      return Center(child: Text('로그인이 필요합니다.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('T3_STORE_RESERVATION')
          .where('R_id', isEqualTo: userId) // 사용자 ID와 일치하는 예약만 가져오기
          .where('R_state', isEqualTo: 'G')  // R_state가 null인 데이터만 필터링
          .snapshots(),
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
              storeName: data['R_S_ID'] ?? '',
              storeAddress: data['R_S_ADDR'] ?? '',
              Peopleid: data['R_id'] ?? '',
              numberOfPeople: data['R_number'] ?? '',
              reservationDate: data['R_DATE'] ?? '',
              reservationTime: data['R_TIME'] ?? '',
              id: doc.id, // Firestore 문서 ID를 할당합니다.
              state : data['R_state'] ?? '',
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
                    Text('예약 날짜: ${reservation.reservationDate}'),
                    Text('예약 시간 : ${reservation.reservationTime}'),
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
                              onPressed: () async {
                                Navigator.of(context).pop(); // 다이얼로그 닫기
                                // 예약 취소 로직을 여기에 추가
                                await cancelReservation(reservation.id);

                                // 예약이 성공적으로 취소되었음을 알리는 다이얼로그 표시
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('예약 취소 완료'),
                                      content: Text('예약이 성공적으로 취소되었습니다.'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('확인'),
                                          onPressed: () {
                                            Navigator.of(context).pop(); // 추가 다이얼로그 닫기
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
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