import 'package:flutter/material.dart';

class TabBarEx extends StatelessWidget {
  TabBarEx({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        // length는 탭의 갯수(무조건 명시해줘야 함)
        child: Scaffold(
          //child는 탭의 이름과 탭의 내용
          appBar: AppBar(
            title: Text("탭바 실습"),
            bottom: TabBar(
              // title아래라는 의미로 bottom
              tabs: [
                Tab(text: '홈',),
                Tab(text: '메뉴',),
                Tab(text: '사진',),
                Tab(text: '리뷰',),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Text('sd'),
          ),
        ),

      ),
    );
  }
}

