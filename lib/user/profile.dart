import 'package:flutter/material.dart';


void main() => runApp(MaterialApp(
  title: 'Home',
  home: Profile(),
  debugShowCheckedModeBanner: false,
));

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void _openPopupMenu(BuildContext context) {
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final width = overlay.size.width;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        Offset(width - 40, kToolbarHeight + 30), // x, y 좌표를 조절하여 위치를 조정합니다.
        Offset(width, kToolbarHeight + 60), // x, y 좌표를 조절하여 위치를 조정합니다.
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'block',
          child: ListTile(
            title: Text('사용자 차단'),
          ),
        ),
        PopupMenuItem<String>(
          value: 'report',
          child: ListTile(
            title: Text('사용자 신고'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text("프로필", style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              _openPopupMenu(context);
            },
            child: Icon(Icons.more_horiz, color: Colors.grey),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              // 프로필 이미지 (왼쪽에 배치)
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/1.jpg'),
              ),
              SizedBox(width: 16), // 각 요소 사이의 간격 조절
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 사용자 닉네임
                  Text(
                    '사용자 닉네임',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // 팔로우, 팔로잉, 인스타그램 연결 버튼
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // 팔로우 버튼 클릭 시 동작
                        },
                        child: Text('팔로우'),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          // 인스타그램 연결 버튼 클릭 시 동작
                        },
                        child: Text('인스타그램 연결'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // 팔로잉 및 팔로워 수
          Text('팔로잉: 100 | 팔로워: 200'),
          // 자기 소개
          Text(
            '안녕하세요! 저는 사용자의 자기 소개 내용입니다.',
            style: TextStyle(fontSize: 16),
          ),
          // 게시물 목록 (ListView 또는 GridView를 사용하여 추가)
        ],
      ),
    );
  }
}