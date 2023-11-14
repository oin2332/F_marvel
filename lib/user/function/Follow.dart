import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../board/function/Board.dart';

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
// 언팔로우기능
Future<void> unfollowUser(String myUserId, String followedUserId) async {
  try {
    CollectionReference userCollection = FirebaseFirestore.instance.collection('T3_USER_TBL');
    var userDocSnapshot = await userCollection.where('id', isEqualTo: myUserId).limit(1).get();
    var followedUserDocSnapshot = await userCollection.where('id', isEqualTo: followedUserId).limit(1).get();

    if (userDocSnapshot.docs.isNotEmpty) {
      await followedUserDocSnapshot.docs.first.reference.collection('T3_FOLLOWER_TBL').doc(myUserId).delete();
    }

    if (followedUserDocSnapshot.docs.isNotEmpty) {
      await userDocSnapshot.docs.first.reference.collection('T3_FOLLOWING_TBL').doc(followedUserId).delete();
    }
  } catch (e) {
    print('언팔로우 에러: $e');
  }
}

//팔로워 삭제기능
Future<void> unfollowFollower(String myUserId, String followedUserId) async {
  try {
    CollectionReference userCollection = FirebaseFirestore.instance.collection('T3_USER_TBL');
    var userDocSnapshot = await userCollection.where('id', isEqualTo: myUserId).limit(1).get();
    if (userDocSnapshot.docs.isNotEmpty) {
      await userDocSnapshot.docs.first.reference.collection('T3_FOLLOWER_TBL').doc(followedUserId).delete();
    }
    var followedUserDocSnapshot = await userCollection.where('id', isEqualTo: followedUserId).limit(1).get();
    if (followedUserDocSnapshot.docs.isNotEmpty) {
      await followedUserDocSnapshot.docs.first.reference.collection('T3_FOLLOWING_TBL').doc(myUserId).delete();
    }
  } catch (e) {
    print('팔로우삭제 에러: $e');
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

// 내가 팔로우 하는 사용자들의 프로필 이미지 출력
Future<String?> followingProfileImageUrl(String userId) async {
  try {
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('T3_USER_TBL')
        .where('id', isEqualTo: userId)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in userSnapshot.docs) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        return userData['profile_image'];
      }
    } else {
      print('해당 사용자를 찾을 수 없습니다.');
    }
  } catch (e) {
    print('데이터를 불러오는 중 오류가 발생했습니다: $e');
    throw e;
  }

  return null;
}

// 내가 팔로우하는 사람들 프로필 사진 리스트
class UserIdListWidget extends StatelessWidget {
  final String currentUserId; // 현재 사용자의 ID

