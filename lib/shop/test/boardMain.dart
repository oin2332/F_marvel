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
  final TextEditingController _silplemono = TextEditingController();
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
        'S_SILPLEMONO': _silplemono.text,
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
      _silplemono.clear();

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
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 20),
                        Container(
                          width: 80,
                          height: 110, // 원하는 높이 설정
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Image.asset(
                            'assets/storePageIMG/${data['S_IMG']}',
                            fit: BoxFit.cover,
                          ),
                        ),

                        SizedBox(width: 13),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${data['S_NAME']}',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  Text('${data['S_SILPLEMONO']}'),
                                  Row(
                                    children: [
                                      Icon(Icons.star, size: 25, color: Colors.yellow[600]),
                                      Text(
                                        '4.7',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        '(123)',
                                        style: TextStyle(fontSize: 11, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${data['S_ADDR1']} ${data['S_ADDR2']} ${data['S_ADDR3']}',
                                    style: TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                  Text(
                                    '${data['S_TIME']}',
                                    style: TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                ],
                              ),
                              onTap: (){
                              },
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {

                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFFFF6347),
                                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                  ),
                                  child: Text('13:00'),
                                ),
                                SizedBox(width: 6),
                                ElevatedButton(
                                  onPressed: () {

                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFFFF6347),
                                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                  ),
                                  child: Text('18:00'),
                                ),
                                SizedBox(width: 6),
                                ElevatedButton(
                                  onPressed: () {

                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFFFF6347),
                                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                  ),
                                  child: Text('21:00'),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          ).toList(),
        );

      },
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
                _textfield(_silplemono,'간단한 가게설명'),
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

