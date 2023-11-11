import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:food_marvel/reservation/RtabBar.dart';
import 'package:http/http.dart' as http;
import 'getReservation.dart';
import '../function/reservation_data.dart';
Future<void> deleteReservation(String reservationId) async {
  try {
    // 예약을 삭제합니다.
    await FirebaseFirestore.instance.collection('T3_STORE_RESERVATION').doc(reservationId).delete();
  } catch (e) {
    print('예약 삭제 오류: $e');
    // 예외 처리는 여기에 추가하세요.
  }



}

class ReservationDataProvider with ChangeNotifier {
  List<ReservationData> _reservations = [];

  List<ReservationData> get reservations => _reservations;

  Future<void> cancelReservation(String reservationId) async {
    try {
      // 클래스 외부에 정의된 함수를 호출하여 예약을 삭제합니다.
      await deleteReservation(reservationId);

      // 로컬 목록에서 예약을 제거합니다.
      _reservations.removeWhere((reservation) => reservation.id == reservationId);

      // 리스너에 알리고 UI를 업데이트합니다.
      notifyListeners();
    } catch (e) {
      print('예약 삭제 오류: $e');
      // 예외 처리는 여기에 추가하세요.
    }
  }
}
