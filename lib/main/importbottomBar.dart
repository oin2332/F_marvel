import 'package:flutter/material.dart';
import 'package:food_marvel/board/timeLine.dart';
import 'package:food_marvel/main/mainPage.dart';
import 'package:food_marvel/search/navSearch.dart';
import 'package:food_marvel/user/userUnlogin.dart';
import 'package:provider/provider.dart';

import '../reservation/RtabBar.dart';
import '../user/userMain.dart';
import '../user/userModel.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context);
    return BottomAppBar(
      child: Container(
        height: 50,
        color: Color.fromRGBO(255, 255, 255, 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));},
                child: Icon(Icons.home_outlined,size: 30),),
            InkWell(
              onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => NavSearch()));
              }, child: Icon(Icons.saved_search, size: 30),),
            InkWell(onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TimeLine()));
            },  child: Icon(Icons.message_outlined, size: 28),),
            InkWell(onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ResTabBar()));
            }, child: Icon(Icons.calendar_today_outlined, size: 28),),
            InkWell(onTap: () {
              if (userModel.isLogin) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserMain()));
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserUnlogin()));
              }
            }, child: Icon(Icons.person_outline_outlined, size: 30),),
          ],
        ),
      ),
    );
  }
}
