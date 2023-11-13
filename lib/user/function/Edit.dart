import 'package:cloud_firestore/cloud_firestore.dart';


// 이름 수정
void updateNameInFirestore(String userId, String newName) async {
  try {

    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('T3_USER_TBL')
        .where('id', isEqualTo: userId)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      QueryDocumentSnapshot doc = userSnapshot.docs.first;
      await doc.reference.update({'name': newName});
      print('$userId님의 이름이 업데이트되었습니다.');
    } else {
      print('해당 사용자를 찾을 수 없습니다.');
    }
  } catch (e) {
    print('이름 업데이트 중 오류 발생: $e');
  }
}

// 전화번호 수정
void updatePhoneInFirestore(String userId, String newPhone) async {
  try {

    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('T3_USER_TBL')
        .where('id', isEqualTo: userId)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      QueryDocumentSnapshot doc = userSnapshot.docs.first;
      await doc.reference.update({'phone': newPhone});
      print('$userId님의 전화번호가 업데이트되었습니다.');
    } else {
      print('해당 사용자를 찾을 수 없습니다.');
    }
  } catch (e) {
    print('전화번호 업데이트 중 오류 발생: $e');
  }
}

// 패스워드 수정
void updatePwdInFirestore(String userId, String newPwd) async {
  try {

    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('T3_USER_TBL')
        .where('id', isEqualTo: userId)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      QueryDocumentSnapshot doc = userSnapshot.docs.first;
      await doc.reference.update({'pwd': newPwd});
      print('$userId님의 패스워드가 업데이트되었습니다.');
    } else {
      print('해당 사용자를 찾을 수 없습니다.');
    }
  } catch (e) {
    print('패스워드 업데이트 중 오류 발생: $e');
  }
}