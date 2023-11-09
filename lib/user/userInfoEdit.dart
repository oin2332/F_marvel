import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_marvel/user/easyLogin.dart';
import 'package:food_marvel/user/nameEdit.dart';
import 'package:food_marvel/user/notificationSetting.dart';
import 'package:food_marvel/user/phoneEdit.dart';
import 'package:food_marvel/user/pwdEdit.dart';
import 'package:food_marvel/user/userModel.dart';
import 'package:food_marvel/user/userUnlogin.dart';
import 'package:provider/provider.dart';
class UserInfoEdit extends StatefulWidget {
  const UserInfoEdit({super.key});

  @override
  State<UserInfoEdit> createState() => _UserInfoEditState();
}

class _UserInfoEditState extends State<UserInfoEdit> {
  List<String> genderOptions = ['남성', '여성', '선택안함'];
  String selectedGender = '선택안함'; // 추가: 선택된 성별을 저장할 변수

  String? uName;
  String? uPhone;
  String? uGender;

  // 유저 정보 출력
  void fetchUserData(String userId) async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('T3_USER_TBL')
          .where('id', isEqualTo: userId)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in userSnapshot.docs) {
          Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
          String? name = userData['name'];
          String? phone = userData['phone'];
          String? pwd = userData['pwd'];
          String? gender = userData['gender'];
          print('name: $name, phone: $phone, gender: $gender');
          if (name != null || phone != null) {
            // 사용자 정보를 각 컨트롤러에 할당
            setState(() {
              uName = name!;
              uPhone = phone!;
            });
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

  void _selectGender(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: ListView.builder(
            itemCount: genderOptions.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(genderOptions[index]),
                onTap: () {
                  setState(() {
                    selectedGender = genderOptions[index]; // 선택된 성별을 저장
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
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
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {Navigator.pop(context);},
          ),
          title: Text('내 정보 수정', style: TextStyle(color: Colors.black)), backgroundColor: Colors.white,elevation: 0),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => NameEdit()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('이름(실명)을 입력해주세요', style: TextStyle(color: Colors.grey[600]!)),
                        Text('$uName', style: TextStyle(color: Colors.grey[400]!, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Icon(Icons.keyboard_arrow_right, color: Colors.black),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => PhoneEdit()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('휴대폰 번호', style: TextStyle(color: Colors.grey[600]!)),
                        Text('$uPhone', style: TextStyle(color: Colors.grey[400]!, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Icon(Icons.keyboard_arrow_right, color: Colors.black),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => PwdEdit()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('비밀번호', style: TextStyle(color: Colors.grey[600]!)),
                        Text('미설정', style: TextStyle(color: Colors.grey[400]!, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Icon(Icons.keyboard_arrow_right, color: Colors.black),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => EasyLogin()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('간편로그인 설정', style: TextStyle(color: Colors.grey[600]!)),
                        Text('카카오', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Icon(Icons.keyboard_arrow_right, color: Colors.black),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(height: 1, width: 180, color: Colors.grey,margin: EdgeInsets.only(left: 8.0),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  _selectGender(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('성별', style: TextStyle(color: Colors.grey[600]!)),
                        Text(selectedGender, style: TextStyle(color: Colors.grey[400]!, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Icon(Icons.keyboard_arrow_right, color: Colors.black),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(height: 6, width: 180, color: Colors.grey[400]!, margin: EdgeInsets.only(left: 2.0)
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationSetting()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('알림설정', style: TextStyle(color: Colors.grey[600]!))
                      ],
                    ),
                    Icon(Icons.keyboard_arrow_right, color: Colors.black),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(height: 6, width: 180, color: Colors.grey[400]!, margin: EdgeInsets.only(left: 2.0)
            ),
            SizedBox(height: 20),
            Container(
              alignment: Alignment.centerLeft,
              child: TextButton(
                  onPressed: (){
                    userModel.logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => UserUnlogin()),
                    );
                  },
                  child: Text('로그아웃', style: TextStyle(color: Colors.grey[400]!))),
            ),
            SizedBox(height: 20),
            Container(height: 6, width: 180, color: Colors.grey[400]!, margin: EdgeInsets.only(left: 2.0)
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('회원탈퇴를 하시려면', style: TextStyle(color: Colors.grey[400]!)),
                TextButton(onPressed: (){}, child: Text('여기', style: TextStyle(color: Colors.grey[400]!, fontWeight: FontWeight.bold))),
                Text('를 눌러주세요', style: TextStyle(color: Colors.grey[400]!))
              ],
            )
          ],
        ),
      ),
    );
  }
}
