import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// 추천탭
class RecomendTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child:_buildReviewList(),
      ),
    );
  }
}

// 팔로잉탭
class FollowingTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Image.asset('assets/user/notification.jpg') // 알림 내용이 아무 것도 없을 때
            //알림 내용 있을 때 동작 코드 작성 해야함.
          ],
        ),
      ),
    );
  }
}

Widget _buildReviewList() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('T3_REVIEW_TBL').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return CircularProgressIndicator();
      }

      var reviews = snapshot.data!.docs;
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListView.builder(
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            var review = reviews[index];
            var title = review['title'];
            var content = review['content'];
            var imageUrls = (review['r_img_urls'] as List<dynamic>).cast<String>(); // 수정된 부분
            var rating = review['rating'];
            var uId = review['u_id'];

            return Column(
              children: [
                SizedBox(height: 10),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // 프로필 사진
                          Container(
                            width: 50,
                            height: 50,
                            child: ClipOval(
                              child: FutureBuilder<String?>(
                                future: fetchProfileImageUrl(uId!),
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
                                      return Image.asset('assets/user/userProfile.png');
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(uId, style: TextStyle(fontWeight: FontWeight.bold)), // 리뷰 작성자 아이디
                              Text('리뷰 23개, 평균별점 4.1'), // 리뷰 갯수, 평균 별점
                            ],
                          ),
                        ],
                      ),
                      ElevatedButton( // 팔로우 버튼
                            onPressed: (){},
                            style: ElevatedButton.styleFrom(
                              primary: Colors.deepOrange[400]!, // 원하는 색상으로 변경
                            ),
                            child: Text('팔로우', style: TextStyle(fontWeight: FontWeight.bold))
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                _buildImageSlider(imageUrls),
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerLeft,
                    child: Icon(Icons.star, color: Colors.amber) // 내가 준 별점
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(content) // 리뷰 작성 내용
                ),
                // 음식점 정보 리스트타일, 댓글, 좋아요 등 추가
                SizedBox(height: 10),
                Container(height: 10, width: 410, color: Colors.grey[300]!),
              ],
            );
          },
        ),
      );
    },
  );
}

Widget _buildImageSlider(List<String> imageUrls) {
  return Container(
    height: 400,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            width: 380,
            child: ClipRRect( // ClipRRect를 사용하여 이미지의 경계를 둥글게 함
              borderRadius: BorderRadius.circular(10), // 원하는 값을 설정
              child: Image.network(
                imageUrls[index],
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    ),
  );
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

