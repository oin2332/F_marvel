import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateReservationStatus() async {

  try {
    // 현재 시간을 가져옵니다.
    DateTime now = DateTime.now();
    // print(now);

    // Firestore에서 예약 목록을 가져옵니다.
    QuerySnapshot<Map<String, dynamic>> reservationSnapshot = await FirebaseFirestore.instance
        .collection('T3_STORE_RESERVATION')
        .where('R_state', isNull: true) // 방문 완료되지 않은 예약만 가져오기
        .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> reservationDoc in reservationSnapshot.docs) {
      // 각 문서의 데이터 출력
      print('Document ID: ${reservationDoc.id}, Data: ${reservationDoc.data()}');
    }

    int bufferMinutes = 30; // 예약 시간에서 얼마나 이전까지 방문 완료로 표시할지 설정 (예: 30분)

    for (int i = 0; i < reservationSnapshot.docs.length; i++) {
      QueryDocumentSnapshot<Map<String, dynamic>> reservationDoc = reservationSnapshot.docs[i];
      Map<String, dynamic> data = reservationDoc.data();
      DateTime reservationDateTime = DateTime.parse("${data['R_DATE']} ${data['R_TIME']}");

      // 추가: 어떤 예약이 현재 처리 중인지 확인
      print('Checking reservation status for: ${reservationDoc.id}');

      // 예약 시간이 현재 시간보다 bufferMinutes 이내이면서 예약 상태가 null인 경우에만 방문 완료로 표시합니다.
      if (now.difference(reservationDateTime).inMinutes.abs() <= bufferMinutes && data['R_state'] == null) {
        try {
          // Firestore에서 해당 예약을 업데이트합니다.
          await FirebaseFirestore.instance.collection('T3_STORE_RESERVATION').doc(reservationDoc.id).update({
            'R_state': 'G', // 'G'는 방문 완료를 나타내는 상태입니다. 적절한 값으로 변경하세요.
          });

          // 추가: 프린트문을 통해 어떤 예약이 방문 완료로 처리되었는지 확인합니다.
          print('Reservation marked as completed: ${reservationDoc.id}');

          // 추가: 업데이트된 예약 상태 확인
          var updatedReservation = await FirebaseFirestore.instance.collection('T3_STORE_RESERVATION').doc(reservationDoc.id).get();
          print('Updated Reservation state: ${updatedReservation['R_state']}');
        } catch (error) {
          print('Error updating reservation ${reservationDoc.id}: $error');
        }
      }
    }


  } catch (error) {
    // 오류가 발생했을 때 출력
    print('Error in updateReservationStatus: $error');
  }
  print('end function');
}