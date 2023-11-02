import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // 탭의 개수 (공지와 알림 두 개)
      child: Scaffold(
        appBar: AppBar(
          title: Text('알림'),
          bottom: TabBar(
            tabs: [
              Tab(text: '공지'), // 첫 번째 탭
              Tab(text: '알림'), // 두 번째 탭
            ],
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

class NoticeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('공지 탭 내용'),
    );
  }
}

class AlertTab extends StatelessWidget {
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
