import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:food_marvel/reservation/RtabBar.dart';

import 'getReservation.dart';

Future<void> cancelReservation(String reservationId) async {
  try {
    await FirebaseFirestore.instance.collection('reser_test').doc(reservationId).delete();
  } catch (e) {
    print('Error deleting reservation: $e');
    // 예외 처리를 여기에 추가할 수 있습니다.
  }
}
class ReservationDataProvider with ChangeNotifier {
  List<ReservationData> _reservations = [];

  List<ReservationData> get reservations => _reservations;

  Future<void> cancelReservation(String reservationId) async {
    // 예약 취소 - 데이터베이스에서 삭제
    await cancelReservation(reservationId);

    // 예약을 로컬 리스트에서 제거
    _reservations.removeWhere((reservation) => reservation.id == reservationId);

    // 상태 변화를 알리고 UI를 업데이트합니다.
    notifyListeners();
  }
}