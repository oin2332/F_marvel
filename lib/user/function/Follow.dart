import 'package:cloud_firestore/cloud_firestore.dart';

// 팔로우 (팔로워) 조회
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
        followers.add(doc.id); // 내가 추가한 사람의 팔로워 리스트에 내 아이디 추가
        //내 팔로잉 리스트에 내가 팔로우 한사람 아이디 추가
        print('내가 추가한 팔로워 ID: ${doc.id}');
      });
    }

    return followers;
  } catch (e) {
    print('팔로워 아이디 목록 조회: $e'); 
    return [];
  }
}

// 팔로잉 조회
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

//팔로우 기능
Future<void> followUser(String myUserId, String followedUserId) async {
  // String myUserId <- 현재 로그인 아이디
  // String followedUserId <- 현재 아이디가 팔로우 하려는 아이디
  try {
    CollectionReference userCollection = FirebaseFirestore.instance.collection(
        'T3_USER_TBL');
    var userDocSnapshot = await userCollection.where('id', isEqualTo: myUserId)
        .limit(1)
        .get();
    var followedUserDocSnapshot = await userCollection.where(
        'id', isEqualTo: followedUserId).limit(1).get();

    // 1. 내 아이디로 로그인하여 다른 사용자를 팔로우하는 경우
    // t3_follower_tbl 컬렉션에 새로운 문서를 생성하고 timestamp 필드를 추가

    if (userDocSnapshot.docs.isNotEmpty) {
      await followedUserDocSnapshot.docs.first.reference.collection(
          'T3_FOLLOWER_TBL').doc(myUserId).set({
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('현재 사용자 팔로잉 증가');
    }

    // 2. 동시에 내 유저 정보를 담은 문서에서 t3_following_tbl 서브컬렉션에 새로운 문서를 생성
    // followedUserId를 문서 아이디로 사용하여 새로운 문서를 생성

    if (followedUserDocSnapshot.docs.isNotEmpty) {
      await userDocSnapshot.docs.first.reference.collection('T3_FOLLOWING_TBL')
          .doc(followedUserId)
          .set({
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('다른 사용자 팔로워 증가');
    }
  } catch (e) {
    print('팔로우 에러: $e');
  }
}


