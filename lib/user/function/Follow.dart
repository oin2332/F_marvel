import 'package:cloud_firestore/cloud_firestore.dart';

// 팔로우 (팔로워) 기능
Future<List<String>> getUserFollowers(String userId) async {
  List<String> followers = [];

  try {
    print(userId);
    CollectionReference userCollection = FirebaseFirestore.instance.collection('T3_USER_TBL');
    var userDocSnapshot = await userCollection.where('id',isEqualTo: userId).limit(1).get();

    if (userDocSnapshot.docs.isNotEmpty) {
      var followerDocSnapshot = await userDocSnapshot.docs.first.reference.collection('T3_FOLLOWER_TBL').get();
      print('if 동작확인');
      // 사용자 문서가 존재하는 경우에만 실행

      followerDocSnapshot.docs.forEach((doc) {
        followers.add(doc.id);
        print('추가된 팔로워 ID: ${doc.id}');
      });
    }

    return followers;
  } catch (e) {
    print('팔로워 아이디 목록 조회: $e'); 
    return [];
  }
}

// 팔로잉 기능
Future<List<String>> getUserFollowings(String userId) async {
  List<String> followings = [];

  try {
    print(userId);
    CollectionReference userCollection = FirebaseFirestore.instance.collection('T3_USER_TBL');
    var userDocSnapshot = await userCollection.where('id',isEqualTo: userId).limit(1).get();

    if (userDocSnapshot.docs.isNotEmpty) {
      var followingsDocSnapshot = await userDocSnapshot.docs.first.reference.collection('T3_FOLLOWING_TBL').get();
      print('if 동작확인');
      // 사용자 문서가 존재하는 경우에만 실행

      followingsDocSnapshot.docs.forEach((doc) {
        followings.add(doc.id);
        print('추가된 팔로잉 ID: ${doc.id}');
      });
    }

    return followings;
  } catch (e) {
    print('팔로워 아이디 목록 조회: $e');
    return [];
  }
}