  UserIdListWidget({required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: fetchFollowingUserIds(currentUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('No user IDs found.'),
          );
        } else {
          List<String> followingUserIds = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: followingUserIds.length,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // 프로필사진
                        Container(
                          width: 50,
                          height: 50,
                          child: ClipOval(
                            child: FutureBuilder<String?>(
                              future: fetchProfileImageUrl(followingUserIds[index]),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  String? imageUrl = snapshot.data;
                                  if (imageUrl != null) {
                                    return Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      width: 50,
                                      height: 50,
                                    );
                                  } else {
                                    return Image.asset('/assets/user/userProfile.png');
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        // 아이디
                        Text('${followingUserIds[index]}', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 10),
                        Row(
                          children: [
                            SizedBox(width: 20),
                            // 팔로우버튼
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  // 팔로우 버튼이 눌렸을 때의 동작 정의
                                  // 현재는 간단히 콘솔에 사용자 ID를 출력하는 예시를 보여줍니다.
                                  print('Following ${followingUserIds[index]}');
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.deepOrange[400]!,
                                ),
                                child: Text('팔로우', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }

  // 현재 사용자가 팔로우하는 사용자 ID 목록을 가져오는 함수
  Future<List<String>> fetchFollowingUserIds(String currentUserId) async {
    List<String> followingUserIds = [];

    try {
      // t3_user_tbl에서 현재 사용자의 문서를 가져옴
      QuerySnapshot userDocuments = await FirebaseFirestore.instance
          .collection('T3_USER_TBL')
          .where('id', isEqualTo: currentUserId)
          .get();

      if (userDocuments.docs.isNotEmpty) {
        DocumentSnapshot userDocument = userDocuments.docs.first;

        // t3_following_tbl 컬렉션 조회
        CollectionReference followingCollection = userDocument.reference.collection('t3_following_tbl');
        QuerySnapshot followingDocs = await followingCollection.get();

        // t3_following_tbl 안에 있는 문서 아이디 목록
        List<String> followingIds = followingDocs.docs.map((doc) => doc.id).toList();

        // 이제 followingIds 리스트에는 현재 사용자가 팔로우하는 사용자들의 ID가 들어 있습니다.
      }


    } catch (e) {
      print('Error fetching following user IDs: $e');
    }

    return followingUserIds;
  }
}

// 나를 팔로우 하는 사용자들의 프로필 이미지 출력
Future<String?> followerProfileImageUrl(String userId) async {
  try {
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('T3_USER_TBL')
        .where('id', isEqualTo: userId)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in userSnapshot.docs) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        return userData['profile_image'];
      }
    } else {
      print('해당 사용자를 찾을 수 없습니다.');
    }
  } catch (e) {
    print('데이터를 불러오는 중 오류가 발생했습니다: $e');
    throw e;
  }

  return null;
}

// 나를 팔로우하는 사람들 프로필 사진 리스트
class FollowerUserIdListWidget extends StatelessWidget {
  final String UserId; // 현재 사용자의 ID

  FollowerUserIdListWidget({required this.UserId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: fetchFollowerUserIds(UserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('No user IDs found.'),
          );
        } else {
          List<String> followingUserIds = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: followingUserIds.length,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // 프로필사진
                        Container(
                          width: 50,
                          height: 50,
                          child: ClipOval(
                            child: FutureBuilder<String?>(
                              future: fetchProfileImageUrl(followingUserIds[index]),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  String? imageUrl = snapshot.data;
                                  if (imageUrl != null) {
                                    return Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      width: 50,
                                      height: 50,
                                    );
                                  } else {
                                    return Image.asset('/assets/user/userProfile.png');
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        // 아이디
                        Text('${followingUserIds[index]}', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 10),
                        Row(
                          children: [
                            SizedBox(width: 20),
                            // 팔로우버튼
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  // 팔로우 버튼이 눌렸을 때의 동작 정의
                                  // 현재는 간단히 콘솔에 사용자 ID를 출력하는 예시를 보여줍니다.
                                  print('Following ${followingUserIds[index]}');
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.deepOrange[400]!,
                                ),
                                child: Text('팔로우', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }

  // 현재 사용자가 팔로우하는 사용자 ID 목록을 가져오는 함수
  Future<List<String>> fetchFollowerUserIds(String currentUserId) async {
    List<String> followerUserIds = []; // 변수명을 'followerUserIds'로 변경

    try {
      QuerySnapshot userDocuments = await FirebaseFirestore.instance
          .collection('T3_USER_TBL')
          .where('id', isEqualTo: currentUserId)
          .get();

      if (userDocuments.docs.isNotEmpty) {
        DocumentSnapshot userDocument = userDocuments.docs.first;

        CollectionReference followerCollection = userDocument.reference.collection('T3_FOLLOWER_TBL'); // 여기서 컬렉션 이름 변경
        QuerySnapshot followerDocs = await followerCollection.get();

        followerUserIds = followerDocs.docs.map((doc) => doc.id).toList(); // 리스트 변수명 변경
      }
    } catch (e) {
      print('팔로워 사용자 ID를 불러오는 중 오류: $e');
    }

    return followerUserIds;
  }
  Future<int> fetchFollowerCount(String currentUserId) async {
    try {
      QuerySnapshot userDocuments = await FirebaseFirestore.instance
          .collection('T3_USER_TBL')
          .where('id', isEqualTo: currentUserId)
          .get();

      if (userDocuments.docs.isNotEmpty) {
        DocumentSnapshot userDocument = userDocuments.docs.first;

        CollectionReference followerCollection = userDocument.reference.collection('T3_FOLLOWER_TBL');
        QuerySnapshot followerDocs = await followerCollection.get();

        return followerDocs.docs.length;
      }
    } catch (e) {
      print('팔로워 수를 불러오는 중 오류: $e');
    }
    return 0; // 에러가 발생하면 0을 반환하도록 설정
  }
}
