import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_marvel/user/storejoin2.dart';
import '../board/boardAdd.dart';
import '../firebase/firebase_options.dart';
import 'loginPage.dart';

class StoreJoin extends StatefulWidget {
  StoreJoin({super.key});

  @override
  State<StoreJoin> createState() => _JoinState();
}

class _JoinState extends State<StoreJoin> {

  final TextEditingController _id = TextEditingController();
  final TextEditingController _pwd = TextEditingController();
  final TextEditingController _pwd2 = TextEditingController();
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


  String? gender;

  void _addSTORE() async {
    if (_id.text.isNotEmpty && _pwd.text.isNotEmpty) {
      FirebaseFirestore fs = FirebaseFirestore.instance;
      CollectionReference STORE = fs.collection("T3_STORE_TBL");

      DocumentReference newDocRef = STORE.doc(); // 새 문서에 대한 DocumentReference를 가져옵니다

      // 데이터 추가
      await newDocRef.set({
        'KEYWORD1': _keyword1.text,
        'KEYWORD2': _keyword2.text,
        'S_ADDR1': _addr1.text,
        // 나머지 필드 추가

        'timestamp': FieldValue.serverTimestamp(),
      });

      // newDocRef.id를 StoreJoin2로 전달하거나 다른 방식으로 활용할 수 있습니다
      String documentId = newDocRef.id;

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

      /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StoreJoin2(documentId)),
      );*/
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

  // 아이디 중복 체크
  bool? _isIdAvailable; // 아이디 사용 가능 여부를 나타내는 변수
  bool _idChecked = false; // 아이디 중복 여부 확인 여부를 나타내는 변수

  void _checkDuplicateId() async {
    // String id = _id.text;
    String id = _id.text.trim();

    // Firestore에서 해당 아이디를 가진 사용자가 있는지 확인
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('T3_STORE_TBL')
        .where('S_ID', isEqualTo: id)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // 해당 아이디가 이미 존재하는 경우
      setState(() {
        _isIdAvailable = false; // 아이디 사용 불가능
      });
    } else {
      // 해당 아이디가 사용 가능한 경우
      setState(() {
        _isIdAvailable = true; // 아이디 사용 가능
      });
    }
  }

  // 가입 버튼 비활성화
