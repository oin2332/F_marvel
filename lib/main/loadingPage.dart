import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:async';

import 'mainPage.dart';

void main() => runApp(MaterialApp(
  title: 'Home',
  home: LoadingPage(),
  debugShowCheckedModeBanner: false,
));

class LoadingPage extends StatefulWidget {
  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();

    // 3초 후에 MainPage로 이동
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        PageTransition(
          type: PageTransitionType.fade, // 페이지 전환 효과 설정
          child: MainPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/loading.png'), // loading.png 이미지를 중앙에 표시
      ),
    );
  }
}