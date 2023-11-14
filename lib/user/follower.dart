import 'package:flutter/material.dart';
import 'package:food_marvel/user/function/User.dart';
import 'package:food_marvel/user/userModel.dart';
import 'package:provider/provider.dart';

import 'function/Follow.dart';

class Follower extends StatefulWidget {
  const Follower({Key? key});

  @override
  State<Follower> createState() => _FollowerState();
}

class _FollowerState extends State<Follower> {
  String? uId;
  List<String> followers = [];

  Future<void> _unfollowFollower(String userId) async {
    await unfollowFollower(uId!, userId);
    _loadFollowers();
  }

  @override
  void initState() {
    super.initState();
    _loadFollowers();
  }

  Future<void> _loadFollowers() async {
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    String? userId = userModel.userId;

    if (userId != null) {
      List<String> fetchedFollowers = await getUserFollowers(userId);
      setState(() {
        followers = fetchedFollowers;
      });
    }
  }



  void _confirmUnfollowerDialog(String userName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('팔로우를 취소하시겠습니까?'),
          content: Text('정말 $userName 님의 팔로우를 취소하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('예'),
              onPressed: () {
                Navigator.of(context).pop();
                _unfollowFollower(userName);
              },
            ),
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context);
    String? userId = userModel.userId;
    uId = userId;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('팔로워', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: followers.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('아직 팔로워가 없습니다.'),
            Text(
              '다른 사람이 팔로우 하면 여기에 표시됩니다.',
              style: TextStyle(fontSize: 10),
            ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
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
                        Text(followers[index]),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _confirmUnfollowerDialog(followers[index]);
                      },
                      style: ElevatedButton.styleFrom(primary: Color(0xFFFF6347)),
                      child: Text('삭제'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10)
            ],
          );
        },
      ),
    );
  }
}