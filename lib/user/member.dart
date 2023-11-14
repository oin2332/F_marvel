import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../board/function/Board.dart';

class Member extends StatefulWidget {
  final String userId;
  Member({required this.userId});

  @override
  State<Member> createState() => _MemberState();
}

class _MemberState extends State<Member> {
  String? nickname;
  String? profileImageUrl;

  // 사용자 정보를 Firestore에서 가져오는 함수
  Future<void> fetchUserProfile(String userId) async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('T3_USER_TBL')
          .where('id', isEqualTo: userId)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        Map<String, dynamic> userData = userSnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          nickname = userData['nickname'];
          profileImageUrl = userData['profile_image'];
        });
      } else {
        print('해당 사용자를 찾을 수 없습니다.');
      }
    } catch (e) {
      print('데이터를 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // 페이지가 로드될 때 사용자 정보를 가져오는 함수 호출
    fetchUserProfile(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('마이페이지',style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications,color: Colors.grey),
            onPressed: () {
              //Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationPage()));
            },
          ),IconButton(
            icon: Icon(Icons.settings,color: Colors.grey),
            onPressed: () {
              //Navigator.push(context, MaterialPageRoute(builder: (_) => UserSetting()));
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 20,),
            Row(
              children: [
                SizedBox(width: 5),
                Container(
                  width: 100,
                  height: 100,
                  child: ClipOval(
                    child: FutureBuilder<String?>(
                      future: fetchProfileImageUrl(widget.userId!),
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
                              width: 100,
                              height: 100,
                            );
                          } else {
                            return Image.asset('assets/user/userProfile.png');
                          }
                        }
                      },
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text('$nickname', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                    Row(
                      children: [
                        TextButton(
                            onPressed: (){
                              //Navigator.push(context, MaterialPageRoute(builder: (_) => Following()));
                            },
                            child: Text('팔로잉',style: TextStyle(color: Colors.grey),)),
                        Text('|'),
                        TextButton(
                            onPressed: (){
                              //Navigator.push(context, MaterialPageRoute(builder: (_) => Follower()));
                            },
                            child: Text('팔로워',style: TextStyle(color: Colors.grey),)),
                      ],
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileEdit(userId: userId)));
                },
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
                    Size(double.infinity, 50), // 버튼의 너비와 높이를 조절
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(10.0)),
                  minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 0)),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange[400]!),
                  elevation: MaterialStateProperty.all<double>(0),
                  overlayColor: MaterialStateProperty.all<Color>(Colors.deepOrange[400]!), // 터치 효과 색상
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white), // border 색상 black
                      borderRadius: BorderRadius.circular(30), // 버튼 테두리 모양 조정
                    ),
                  ),
                ),
                child: Text('팔로우', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(height: 10),
            Column(
              children: [
                Text('등록된 리뷰가 없습니다', style: TextStyle(color: Colors.grey[400]!),textAlign: TextAlign.center,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
