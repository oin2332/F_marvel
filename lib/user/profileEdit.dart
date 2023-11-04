import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_marvel/user/bdayRegister.dart';
import 'package:food_marvel/user/flavorChoice.dart';
import 'package:food_marvel/user/snsConnect.dart';
import 'package:food_marvel/user/userModel.dart';
import 'package:provider/provider.dart';


class ProfileEdit extends StatefulWidget {
  final String? userId; // 사용자 ID를 받아오는 변수 추가
  ProfileEdit({required this.userId}); // 생성자 추가

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final TextEditingController _nicknameController = TextEditingController(); // 닉네임
  final TextEditingController _introController = TextEditingController(); // 자기 소개
  final TextEditingController _areaController = TextEditingController(); // 활동 지역

  void fetchUserData(String userId) async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('T3_USER_TBL')
          .where('id', isEqualTo: userId)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in userSnapshot.docs) {
          Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
          String? nickname = userData['nickname'];
          String? intro = userData['intro'];
          String? location = userData['area'];

          if (nickname != null && intro != null && location != null) {
            // 사용자 정보를 각 컨트롤러에 할당
            _nicknameController.text = nickname;
            _introController.text = intro;
            _areaController.text = location;
          } else {
            print('사용자 정보가 누락되었습니다.');
          }
        }
      } else {
        print('해당 사용자를 찾을 수 없습니다.');
      }
    } catch (e) {
      print('데이터를 불러오는 중 오류가 발생했습니다: $e');
      throw e; // 오류를 다시 던져서 상위 레벨에서 처리하도록 합니다.
    }
  }

  void updateNicknameInFirestore(String userId, String newNickname) async {
    try {
      // 'T3_USER_TBL' 컬렉션에서 'id'가 userId인 문서를 찾습니다.
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('T3_USER_TBL')
          .where('id', isEqualTo: userId)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        // 문서가 존재한다면 해당 문서의 'nickname' 필드를 업데이트합니다.
        QueryDocumentSnapshot doc = userSnapshot.docs.first;
        await doc.reference.update({'nickname': newNickname});
        print('닉네임이 업데이트되었습니다.');
      } else {
        print('해당 사용자를 찾을 수 없습니다.');
      }
    } catch (e) {
      print('닉네임 업데이트 중 오류 발생: $e');
      // 오류 처리 코드 추가 (예: 사용자에게 알리거나 다른 작업 수행)
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      String? userId = Provider.of<UserModel>(context, listen: false).userId;
      if (userId != null) {
        fetchUserData(userId);
      }
    });
  }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text('프로필 수정', style: TextStyle(color: Colors.black)), elevation: 0),
        body: Padding(
          padding: const EdgeInsets.all(13.0),
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.photo),
                                  title: Text('앨범에서 선택'),
                                  onTap: () {
                                    // 앨범에서 선택하는 로직을 추가하세요
                                    // 예를 들어, 이미지 선택 코드를 넣어주세요.
                                    Navigator.pop(context); // 모달 바텀 시트 닫기
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.image),
                                  title: Text('기본 이미지로 변경'),
                                  onTap: () {
                                    // 기본 이미지로 변경하는 로직을 추가하세요
                                    Navigator.pop(context); // 모달 바텀 시트 닫기
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                          width: 100, // 너비 조절
                          height: 100, // 높이 조절
                          child: Image.asset('assets/user/userProfile.png'))
                  ),
                  SizedBox(height: 1),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                        '닉네임', style: TextStyle(color: Colors.grey[600]!)),
                  ),
                  Container(
                    width: 380, //TextField 너비 설정
                    height: 50, //TextField 높이 설정
                    child: TextField(
                        controller: _nicknameController,
                        onChanged: (newNickname) {
                          // 닉네임이 변경될 때 호출되는 함수
                          String userId = widget.userId ?? ''; // 사용자 ID가 없는 경우를 대비하여 빈 문자열로 초기화
                          updateNicknameInFirestore(userId, newNickname); // 파이어스토어에 업데이트된 닉네임 전달
                        },
                        decoration: InputDecoration(
                          hintText: '닉네임을 설정해주세요.',
                          alignLabelWithHint: true,
                          hintStyle: TextStyle(color: Colors.grey[400]!,
                              fontSize: 14),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2.0)),
                        )
                    ),
                  ),
                  SizedBox(height: 15),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                        '자기소개', style: TextStyle(color: Colors.grey[600]!)),
                  ),
                  Container(
                    width: 380, //TextField 너비 설정
                    height: 100, //TextField 높이 설정
                    child: TextField(
                        controller: _introController,
                        decoration: InputDecoration(
                          hintText: '자신을 알릴 수 있는 소개글을 작성해주세요.',
                          alignLabelWithHint: true,
                          hintStyle: TextStyle(color: Colors.grey[400]!,
                            fontSize: 14,),
                          contentPadding: EdgeInsets.symmetric(vertical: 40),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red,
                                  width: 2.0)),
                        )
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                        '활동지역', style: TextStyle(color: Colors.grey[600]!)),
                  ),
                  Container(
                    width: 380, //TextField 너비 설정
                    height: 50, //TextField 높이 설정
                    child: TextField(
                        controller: _areaController,
                        decoration: InputDecoration(
                          hintText: '활동지역을 자유롭게 입력해주세요.',
                          alignLabelWithHint: true,
                          hintStyle: TextStyle(color: Colors.grey[400]!,
                              fontSize: 14),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red,
                                width: 2.0),
                          ),
                        )
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(height: 1, width: 400, color: Colors.grey[300]!),
                  Container(
                    height: 300,
                    child: ListView(
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => SnsConnect()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('SNS 설정하기',
                                    style: TextStyle(color: Colors.grey[500]!)),
                                Icon(Icons.keyboard_arrow_right_outlined,
                                    color: Colors.grey[500]!)
                              ],
                            )
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => FlavorChoice()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('내 취향 선택하기',
                                    style: TextStyle(color: Colors.grey[500]!)),
                                Icon(Icons.keyboard_arrow_right_outlined,
                                    color: Colors.grey[500]!)
                              ],
                            )
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => BdayRegister()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('생일기념일 등록하기',
                                    style: TextStyle(color: Colors.grey[500]!)),
                                Icon(Icons.keyboard_arrow_right_outlined,
                                    color: Colors.grey[500]!)
                              ],
                            )
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
