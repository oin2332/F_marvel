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
    bool isHomeSelected = true;
    bool isSearchSelected = false;
    bool isMessageSelected = false;
    bool isCalendarSelected = false;
    bool isPersonSelected = false;

    void _toggleHomeIcon() {
      setState(() {
        isHomeSelected = true;
        isSearchSelected = false;
        isMessageSelected = false;
        isCalendarSelected = false;
        isPersonSelected = false;
      });
    }

    void _toggleSearchIcon() {
      setState(() {
        isHomeSelected = false;
        isSearchSelected = true;
        isMessageSelected = false;
        isCalendarSelected = false;
        isPersonSelected = false;
      });
    }

    void _toggleMessageIcon() {
      setState(() {
        isHomeSelected = false;
        isSearchSelected = false;
        isMessageSelected = true;
        isCalendarSelected = false;
        isPersonSelected = false;
      });
    }

    void _toggleCalendarIcon() {
      setState(() {
        isHomeSelected = false;
        isSearchSelected = false;
        isMessageSelected = false;
        isCalendarSelected = true;
        isPersonSelected = false;
      });
    }

    void _togglePersonIcon() {
      setState(() {
        isHomeSelected = false;
        isSearchSelected = false;
        isMessageSelected = false;
        isCalendarSelected = false;
        isPersonSelected = true;
      });
    }


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
                _toggleHomeIcon();
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Icon(isHomeSelected ? Icons.home : Icons.home_outlined, size: 30),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NavSearch()));
                _toggleSearchIcon();
              },
              child: Icon(isSearchSelected ? Icons.search : Icons.search_outlined, size: 30),
            ),
            InkWell(onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TimeLine()));
              _toggleMessageIcon();
            },  child: Icon(isMessageSelected ? Icons.message : Icons.message_outlined, size: 28),),
            InkWell(onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ResTabBar()));
              _toggleCalendarIcon();
            }, child: Icon(isCalendarSelected ? Icons.calendar_today : Icons.calendar_today_outlined, size: 28),),
            InkWell(onTap: () {
              if (userModel.isLogin) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserMain()));
                _togglePersonIcon();
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserUnlogin()));
              }
            }, child: Icon(isPersonSelected ? Icons.person : Icons.person_outline_outlined, size: 30),),
          ],
        ),
      ),
    );
  }
}
