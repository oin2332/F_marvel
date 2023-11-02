import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {

  Stream<QuerySnapshot>? _commentsStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _commentsStream = FirebaseFirestore.instance
        .collection('T3_STORE_TBL')
        .snapshots();
  }


  Widget testfb() {
    return  StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('T3_STORE_TBL')
          .snapshots(),
      // * AsyncSnapshot : Stream에서 가장 최신의 snapShot을 가져오기 위한 클래스
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        // * 데이터를 받아오기 전 대기 상태일 때 화면 처리
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final docs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: docs.length, // * 데이터 갯수
          itemBuilder: (context, index) {
            return ListTile(
              // * message의 field명 'text'로 값 받아오기
              title: Text(docs[index]['KEYWORD1']),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            testfb()
          ],
        ),
      ),
    );
  }
}
