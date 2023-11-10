import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// 사용자 리스트 조회
Future<List<String>> fetchUserIds() async {
  try {
    QuerySnapshot userSnapshot =
    await FirebaseFirestore.instance.collection('T3_USER_TBL').get();

    if (userSnapshot.docs.isNotEmpty) {
      List<String> userIds = [];

      for (QueryDocumentSnapshot doc in userSnapshot.docs) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        String userId = userData['id'];
        userIds.add(userId);
      }

      return userIds;
    } else {
      return [];
    }
  } catch (e) {
    print('Error fetching user IDs: $e');
    throw e;
  }
}

// 유저 프로필 이미지 출력
Future<String?> fetchProfileImageUrl(String userId) async {
  try {
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('T3_USER_TBL')
        .where('id', isEqualTo: userId)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in userSnapshot.docs) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        return userData['profile_image'] ?? '/assets/user/userProfile.png'; // 대체값을 지정
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

// 출력 화면 로직
class UserIdListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: fetchUserIds(),
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
          List<String> userIds = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: userIds.length,
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
                                future: fetchProfileImageUrl(userIds[index]),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator(); // 데이터를 기다리는 동안 로딩 표시
                                  } else if (snapshot.hasError) {
                                    return Text('오류 발생: ${snapshot.error}');
                                  } else {
                                    String? imageUrl = snapshot.data;
                                    if (imageUrl != null) {
                                      return Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover, // 이미지가 원 안에 꽉 차게 표시됩니다.
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
                          Text('${userIds[index]}', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 10),
                          Row(
                            children: [

                              SizedBox(width: 20),
                              // 팔로우버튼
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton( // 팔로우 버튼
                                    onPressed: (){},
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.deepOrange[400]!, // 원하는 색상으로 변경
                                    ),
                                    child: Text('팔로우', style: TextStyle(fontWeight: FontWeight.bold))
                                ),
                              )
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
}