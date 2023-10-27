import 'package:flutter/material.dart';

class TabBarpage extends StatefulWidget {
  const TabBarpage({super.key});

  @override
  State<TabBarpage> createState() => _TabBarpageState();
}

class _TabBarpageState extends State<TabBarpage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:  Container(
        child: TabBar(
          // title아래라는 의미로 bottom
          tabs: [
            Tab(text: '고양이11',),
            Tab(text: '고양이22',),
            Tab(text: '고양이33',),
          ],
        ),
      ),
    );
  }
}
