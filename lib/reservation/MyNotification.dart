import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_marvel/reservation/function/updateReservationState.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../user/userModel.dart';
import 'RtabBar.dart';

class MyNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    updateReservationStatus();
    UserModel userModel = Provider.of<UserModel>(context);
    String? userId = userModel.userId;

    if (userId == null) {
      return Center(child: Text('로그인이 필요합니다.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('alarm_test')
          .where('R_id', isEqualTo: userId)
          .orderBy('timestamp', descending: true) // timestamp 기준으로 내림차순 정렬
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('알림이 없습니다.'));
        } else {
          List<QueryDocumentSnapshot> notifications = snapshot.data!.docs;
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              // 필요한 필드를 가져와서 변수에 저장
              String reservationDate = notification['R_DATE'];
              String storeName = notification['R_S_ID'];
              String reservationId = notification['R_id'];
              String message = notification['message'];
              Timestamp timestamp = notification['timestamp']; // Timestamp 형식으로 가져옴

              // Timestamp를 DateTime으로 변환
              DateTime dateTime = timestamp.toDate();
              String formattedTimestamp = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);

              // 리스트 타일에 필요한 내용 출력
              return Dismissible(
                key: Key(notification.id), // 고유한 키로 사용
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) async {
                  // 파이어스토어에서 해당 문서 삭제
                  await FirebaseFirestore.instance.collection('alarm_test').doc(notification.id).delete();
                },
                child: ListTile(
                  title: Text('메시지: $message'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('예약 날짜: $reservationDate'),
                      Text('가게 이름: $storeName'),
                      Text('예약자 아이디: $reservationId'),
                      Text('날짜: $formattedTimestamp'),
                      // 추가 필요한 내용들을 여기에 추가할 수 있습니다.
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
