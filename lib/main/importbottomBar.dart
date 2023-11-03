import 'package:flutter/material.dart';
import 'package:food_marvel/board/timeLine.dart';
import 'package:food_marvel/main/mainPage.dart';
import 'package:food_marvel/search/navSearch.dart';
import 'package:food_marvel/user/userUnlogin.dart';
import 'package:provider/provider.dart';

import '../reservation/RtabBar.dart';
import '../user/userMain.dart';
import '../user/userModel.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 로그인 세션
    UserModel userModel = Provider.of<UserModel>(context);
    return BottomAppBar(
      child: Container(
        height: 50,
        color: Color.fromRGBO(255, 255, 255, 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
              },
              child: Icon(Icons.home,size: 30,),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NavSearch()));
              },
              child: Icon(Icons.search,size: 30),
            ),
            InkWell(onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TimeLine()));
            }, child: Icon(Icons.message,size: 30)),
            InkWell(onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ResTabBar()));
            }, child: Icon(Icons.calendar_today_rounded,size: 30)),
            InkWell(onTap: () {
              if (userModel.isLogin) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserMain()));
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserUnlogin()));
              }
            }, child: Icon(Icons.person,size: 30)),
          ],
        ),
      ),
    );
  }
}