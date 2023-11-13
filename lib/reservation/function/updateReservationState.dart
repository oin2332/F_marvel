import 'package:cloud_firestore/cloud_firestore.dart';

// updateReservationStatus 함수를 가져온 목록을 사용하여 수정
Future<void> updateReservationStatus(List<QueryDocumentSnapshot<Object?>> reservationDocs) async {
  try {
    DateTime now = DateTime.now();
    int bufferMinutes = 30;

    for (int i = 0; i < reservationDocs.length; i++) {
      QueryDocumentSnapshot<Object?> reservationDoc = reservationDocs[i];
      Map<String, dynamic> data = reservationDoc.data() as Map<String, dynamic>;
      DateTime reservationDateTime = DateTime.parse("${data['R_DATE']} ${data['R_TIME']}");

      // 추가: 어떤 예약이 현재 처리 중인지 확인
      print('Checking reservation status for: ${reservationDoc.id}');

      if (now.isAfter(reservationDateTime.subtract(Duration(minutes: bufferMinutes))) && data['R_state'] == null) {
        try {
          await FirebaseFirestore.instance.collection('T3_STORE_RESERVATION').doc(reservationDoc.id).update({
            'R_state': 'G',
          });

          print('Reservation marked as completed: ${reservationDoc.id}');

          var updatedReservation = await FirebaseFirestore.instance.collection('T3_STORE_RESERVATION').doc(reservationDoc.id).get();
          print('Updated Reservation state: ${updatedReservation['R_state']}');
        } catch (error) {
          print('Error updating reservation ${reservationDoc.id}: $error');
        }
      }
    }
  } catch (error) {
    print('Error in updateReservationStatus: $error');
  }
  print('end function');
}
