import 'package:flutter/material.dart';

import 'function/User.dart';
import 'member.dart';

class FollowList extends StatefulWidget {
  const FollowList({super.key});

  @override
  State<FollowList> createState() => _FollowListState();
}

class _FollowListState extends State<FollowList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('친구 찾기',style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            Column(
              children: [
               UserIdListWidget()
              ],
            )
          ],
        ),
      ),
    );
  }
}


