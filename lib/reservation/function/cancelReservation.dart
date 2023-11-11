import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:food_marvel/reservation/RtabBar.dart';
import 'package:http/http.dart' as http;
import 'getReservation.dart';

Future<void> cancelReservation(String reservationId) async {
  try {
    // 예약을 취소할 때 R_state 필드를 'C'로 업데이트합니다.
    await FirebaseFirestore.instance.collection('T3_STORE_RESERVATION')
        .doc(reservationId).
    update({
      'R_state': 'C',
    });
  } catch (e) {
    print('예약 상태 업데이트 오류: $e');
    // 예외 처리는 여기에 추가하세요.
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? fcmToken = await messaging.getToken();
  await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=AAAAH6_c1yw:APA91bEJTMrIJhVjJa4MBP76N_XncTlXQvXnOQB4aBv_9nrqEJP6dbJbiLZi-DQMGfg3PAXkXJwZHcxlJjW6PLLjaLGz34LBpXxYONkF9Xqlltb4FBqpW8P99ua-8opTVXUKeaQGZjPK', // FCM 서버 키를 넣어주세요
    },
    body: jsonEncode({
      'notification': {
        'title': '푸드마블 ',
        'body': '취소가 성공적으로 완료되었습니다.',
      },
      'to': fcmToken,
    }),
  );
}

class ReservationDataProvider with ChangeNotifier {
  List<ReservationData> _reservations = [];

  List<ReservationData> get reservations => _reservations;

  Future<void> cancelReservation(String reservationId) async {
    try {
      // 클래스 외부에 정의된 함수를 호출하여 예약을 취소합니다.
      await cancelReservation(reservationId);

      // 로컬 목록에서 예약을 제거합니다.
      _reservations.removeWhere((reservation) => reservation.id == reservationId);

      // 리스너에 알리고 UI를 업데이트합니다.
      notifyListeners();
    } catch (e) {
      print('예약 취소 오류: $e');
      // 예외 처리는 여기에 추가하세요.
    }
  }
}
