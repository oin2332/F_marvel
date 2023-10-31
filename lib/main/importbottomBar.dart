import 'package:flutter/material.dart';
import 'package:food_marvel/main/mainPage.dart';
import 'package:food_marvel/search/navSearch.dart';

import '../user/userMain.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        height: 50,
        color: Color.fromRGBO(180, 180, 180, 0.7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
              },
              child: Icon(Icons.home),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NavSearch()));
              },
              child: Icon(Icons.search),
            ),
            InkWell(onTap: () {}, child: Icon(Icons.message)),
            InkWell(onTap: () {}, child: Icon(Icons.calendar_today_rounded)),
            InkWell(onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserMain()));
            }, child: Icon(Icons.person)),
          ],
        ),
      ),
    );
  }
}