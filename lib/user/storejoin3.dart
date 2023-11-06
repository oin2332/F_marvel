import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
  final TextEditingController _FLOOR = TextEditingController();
  final TextEditingController S_MENU1 = TextEditingController();
  final TextEditingController S_MENU1_1 = TextEditingController();
  final TextEditingController S_MENU2 = TextEditingController();
  final TextEditingController S_MENU2_1 = TextEditingController();
  final TextEditingController S_MENU3 = TextEditingController();
  final TextEditingController S_MENU3_1 = TextEditingController();
  final TextEditingController S_MENU4 = TextEditingController();
  final TextEditingController S_MENU4_1 = TextEditingController();



  String? gender;

  void _addSTORE() async {
 /*   if (!_idChecked) {
      return; // 중복 아이디 확인이 성공하지 않은 경우, 가입을 중단
    }

    if (_pwd.text != _pwd2.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('패스워드 다르자너')),
      );
      return;
    }*/

    if (_id.text.isNotEmpty && _pwd.text.isNotEmpty) {
      FirebaseFirestore fs = FirebaseFirestore.instance; // 싱글톤 구성
      CollectionReference STORE = fs.collection("T3_STORE_TBL");

      CollectionReference CONVENIENCE = STORE.doc().collection("T3_CONVENIENCE_TBL");
      CollectionReference TIME = STORE.doc().collection("T3_TIME_TBL");
      CollectionReference MENU = STORE.doc().collection("T3_MENU_TBL");


      await STORE.add({
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
      await TIME.add({
        'S_RE_TIME1' : _Time1,
        'S_RE_TIME2' : _Time2,
        'S_RE_TIME3' : _Time3,
        'S_RE_TIME4' : _Time4,
        'S_RE_TIME5' : _Time5,
        'S_RE_TIME6' : _Time6,
        'S_RE_TIME7' : _Time7,
        'S_RE_TIME8' : _Time8,
        'S_RE_TIME9' : _Time9,
        'S_RE_TIME10' : _Time10,
        'S_RE_TIME11' : _Time11,
        'S_RE_TIME12' : _Time12,
        'S_RE_TIME13' : _Time13,
        'S_RE_TIME14' : _Time14,
        'S_RE_TIME15' : _Time15,

      });
      await MENU.add({

      });
      await CONVENIENCE.add({
        'S_ELEVA' : S_ELEVA,
        'S_FLOOR' : _S_FLOOR,
        'S_GROUP' : _S_GROUP,
        'S_KID' : _S_KID,
        'S_NOKID' : _S_NOKID,
        'S_PARKING' : _S_PARKING,
        'S_STAIRS' : _S_STAIRS,
        'S_TOILET' : _S_TOILET,
        'S_WR' : _S_WR,
        'S_FLOORtext' : _FLOOR,

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

  // 아이디 중복 체크
  bool? _isIdAvailable; // 아이디 사용 가능 여부를 나타내는 변수
  bool _idChecked = false; // 아이디 중복 여부 확인 여부를 나타내는 변수

  void _checkDuplicateId() async {
    // String id = _id.text;
    String id = _id.text.trim();

    // Firestore에서 해당 아이디를 가진 사용자가 있는지 확인
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('T3_USER_TBL')
        .where('id', isEqualTo: id)
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

  //아이콘 편의기능
  bool S_ELEVA = false;
  String? _S_ELEVA;
  bool S_FLOOR = false;
  String? _S_FLOOR = '';
  bool S_GROUP = false;
  String? _S_GROUP;
  bool S_KID = false;
  String? _S_KID;
  bool S_NOKID = false;
  String? _S_NOKID;
  bool S_PARKING = false;
  String? _S_PARKING;
  bool S_STAIRS = false;
  String? _S_STAIRS;
  bool S_TOILET = false;
  String? _S_TOILET;
  bool S_WR = false;
  String? _S_WR;
  //시간선택
  bool Time1 = false;
  String? _Time1 = '11:00';
  bool Time2 = false;
  String? _Time2 = '12:00';
  bool Time3 = false;
  String? _Time3 = '13:00';
  bool Time4 = false;
  String? _Time4 = '14:00';
  bool Time5 = false;
  String? _Time5 = '15:00';
  bool Time6 = false;
  String? _Time6 = '16:00';
  bool Time7 = false;
  String? _Time7 = '17:00';
  bool Time8 = false;
  String? _Time8 = '18:00';
  bool Time9 = false;
  String? _Time9 = '19:00';
  bool Time10 = false;
  String? _Time10 = '20:00';
  bool Time11 = false;
  String? _Time11 = '21:00';
  bool Time12 = false;
  String? _Time12 = '22:00';
  bool Time13 = false;
  String? _Time13 = '23:00';
  bool Time14 = false;
  String? _Time14 = '24:00';
  bool Time15 = false;
  String? _Time15 = '24시간';


  Widget _butlist(bool valch, String? valuetext, String valueiconText, String text, Function(bool, String?) onChanged) {
    return Row(
      children: [
        Checkbox(
          value: valch,
          onChanged: (value) {
            onChanged(value!, valueiconText); // onChanged 콜백 호출
          },
          activeColor: Colors.deepOrange[300]!,
        ),
        TextButton(
          onPressed: (){},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(text, style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ),
        Icon(Icons.keyboard_arrow_right, color: Colors.black)
      ],
    );
  }



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
            Column(
              children: [
                Text('편의기능체크'),
                  _butlist(S_ELEVA, _S_ELEVA, 'elevator.png', '엘리베이터', (value, iconText) {
                  setState(() {
                  S_ELEVA = value;
                  _S_ELEVA = value ? iconText : null;
                  });
                  }),
                _butlist(S_GROUP, _S_GROUP, 'group.png', '단체가능/불가', (value, iconText) {
                  setState(() {
                    S_GROUP = value;
                    _S_GROUP = value ? iconText : null;
                  });
                }),
                _butlist(S_KID, _S_KID, 'kid.png', '키즈존', (value, iconText) {
                  setState(() {
                    S_KID = value;
                    _S_KID = value ? iconText : null;
                  });
                }),
                _butlist(S_NOKID, _S_NOKID, 'nokid.png', 'no키즈존', (value, iconText) {
                  setState(() {
                    S_NOKID = value;
                    _S_NOKID = value ? iconText : null;
                  });
                }),
                _butlist(S_PARKING, _S_PARKING, 'parking.png', '주차장', (value, iconText) {
                  setState(() {
                    S_PARKING = value;
                    _S_PARKING = value ? iconText : null;
                  });
                }),
                _butlist(S_TOILET, _S_TOILET, 'toilet.png', '화장실유무', (value, iconText) {
                  setState(() {
                    S_TOILET = value;
                    _S_TOILET = value ? iconText : null;
                  });
                }),
                _butlist(S_WR, _S_WR, 'takeout.png', '포장', (value, iconText) {
                  setState(() {
                    S_WR = value;
                    _S_WR = value ? iconText : null;
                  });
                }),
                _butlist(S_FLOOR, _S_FLOOR, 'floor.png', '층수 체크후 아래 적어주세요', (value, iconText) {
                  setState(() {
                    S_FLOOR = value;
                    _S_FLOOR = value ? iconText : null;
                  });
                }),


                Text('층수', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextField(
                  controller: _FLOOR,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200]!, // 배경색 설정
                    hintText: '가게층수 EX) 1층or 지하1층',
                    hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                    border: InputBorder.none, // 밑줄 없애기
                  ),
                  style: TextStyle(fontSize: 13),
                ),

                //시간
                _butlist(Time1, _Time1, '11:00', '11시', (value, iconText) {
                  setState(() {
                    Time1 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time2, _Time1, '12:00', '12시', (value, iconText) {
                  setState(() {
                    Time2 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time3, _Time1, '13:00', '13시', (value, iconText) {
                  setState(() {
                    Time3 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time4, _Time1, '14:00', '14시', (value, iconText) {
                  setState(() {
                    Time4 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time5, _Time1, '15:00', '15시', (value, iconText) {
                  setState(() {
                    Time5 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time6, _Time1, '16:00', '16시', (value, iconText) {
                  setState(() {
                    Time6 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time7, _Time1, '17:00', '17시', (value, iconText) {
                  setState(() {
                    Time7 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time8, _Time1, '18:00', '18시', (value, iconText) {
                  setState(() {
                    Time8 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time9, _Time1, '19:00', '19시', (value, iconText) {
                  setState(() {
                    Time9 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time10, _Time1, '20:00', '20시', (value, iconText) {
                  setState(() {
                    Time10 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time11, _Time1, '21:00', '21시', (value, iconText) {
                  setState(() {
                    Time11 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time12, _Time1, '22:00', '22시', (value, iconText) {
                  setState(() {
                    Time12 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time13, _Time1, '23:00', '23시', (value, iconText) {
                  setState(() {
                    Time13 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time14, _Time1, '24:00', '24시', (value, iconText) {
                  setState(() {
                    Time14 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),
                _butlist(Time15, _Time1, '24시간', '24시간', (value, iconText) {
                  setState(() {
                    Time15 = value;
                    _Time1 = value ? iconText : null;
                  });
                }),


              ],
            ),
            Column(
              children: [
                SizedBox(height: 5),
                Text('메뉴', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextField(
                  controller: S_MENU1,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200]!, // 배경색 설정
                    hintText: '메뉴이름',
                    hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                    border: InputBorder.none, // 밑줄 없애기
                  ),
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(height: 5),
                Text('가격', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextField(
                  controller: S_MENU1_1,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200]!, // 배경색 설정
                    hintText: '5만원 or 30,000 ~ 500,000원 ',
                    hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                    border: InputBorder.none, // 밑줄 없애기
                  ),
                  style: TextStyle(fontSize: 13),
                ),

                SizedBox(height: 5),
                Text('메뉴', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextField(
                  controller: S_MENU2,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200]!, // 배경색 설정
                    hintText: '메뉴이름',
                    hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                    border: InputBorder.none, // 밑줄 없애기
                  ),
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(height: 5),
                Text('가격', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextField(
                  controller: S_MENU2_1,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200]!, // 배경색 설정
                    hintText: '5만원 or 30,000 ~ 500,000원 ',
                    hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                    border: InputBorder.none, // 밑줄 없애기
                  ),
                  style: TextStyle(fontSize: 13),
                ),

                SizedBox(height: 5),
                Text('메뉴', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextField(
                  controller: S_MENU3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200]!, // 배경색 설정
                    hintText: '메뉴이름',
                    hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                    border: InputBorder.none, // 밑줄 없애기
                  ),
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(height: 5),
                Text('가격', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextField(
                  controller: S_MENU3_1,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200]!, // 배경색 설정
                    hintText: '5만원 or 30,000 ~ 500,000원 ',
                    hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                    border: InputBorder.none, // 밑줄 없애기
                  ),
                  style: TextStyle(fontSize: 13),
                ),

                SizedBox(height: 5),
                Text('메뉴', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextField(
                  controller: S_MENU4,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200]!, // 배경색 설정
                    hintText: '메뉴이름',
                    hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                    border: InputBorder.none, // 밑줄 없애기
                  ),
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(height: 5),
                Text('가격', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextField(
                  controller: S_MENU4_1,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200]!, // 배경색 설정
                    hintText: '5만원 or 30,000 ~ 500,000원 ',
                    hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                    border: InputBorder.none, // 밑줄 없애기
                  ),
                  style: TextStyle(fontSize: 13),
                ),


              ],
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
              onPressed: (){_addSTORE();},
              child: Text('다음'),
            )
          ],
        ),
      ),
    );
  }
}