import 'package:flutter/material.dart';
import 'package:food_marvel/etc/conditionList.dart';
import 'package:food_marvel/etc/versionInfo.dart';

class NoticeList extends StatelessWidget {
  const NoticeList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('공지사항 및 이용약관')),
      body: ListView(
        children: [
          TextButton(
            onPressed: (){},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('공지사항', style: TextStyle(color: Colors.black)),
                  Icon(Icons.keyboard_arrow_right, color: Colors.black)
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_) => ConditionList()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('약관 및 정책', style: TextStyle(color: Colors.black)),
                  Icon(Icons.keyboard_arrow_right, color: Colors.black)
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_) => VersionInfo()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('버전 정보', style: TextStyle(color: Colors.black)),
                  Icon(Icons.keyboard_arrow_right, color: Colors.black)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

