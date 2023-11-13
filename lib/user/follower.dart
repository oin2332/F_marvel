import 'package:flutter/material.dart';
import 'package:food_marvel/user/function/User.dart';
import 'package:food_marvel/user/userModel.dart';
import 'package:provider/provider.dart';

import 'function/Follow.dart';

class Follower extends StatefulWidget {
  const Follower({super.key});

  @override
  State<Follower> createState() => _FollowerState();
}

class _FollowerState extends State<Follower> {
  //
  String? uId;
  List<String> followers = []; // 팔로워 리스트 추가

  @override
  void initState() {
    super.initState();
    _loadFollowers(); // initState에서 호출하여 화면이 로드될 때 팔로워를 불러옴
  }

  // 팔로워 호출
  Future<void> _loadFollowers() async {
    print('initState 동작 확인');
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    String? userId = userModel.userId;

    if (userId != null) {
      List<String> fetchedFollowers = await getUserFollowers(userId);

      setState(() {
        print('setState 동작 확인');
        followers = fetchedFollowers;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // UserModel에서 사용자 아이디 받아오기
    UserModel userModel = Provider.of<UserModel>(context);
    String? userId = userModel.userId;
    uId = userId;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('팔로워', style: TextStyle(color: Colors.black)), backgroundColor: Colors.white, elevation: 0, // 그림자를 제거
      ),
      body: followers.isEmpty ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('아직 팔로워가 없습니다.'),
            Text('다른 사람이 팔로우 하면 여기에 표시됩니다.',
                style: TextStyle(fontSize: 10)),
          ],
        ),
      )
          : ListView.builder(
        shrinkWrap: true,
        itemCount: followers.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        child: ClipOval(
                          child: FutureBuilder<String?>(
                            future: fetchProfileImageUrl(followers[index]),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('오류 발생: ${snapshot.error}');
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
                                  return Image.asset('assets/user/userProfile.png');
                                }
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(followers[index])
                    ],
                  )
              ),
              SizedBox(height: 10)
            ],
          );
        },
      )
    );
  }
}