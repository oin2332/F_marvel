import 'package:flutter/material.dart';
import 'package:food_marvel/board/function/Board.dart';


class Temp extends StatefulWidget {
  const Temp({super.key});

  @override
  State<Temp> createState() => _TempState();
}

class _TempState extends State<Temp> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('타임라인', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(80.0),
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(text: '추천'),
                    Tab(text: '팔로잉'),
                  ],
                  labelColor: Colors.black,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.red,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(width: 5),
                      _menubutton('오마카세'),
                      SizedBox(width: 5),
                      _menubutton('스테이크'),
                      SizedBox(width: 5),
                      _menubutton('카페'),
                      SizedBox(width: 5),
                      _menubutton('한식'),
                      SizedBox(width: 5),
                      _menubutton('중식'),
                      SizedBox(width: 5),
                      _menubutton('일식'),
                      SizedBox(width: 5),
                      _menubutton('양식'),
                      SizedBox(width: 5),
                      _menubutton('아시안'),
                      SizedBox(width: 5),
                      _menubutton('치킨'),
                      SizedBox(width: 5),
                      _menubutton('피자'),
                      SizedBox(width: 5),
                      _menubutton('햄버거'),
                      SizedBox(width: 5),
                      _menubutton('분식'),
                      SizedBox(width: 5),
                      _menubutton('포장마차'),
                      SizedBox(width: 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            RecomendTab(),
            FollowingTab(),
          ],
        ),
      ),
    );
  }

  Widget _menubutton(String text) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // 타원형 모양을 위한 값
          side: BorderSide(color: Colors.grey[300]!), // 테두리 색상을 변경
        ),
        primary: Colors.white, // 배경색을 흰색으로 설정
        onPrimary: Colors.deepOrangeAccent[100]!, // 선택된 상태일 때 버튼 색상 변경
        onSurface: Colors.deepOrangeAccent[400]!, // 선택된 상태일 때 텍스트 색상 변경
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[600]!, // 글씨를 검은색으로 설정
        ),
      ),
    );
  }
}



