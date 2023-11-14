import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../member.dart';
import '../userModel.dart';
import 'Follow.dart';





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
        String? imageUrl = userData['profile_image'];

        if (imageUrl == null) {
          // 만약 profile_image 값이 null이라면 디폴트 이미지의 다운로드 링크를 반환
          return await fetchDefaultProfileImageUrl();
        } else {
          return imageUrl;
        }
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

// Firebase Storage에서 디폴트 프로필 이미지 다운로드 링크 가져오기
Future<String?> fetchDefaultProfileImageUrl() async {
  try {
    // 'userProfile.png'는 Storage에 있는 디폴트 이미지의 경로입니다.
    String defaultImageUrl =
        'https://firebasestorage.googleapis.com/v0/b/tjoeun3joproject.appspot.com/o/user%2FuserProfile.png?alt=media';
    return defaultImageUrl;
  } catch (e) {
    print('디폴트 프로필 이미지 가져오기 오류: $e');
    throw e;
  }
}

// 출력 화면 로직
class UserIdListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? userId = Provider.of<UserModel>(context).userId; // UserModel에서 사용자 아이디 받아오기
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
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('오류 발생: ${snapshot.error}');
                                  } else {
                                    String? imageUrl = snapshot.data;
                                    if (imageUrl != null) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Member(userId: userIds[index]),
                                            ),
                                          );
                                        },
                                        child: Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                          width: 50,
                                          height: 50,
                                        ),
                                      );
                                    } else {
                                      return Image.asset('/assets/user/userProfile.png');
                                    }
                                  }
                                },
                              )
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
                                    onPressed: (){
                                      followUser(userId!, userIds[index]);
                                    },
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