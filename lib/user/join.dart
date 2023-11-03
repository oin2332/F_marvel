import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../board/boardAdd.dart';
import '../firebase/firebase_options.dart';
import 'loginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class Join extends StatefulWidget {
  const Join({super.key});

  @override
  State<Join> createState() => _JoinState();
}

class _JoinState extends State<Join> {

  final FirebaseFirestore _fs = FirebaseFirestore.instance;
  final TextEditingController _id = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _pwd = TextEditingController();
  final TextEditingController _pwd2 = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _nickname = TextEditingController();
  final TextEditingController _area = TextEditingController();
  final TextEditingController _intro = TextEditingController();



  void _register() async {
    if (!_idChecked) {
      return; // 중복 아이디 확인이 성공하지 않은 경우, 가입을 중단
    }

    if (_pwd.text != _pwd2.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('패스워드 다르자너')),
      );
      return;
    }

    try {
      await _fs.collection('T3_USER_TBL').add({
        'id': _id.text,
        'name' : _name.text,
        'pwd': _pwd.text,
        'phone': _phone.text,
        'reservation' : isInterlock,
        'under14' : isAgeAgree,
        'use' : isUseAgree,
        'privacy' : isPrivacyAgree,
        'third' : isThirdAgree,
        'select' : isSelectedAgree,
        'event' : isEventAgree,
        'nickname' : _nickname.text,
        'area' : _area.text,
        'intro' : _intro.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('가입되었음!!')),
      );

      _id.clear();
      _name.clear();
      _pwd.clear();
      _pwd2.clear();
      _phone.clear();
      _nickname.clear();

      // 가입 성공 시 로그인 페이지로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
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
  bool _canRegister() {
    return isAgeAgree && isUseAgree && isPrivacyAgree &&
        isThirdAgree && _id.text.isNotEmpty && _pwd.text.isNotEmpty &&
        _pwd2.text.isNotEmpty && _name.text.isNotEmpty && _phone.text.isNotEmpty;
  }

  //checkbox value 변수
  bool isInterlock = false; // 예약 앱에 연동
  bool isAllAgree = false; // 약관 전체 동의
  bool isAgeAgree = false; // 만 14세 이상
  bool isUseAgree = false; // 이용 약관
  bool isPrivacyAgree = false; // 개인 정보
  bool isThirdAgree = false; // 제3자
  bool isSelectedAgree = false; // 선택 개인 정보
  bool isEventAgree = false; // 이벤트 알림

  void _updateAllCheckboxes(bool value) {
    setState(() {
      isAllAgree = value;
      isAgeAgree = value;
      isUseAgree = value;
      isPrivacyAgree = value;
      isThirdAgree = value;
      isSelectedAgree = value;
      isEventAgree = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
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
                hintText: '이름',
                hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                border: InputBorder.none, // 밑줄 없애기
              ),
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 5),
            Text('레스토랑을 예약할 때 사용할 이름이므로 꼭 실명을 사용해 주세요.', style: TextStyle(color: Colors.black54, fontSize: 10)),
            SizedBox(height: 30),
            Text('휴대폰 번호', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: _phone,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200]!, // 배경색 설정
                hintText: '휴대폰 번호',
                hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                border: InputBorder.none, // 밑줄 없애기
              ),
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 30),
            Text('닉네임 (선택)', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            TextField(
              controller: _nickname,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200]!, // 배경색 설정
                hintText: '닉네임 작성은 선택 사항 입니다.',
                hintStyle: TextStyle(color: Colors.black38), // 라벨 텍스트의 색상 변경
                border: InputBorder.none, // 밑줄 없애기
              ),
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 30),
            Text('전화,링크 예약 앱에 연동하기 (선택)', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Row(
              children: [
                Checkbox(
                  value: isInterlock, // 사용자가 동의했는지 여부를 저장하는 변수와 연결해야 합니다.
                  onChanged: (bool? value) {
                    // 사용자가 체크박스를 선택했을 때의 로직을 추가하세요.
                    setState(() {
                      isInterlock = value ?? false; // checkbox selected value 업데이트
                    });
                  },
                ),
                Text('연동하기'),
              ],
            ),
            SizedBox(height: 16),
            Container(
              color: Colors.grey[200]!,
              height: 200,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('예약 연동이란?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                    SizedBox(height: 10),
                    Text('`- 전화 또는 예약 링크로 한 예약을 앱에서 관리할 수 있게 하는 기능입니다. 예약에`', style: TextStyle(fontSize: 10)),
                    Text('` 사용한 휴대폰 번호로 방문예정일을 불러올 수 있어요!`', style: TextStyle(fontSize: 10)),
                    SizedBox(height: 10),
                    Text('`- 푸드마블 가맹점 예약만 연동 가능하며,`', style: TextStyle(fontSize: 10)),
                    Text('` 연동하기 활성화 이전에 방문했던 전화 예약 내역은 불러올 수 없습니다.`', style: TextStyle(fontSize: 10)),
                    SizedBox(height: 10),
                    Text('`- 전화 또는 예약 링크로 한 예약은 각 레스토랑의 운영 정책에 따라 앱에서 예약 취소 및`', style: TextStyle(fontSize: 10)),
                    Text('` 변경이 불가능할 수 있습니다.`', style: TextStyle(fontSize: 10)),
                    SizedBox(height: 10),
                    Text('`- 예약 링크는 푸드마블 가맹점을 예약할 수 있는 웹페이지 링크를 말합니다.`', style: TextStyle(fontSize: 10)),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Checkbox(
                  value: isAllAgree, // 사용자가 동의했는지 여부를 저장하는 변수와 연결해야 합니다.
                  onChanged: (value) {
                    _updateAllCheckboxes(value!);
                  },
                ),
                TextButton(
                  onPressed: (){},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('이용자 약관 전체 동의', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_right, color: Colors.black)
              ],
            ),
            Container(height: 1, width: 250, color: Colors.grey),
            Row(
              children: [
                Checkbox(
                  value: isAgeAgree,
                  onChanged: (value) {
                    setState(() {
                      isAgeAgree = value!;
                      if (!value) {
                        isAllAgree = false;
                      }
                    });
                  },
                ),
                TextButton(
                  onPressed: (){},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('[필수] 만 14세 이상입니다.', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_right, color: Colors.black)
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: isUseAgree, // 사용자가 동의했는지 여부를 저장하는 변수와 연결해야 합니다.
                  onChanged: (value) {
                    setState(() {
                      isUseAgree = value!;
                      if (!value) {
                        isAllAgree = false;
                      }
                    });
                  },
                ),
                TextButton(
                  onPressed: (){},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('[필수] 푸드마블 이용약관 동의', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_right, color: Colors.black)
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: isPrivacyAgree, // 사용자가 동의했는지 여부를 저장하는 변수와 연결해야 합니다.
                  onChanged: (value) {
                    setState(() {
                      isPrivacyAgree = value!;
                      if (!value) {
                        isAllAgree = false;
                      }
                    });
                  },
                ),
                TextButton(
                  onPressed: (){},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('[필수] 개인정보 수집 및 이용 약관 동의', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_right, color: Colors.black)
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: isThirdAgree, // 사용자가 동의했는지 여부를 저장하는 변수와 연결해야 합니다.
                  onChanged:(value) {
                    setState(() {
                      isThirdAgree = value!;
                      if (!value) {
                        isAllAgree = false;
                      }
                    });
                  },
                ),
                TextButton(
                  onPressed: (){},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('[필수] 개인정보 제3자 제공 동의', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_right, color: Colors.black)
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: isSelectedAgree, // 사용자가 동의했는지 여부를 저장하는 변수와 연결해야 합니다.
                  onChanged: (value) {
                    setState(() {
                      isSelectedAgree = value!;
                      if (!value) {
                        isAllAgree = false;
                      }
                    });
                  },
                ),
                TextButton(
                  onPressed: (){},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('[선택] 개인정보 제공 동의', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_right, color: Colors.black)
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: isEventAgree, // 사용자가 동의했는지 여부를 저장하는 변수와 연결해야 합니다.
                  onChanged: (value) {
                    setState(() {
                      isEventAgree = value!;
                      if (!value) {
                        isAllAgree = false;
                      }
                    });
                  },
                ),
                TextButton(
                  onPressed: (){},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('[선택] 이벤트 알림 서비스 동의', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_right, color: Colors.black)
              ],
            ),

            ElevatedButton(
              onPressed: _canRegister() ? _register : null, // 가입 버튼 활성화 여부 확인
              child: Text('가입'),
            ),
          ],
        ),
      ),
    );
  }
}