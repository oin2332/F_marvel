import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_marvel/shop/Addshop/storejoin2.dart';
import 'package:image_picker/image_picker.dart';
import '../../board/boardAdd.dart';
import '../../firebase/firebase_options.dart';
import '../../user/loginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_marvel/user/bdayRegister.dart';
import 'package:food_marvel/user/flavorChoice.dart';
import 'package:food_marvel/user/snsConnect.dart';
import 'package:food_marvel/user/userModel.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StoreJoin extends StatefulWidget {
  StoreJoin({super.key});

  @override
  State<StoreJoin> createState() => _JoinState();
}

class _JoinState extends State<StoreJoin> {

  final TextEditingController _id = TextEditingController();
  final TextEditingController _pwd = TextEditingController();
  final TextEditingController _pwd2 = TextEditingController();
  final TextEditingController _keyword1 = TextEditingController();
  final TextEditingController _keyword2 = TextEditingController();
  final TextEditingController _keyword3 = TextEditingController();
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
  String? imgPro;

  bool checkStore = false;

  void _addSTORE() async {
    //_uploadImage();
    if (_id.text.isNotEmpty && _pwd.text.isNotEmpty) {
      FirebaseFirestore fs = FirebaseFirestore.instance;
      CollectionReference STORE = fs.collection("T3_STORE_TBL");

      DocumentReference newDocRef = STORE.doc(); // 새 문서에 대한 DocumentReference를 가져옵니다

      // 데이터 추가
      await newDocRef.set({
        'KEYWORD1': _keyword1.text,
        'KEYWORD2': _keyword2.text,
        'KEYWORD3': _keyword3.text,
        'S_ADDR1': _addr1.text,
        'S_ADDR2': _addr2.text,
        'S_ADDR3': _addr3.text,
        'S_BREAKTIME': _baerktime.text,
        'S_HOMEPAGE': _homepage.text,
        'S_ID': storeid+_id.text,
        'S_PWD': _pwd.text,
        'S_IMG': imgPro,
        'S_INFO1': _info.text,
        'S_MEMO': _memo.text,
        'S_NUMBER': _number.text,
        'S_NAME': _name.text,
        'S_PAY': _pay.text,
        'S_RE_MEMO': _noshow.text,
        'S_TIME': _time.text,
        'S_SILPLEMONO': _silplemono.text,

        'timestamp': FieldValue.serverTimestamp(),
      });

      // newDocRef.id를 StoreJoin2로 전달하거나 다른 방식으로 활용할 수 있습니다
      String documentId = newDocRef.id;
      print(documentId);

      _id.clear();
      _pwd.clear();
      _keyword1.clear();
      _keyword2.clear();
      _keyword3.clear();
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

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StoreJoin2(storeDocumentId: documentId))
      );
    } else {
      print("제목 또는 내용을 입력해주세요.");
    }
  }

  String storeid = 'store';

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

  File? _imageFile;
  final picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      return; // 이미지가 없으면 업로드 중단
    }

    try {
      // Firebase Storage에 이미지 업로드
      Reference storageReference =
      FirebaseStorage.instance.ref().child('storeImg/${DateTime.now().toString()}');
      UploadTask uploadTask = storageReference.putFile(_imageFile!);

      await uploadTask.whenComplete(() => null);

      // 업로드 완료 후 이미지 URL 획득
      imgPro = await storageReference.getDownloadURL();

      // 여기에서 imageUrl을 사용하여 필요한 작업을 수행하세요 (예: 이미지 URL을 Firestore에 저장)

      print('이미지가 업로드되었습니다. URL: $imgPro');
    } catch (e) {
      print('이미지 업로드 중 오류 발생: $e');
    }
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
        Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile == null
                ? Text('No image selected.')
                : Image.file(_imageFile!),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: Text('겔러리 사진 등록'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('이미지 업데이트하기'),
            ),
          ],
        ),
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
            Text('분위기 키워드', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: _keyword1,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200]!, // 배경색 설정
                hintText: ',으로 띄워서 쓰기 ',
                hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                border: InputBorder.none, // 밑줄 없애기
              ),
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 5),
            Text('인기토픽 ( 메뉴 )', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: _keyword2,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200]!, // 배경색 설정
                hintText: '곱창전골, 버거 , 고기집, ',
                hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                border: InputBorder.none, // 밑줄 없애기
              ),
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 5),
            Text('찾는목적(키워드)', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: _keyword3,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200]!, // 배경색 설정
                hintText: '싱싱한,재방문,데이트, ',
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
                hintText: '가게공지 ',
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
            Text('간판 간단한설명 * 길지않게', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    // 값이 없는 경우 버튼 비활성화
                        if ( imgPro == null ||
                            _pwd.text.isEmpty ||
                            _id.text.isEmpty ||
                            _keyword1.text.isEmpty ||
                            _keyword2.text.isEmpty ||
                            _addr1.text.isEmpty ||
                            _addr2.text.isEmpty ||
                            _addr3.text.isEmpty ||
                            _name.text.isEmpty ||
                            _info.text.isEmpty) {
                          return Colors.grey[300] ?? Colors.grey; // Null이면 기본값으로 Colors.grey 사용
                        }
                        return Colors.deepOrange[400] ?? Colors.deepOrange; // Null이면 기본값으로 Colors.deepOrange 사용
                      },
                ),
              ),
              onPressed: () {
                // 값이 있는 경우에만 _addSTORE 함수 호출
                if ( imgPro != null ||
                    _pwd.text.isNotEmpty &&
                    _id.text.isNotEmpty &&
                    _keyword1.text.isNotEmpty &&
                    _keyword2.text.isNotEmpty &&
                    _addr1.text.isNotEmpty &&
                    _addr2.text.isNotEmpty &&
                    _addr3.text.isNotEmpty &&
                    _name.text.isNotEmpty &&
                    _info.text.isNotEmpty) {
                  return _addSTORE();
                }
              },
              child: Text('가게'),
            ),
          ],
        ),
      ),
    );
  }
}