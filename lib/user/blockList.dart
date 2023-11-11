import 'package:flutter/material.dart';

class BlockList extends StatefulWidget {
  const BlockList({super.key});

  @override
  State<BlockList> createState() => _BlockListState();
}

class _BlockListState extends State<BlockList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('나랑 입맛이 다른 사람들',style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Text('차단한 사람들 리스트 출력')
              ],
            ),
          )
      ),
    );
  }
}
