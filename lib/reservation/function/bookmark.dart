import 'package:cloud_firestore/cloud_firestore.dart';

void addBookmark(String userId, String docId) async {
  try {
    FirebaseFirestore fs = FirebaseFirestore.instance;
    CollectionReference stores = fs.collection("T3_STORE_TBL");

    await stores
        .doc(docId)
        .collection("T3_BOOKMARK_TBL")
        .doc(userId)
        .set({
      'timestamp': FieldValue.serverTimestamp(),
      'Booktime': "Y",
    });

    print('북마크에 추가 할 사용자 아이디 >> $userId');

    Future.delayed(Duration(seconds: 10), () async {
      await updateBooktimeToN(docId, userId);
    });
  } catch (e) {
    print('북마크 작업 중 오류 발생: $e');
  }
}

Future<void> updateBooktimeToN(String docId, String userId) async {
  try {
    FirebaseFirestore fs = FirebaseFirestore.instance;
    CollectionReference stores = fs.collection("T3_STORE_TBL");

    await stores
        .doc(docId)
        .collection("T3_BOOKMARK_TBL")
        .doc(userId)
        .update({'Booktime': 'N'});

    print('Booktime을 "N"으로 업데이트: $userId');
  } catch (e) {
    print('Booktime 업데이트 중 오류 발생: $e');
  }
}