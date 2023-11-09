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
    });
    print('북마크에 추가 할 사용자 아이디 >> $userId');
  } catch (e) {
    print('북마크 작업 중 오류 발생: $e');
  }
}

