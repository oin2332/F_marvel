import 'package:flutter/material.dart';
import 'package:food_marvel/etc/conditionInfo.dart';
import 'package:food_marvel/etc/locationInfo.dart';
import 'package:food_marvel/etc/privacyInfo.dart';

class ConditionList extends StatelessWidget {
  const ConditionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text('약관 및 정책', style: TextStyle(color: Colors.black)), elevation: 0),
      body: ListView(
        children: [
          TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (_) => ConditionInfo()));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('이용약관', style: TextStyle(color: Colors.black)),
                    Icon(Icons.keyboard_arrow_right, color: Colors.black)
                  ],
                ),
              ),
          ),
          TextButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_) => PrivacyInfo()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('개인정보 처리방침', style: TextStyle(color: Colors.black)),
                  Icon(Icons.keyboard_arrow_right, color: Colors.black)
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_) => LocationInfo()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('위치정보 이용약관', style: TextStyle(color: Colors.black)),
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
