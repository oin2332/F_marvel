import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import '../../board/boardView.dart';
import '../../firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _id = TextEditingController();
  final TextEditingController _pwd = TextEditingController();
  final TextEditingController _img = TextEditingController();
  final TextEditingController _keyword1 = TextEditingController();
  final TextEditingController _keyword2 = TextEditingController();
  final TextEditingController _addr1 = TextEditingController();
  final TextEditingController _addr2 = TextEditingController();
  final TextEditingController _addr3 = TextEditingController();
  final TextEditingController _baerktime = TextEditingController();
  final TextEditingController _homepage = TextEditingController();
  final TextEditingController _info = TextEditingController();
  final TextEditingController _memo = TextEditingController();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _pay = TextEditingController();
  final TextEditingController _noshow = TextEditingController();
  final TextEditingController _time = TextEditingController();
  String? _selectUser;

  //CRUD - Create,Add
  void _addBoard() async {
    if (_id.text.isNotEmpty && _pwd.text.isNotEmpty) {
      FirebaseFirestore fs = FirebaseFirestore.instance; // 싱글톤 구성
      CollectionReference board = fs.collection("T3_STORE_TBL");

      await board.add({
        'KEYWORD1': _keyword1.text,
        'KEYWORD2': _keyword2.text,
        'S_ADDR1': _addr1.text,
        'S_ADDR2': _addr2.text,
        'S_ADDR3': _addr3.text,
        'S_BREAKTIME': _baerktime.text,
        'S_HOMEPAGE': _homepage.text,
        'S_ID': _id.text,
        'S_PWD': _pwd.text,
        'S_IMG': _img.text,
        'S_INFO1': _info.text,
        'S_MEMO': _memo.text,
        'S_NUMBER': _number.text,
        'S_NAME': _name.text,
        'S_PAY': _pay.text,
        'S_RE_MEMO': _noshow.text,
        'S_TIME': _time.text,
        'timestamp' : FieldValue.serverTimestamp(),
      });
      _id.clear();
      _pwd.clear();
      _img.clear();
      _keyword1.clear();
      _keyword2.clear();
      _addr1.clear();
      _addr2.clear();
      _addr3.clear();
      _baerktime.clear();
      _homepage.clear();
      _info.clear();
      _memo.clear();
      _number.clear();
      _name.clear();
      _pay.clear();
      _noshow.clear();
      _time.clear();

    } else {
      print("제목 또는 내용을 입력해주세요.");
    }
  }

  Widget _textfield(Controller, String txt) {
    return Container(
      width: 200, // 원하는 너비 설정
      child: TextField(
        controller: Controller,
        decoration: InputDecoration(
          labelText: txt,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _listUser() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("T3_STORE_TBL").orderBy("timestamp", descending: true).snapshots(),
      ///////////////////users/////////////////////
      //게시글 정렬 후 출력 (orderBy(descending: ,))
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap){
        if(!snap.hasData) {
          return Transform.scale(
            scale: 0.1,
            child: CircularProgressIndicator(strokeWidth: 20),
          );
        }
        return ListView(
          children: snap.data!.docs.map(
                (DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return RadioListTile(
                title: Text(data['S_ID']),
                subtitle: Column(
                  children: [
                    Text("KEYWORD1: ${data['KEYWORD1']}"),
                    Text("KEYWORD2: ${data['KEYWORD2']}"),
                    Text("S_ADDR1: ${data['S_ADDR1']}"),
                    Text("S_ADDR2: ${data['S_ADDR2']}"),
                    Text("S_ADDR3: ${data['S_ADDR3']}"),
                    Text("S_BREAKTIME: ${data['S_BREAKTIME']}"),
                    Text("S_HOMEPAGE: ${data['S_HOMEPAGE']}"),
                    Text("S_ID: ${data['S_ID']}"),
                    Text("S_PWD: ${data['S_PWD']}"),
                    Text("S_IMG: ${data['S_IMG']}"),
                    Text("S_INFO1: ${data['S_INFO1']}"),
                    Text("S_MEMO: ${data['S_MEMO']}"),
                    Text("S_NUMBER: ${data['S_NUMBER']}"),
                    Text("S_NAME: ${data['S_NAME']}"),
                    Text("S_PAY: ${data['S_PAY']}"),
                    Text("S_RE_MEMO: ${data['S_RE_MEMO']}"),
                    Text("S_TIME: ${data['S_TIME']}"),

                  ],
                ),
                value: document.id, // 선택된 값을 Document ID로 설정
                groupValue: _selectUser,
                onChanged: (value) {

                },
              );
            },
          ).toList(),
        );
      },
    );
  }

  Widget _textFieldRow(List<Widget> textFields) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: textFields,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Firestore")),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    _textfield(_id,'아이디'),
                    _textfield(_pwd,'비번'),
                    _textfield(_img,'이미지파일이름 확장자 까지'),
                    _textfield(_keyword1,'키워드 음식'),
                  ],
                ),
                Row(
                  children: [
                    _textfield(_keyword2,'ex:) 레스토랑'),
                    _textfield(_addr1,'시'),
                    _textfield(_addr2,'읍'),
                    _textfield(_addr3,'동/ 상세주소'),
                  ],
                ),
                Row(
                  children: [
                    _textfield(_baerktime,'브레이크타임'),
                    _textfield(_homepage,'홈페이지'),
                    _textfield(_info,'카테고리/양식/중식'),
                    _textfield(_memo,'가게설명'),
                  ],
                ),

                Row(
                  children: [
                    _textfield(_number,'가게번호'),
                    _textfield(_name,'가게이름'),
                    _textfield(_pay,'평균 가격 ex) 5~10만원'),
                    _textfield(_noshow,'노쇼 경고'),
                  ],
                ),
                _textfield(_time,'운영시간 ex) 10:00 ~ 21:00'),
                ElevatedButton(
                  onPressed: _addBoard,
                  child: Text("게시글 추가!"),
                ),

                Expanded(child: _listUser())
              ],
            ),
          ),
        ),
      ),
    );
  }
}

