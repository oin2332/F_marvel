import 'package:flutter/material.dart';

import 'function/Tab.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late Future<List<Map<String, dynamic>>> noticeData;

  @override
  void initState() {
    super.initState();
    noticeData = fetchNoticeDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 탭의 개수 (공지와 알림 두 개)
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {Navigator.pop(context);},
          ),
          title: Text('알림', style: TextStyle(color: Colors.black)), backgroundColor: Colors.white,elevation: 0, // 그림자를 제거
          bottom: TabBar(
            tabs: [
              Tab(text: '공지'), // 첫 번째 탭
              Tab(text: '알림'), // 두 번째 탭
            ],
            labelColor: Colors.black, // 선택된 탭의 텍스트 색상
            labelStyle: TextStyle(fontWeight: FontWeight.bold), // 선택된 탭의 텍스트 bold
            unselectedLabelColor: Colors.grey, // 선택되지 않은 탭의 텍스트 색상
            indicatorColor: Colors.red, // 선택된 탭 바 색상
          ),
        ),
        body: TabBarView(
          children: [
            NoticeTab(), // 공지 탭의 내용
            AlertTab(), // 알림 탭의 내용
          ],
        ),
      ),
    );
  }
}