/*
  bool _canRegister() { //null 이 되면 안되는것들
    return  _id.text.isNotEmpty && _pwd.text.isNotEmpty &&
        _pwd2.text.isNotEmpty && _name.text.isNotEmpty && _addr1.text.isNotEmpty
        && _addr2.text.isNotEmpty && _addr3.text.isNotEmpty  && _pay.text.isNotEmpty
        && _time.text.isNotEmpty && _silplemono.text.isNotEmpty && _keyword1.text.isNotEmpty
        && _info.text.isNotEmpty && _img.text.isNotEmpty
    ;
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.white,elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('가게 데이터 넣기',style: TextStyle(color: Colors.black),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Text('아이디', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              onChanged: (value) {
                  _checkDuplicateId();
              },
              controller: _id,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200]!, // 배경색 설정
                hintText: '아이디',
                hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                border: InputBorder.none, // 밑줄 없애기
              ),
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 5),if (_isIdAvailable == false)
              Text(
                '이미 사용 중인 아이디입니다.',
                style: TextStyle(color: Colors.red),
              ),
            if (_isIdAvailable == true)
              Text(
                '사용 가능한 아이디입니다.',
                style: TextStyle(color: Colors.blue),
              ),
            SizedBox(height: 30),
            Text('비밀번호', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: _pwd,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200]!, // 배경색 설정
                hintText: '비밀번호',
                hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                border: InputBorder.none, // 밑줄 없애기
              ),
              style: TextStyle(fontSize: 13),
              obscureText: true, // 비밀번호 숨기기
            ),
            SizedBox(height: 30),
            Text('비밀번호 확인', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: _pwd2,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200]!, // 배경색 설정
                hintText: '비밀번호 확인',
                hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                border: InputBorder.none, // 밑줄 없애기
              ),
              style: TextStyle(fontSize: 13),
              obscureText: true, // 비밀번호 숨기기
            ),
            SizedBox(height: 30),
            Text('이름', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: _name,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200]!, // 배경색 설정
                hintText: '가게이름',
                hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                border: InputBorder.none, // 밑줄 없애기
              ),
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 5),
            Text('휴대폰 번호', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: _number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200]!, // 배경색 설정
                hintText: '휴대폰 번호',
                hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                border: InputBorder.none, // 밑줄 없애기
              ),
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 5),
            Text('카테고리', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: _info,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200]!, // 배경색 설정
                hintText: '메인페이지 버튼 카테고리이름',
                hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                border: InputBorder.none, // 밑줄 없애기
              ),
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 5),
            Text('키워드1', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: _keyword1,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200]!, // 배경색 설정
                hintText: '키워드1',
                hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                border: InputBorder.none, // 밑줄 없애기
              ),
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 5),
            Text('키워드2', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: _keyword2,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200]!, // 배경색 설정
                hintText: '키워드2',
                hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                border: InputBorder.none, // 밑줄 없애기
              ),
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 5),
            Text('주소(시)', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: _addr1,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200]!, // 배경색 설정
                hintText: '주소(시)',
                hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                border: InputBorder.none, // 밑줄 없애기
              ),
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 5),
            Text('주소(읍)', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: _addr2,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200]!, // 배경색 설정
                hintText: '주소(읍)',
                hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                border: InputBorder.none, // 밑줄 없애기
              ),
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 5),
            Text('주소(동)', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: _addr3,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200]!, // 배경색 설정
                hintText: '주소(동)',
                hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                border: InputBorder.none, // 밑줄 없애기
              ),
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 5),
            Text('이미지 확장자명까지', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: _img,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200]!, // 배경색 설정
                hintText: '이미지 확장자명까지',
                hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                border: InputBorder.none, // 밑줄 없애기
              ),
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 5),
            Text('브레이크타임', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: _baerktime,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200]!, // 배경색 설정
                hintText: '없으면 공백으로',
                hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                border: InputBorder.none, // 밑줄 없애기
              ),
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 5),
            Text('홈페이지', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: _homepage,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200]!, // 배경색 설정
                hintText: '없으면 공백으로',
                hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                border: InputBorder.none, // 밑줄 없애기
              ),
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 5),
            Text('가게공지', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: _memo,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200]!, // 배경색 설정
                hintText: '상세페이지용',
                hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                border: InputBorder.none, // 밑줄 없애기
              ),
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 5),
            Text('금액', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: _pay,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200]!, // 배경색 설정
                hintText: '1 ~ 3 만원',
                hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                border: InputBorder.none, // 밑줄 없애기
              ),
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 5),
            Text('노쇼경고문', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: _noshow,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200]!, // 배경색 설정
                hintText: '없어도되지않을까?',
                hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                border: InputBorder.none, // 밑줄 없애기
              ),
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 5),
            Text('운영시간', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: _time,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200]!, // 배경색 설정
                hintText: 'ex) 11:00 ~ 21:00 ',
                hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                border: InputBorder.none, // 밑줄 없애기
              ),
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 5),
            Text('운영시간', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: _silplemono,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200]!, // 배경색 설정
                hintText: '리스트에보이는 간단한 메모',
                hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                border: InputBorder.none, // 밑줄 없애기
              ),
              style: TextStyle(fontSize: 13),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey[300]!; // 비활성화 상태일 때 배경색을 회색으로 지정
                    }
                    return Colors.deepOrange[400]!; // 활성화 상태일 때 배경색을 주황색으로 지정
                  },
                ),
              ),
              onPressed: (){
                _addSTORE();
                },
              child: Text('가게'),
            ),
          ],
        ),
      ),
    );
  }
}