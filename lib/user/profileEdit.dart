import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_marvel/user/bdayRegister.dart';
import 'package:food_marvel/user/flavorChoice.dart';
import 'package:food_marvel/user/snsConnect.dart';
import 'package:food_marvel/user/userModel.dart';
import 'package:provider/provider.dart';


class ProfileEdit extends StatefulWidget {

  // final String userId; // 사용자 ID를 받아오는 변수 추가
  // ProfileEdit({required this.userId}); // 생성자 추가


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
          .collection('T3_USER_TBL') // 'T3_USER_TBL'는 사용자 데이터가 저장된 컬렉션의 이름입니다. 실제로 사용하는 컬렉션 이름으로 바꿔주세요.
          .where('userId', isEqualTo: userId) // userId 필드가 특정 값인 문서를 가져옵니다. userId에는 현재 로그인한 사용자의 ID가 들어가야 합니다.
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        Map<String, dynamic> userData = userSnapshot.docs[0].data() as Map<String, dynamic>;
        String nickname = userData['nickname']; // 'nickname'은 사용자 닉네임 필드입니다. 필드 이름을 실제로 사용하는 필드로 바꿔주세요.
        String intro = userData['intro']; // 'intro'는 사용자 자기소개 필드입니다. 필드 이름을 실제로 사용하는 필드로 바꿔주세요.
        String location = userData['area']; // 'location'은 사용자 활동지역 필드입니다. 필드 이름을 실제로 사용하는 필드로 바꿔주세요.

        // 사용자 정보를 각 컨트롤러에 할당
        _nicknameController.text = nickname;
        _introController.text = intro;
        _areaController.text = location;
      } else {
        print('해당 사용자를 찾을 수 없습니다.');
      }
    } catch (e) {
      print('데이터를 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? userId = Provider.of<UserModel>(context).userId; // UserModel에서 사용자 아이디 받아오기
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text('프로필 수정', style: TextStyle(color: Colors.black),)),
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
                      decoration: InputDecoration(
                        labelText: '닉네임을 설정해주세요.',
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(color: Colors.grey[400]!, fontSize: 14),
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
                        labelText: '자신을 알릴 수 있는 소개글을 작성해주세요.',
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(color: Colors.grey[400]!, fontSize: 14,),
                        contentPadding: EdgeInsets.symmetric(vertical: 40),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2.0)),
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
                        labelText: '활동지역을 자유롭게 입력해주세요.',
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(color: Colors.grey[400]!, fontSize: 14),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2.0),
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