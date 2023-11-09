import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addBookmark(String userId, String docId) async {
  try {
    FirebaseFirestore fs = FirebaseFirestore.instance;
    CollectionReference stores = fs.collection("T3_STORE_TBL");
    DocumentReference bookmarkRef = stores.doc(docId).collection("T3_BOOKMARK_TBL").doc(userId);

    DocumentSnapshot bookmarkDoc = await bookmarkRef.get();

    if (bookmarkDoc.exists) {
      // 북마크가 이미 존재하면 제거
      await bookmarkRef.delete();
      print('북마크를 제거했습니다. 사용자 아이디 >> $userId');
    } else {
      // 북마크가 존재하지 않으면 추가
      await bookmarkRef.set({
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('북마크를 추가했습니다. 사용자 아이디 >> $userId');
    }
  } catch (e) {
    print('북마크 작업 중 오류 발생: $e');
  }
}