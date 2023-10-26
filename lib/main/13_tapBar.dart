import 'package:flutter/material.dart';

class Sample13 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("탭BAR 실습"),
            bottom: TabBar(
              tabs: [
                Tab(text: '보노1'),
                Tab(text: '보노2'),
                Tab(text: '오리'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Center(child: Image.asset('assets/1.jpg')),
              Center(child: Image.asset('assets/2.jpg')),
              Center(child: Image.asset('assets/duck.jpg')),
            ],

          ),
        ),
      ),
    );
  }
}
