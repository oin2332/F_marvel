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

  ImagePicker _picker = ImagePicker();
  Image? _selectedImage; // 선택된 이미지를 저장하는 변수

  String newNickname = ''; // 변경 할 닉네임
  String newArea = ''; // 변경 할 활동 지역
  String newIntro = ''; // 변경 할 자기 소개
  String newImg = ''; // 변경 할 프로필 사진

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
          String? nickname = userData['nickname'];
          String? intro = userData['intro'];
          String? area = userData['area'];
          String? Pimg = userData['profile_image'];
          print('nickname: $nickname, intro: $intro, area: $area');
          if (nickname != null || intro != null || area != null || Pimg != null) {
            // 사용자 정보를 각 컨트롤러에 할당
            _nicknameController.text = nickname!;
            _introController.text = intro!;
            _areaController.text = area!;
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

  // 닉네임 수정
  void updateNicknameInFirestore(String userId, String newNickname) async {
    try {

      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('T3_USER_TBL')
          .where('id', isEqualTo: userId)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = userSnapshot.docs.first;
        await doc.reference.update({'nickname': newNickname});
        print('닉네임이 업데이트되었습니다.');
      } else {
        print('해당 사용자를 찾을 수 없습니다.');
      }
    } catch (e) {
      print('닉네임 업데이트 중 오류 발생: $e');
    }
  }

  // 활동 지역 수정
  void updateAreaInFirestore(String userId, String newArea) async {
    try {

      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('T3_USER_TBL')
          .where('id', isEqualTo: userId)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = userSnapshot.docs.first;
        await doc.reference.update({'area': newArea});
        print('활동지역이 업데이트되었습니다.');
      } else {
        print('해당 사용자를 찾을 수 없습니다.');
      }
    } catch (e) {
      print('활동지역 업데이트 중 오류 발생: $e');
    }
  }

  // 자기 소개 수정
  void updateIntroInFirestore(String userId, String newIntro) async {
    try {

      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('T3_USER_TBL')
          .where('id', isEqualTo: userId)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = userSnapshot.docs.first;
        await doc.reference.update({'intro': newIntro});
        print('자기소개가 업데이트되었습니다.');
      } else {
        print('해당 사용자를 찾을 수 없습니다.');
      }
    } catch (e) {
      print('자기소개 업데이트 중 오류 발생: $e');
    }
  }

  // 프로필 사진 수정
  void updatePimgInFirestore(String userId, String newImg) async {
    try {

      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('T3_USER_TBL')
          .where('id', isEqualTo: userId)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = userSnapshot.docs.first;
        await doc.reference.update({'intro': newImg});
        print('프로필 사진이 업데이트 되었습니다.');
      } else {
        print('해당 사용자를 찾을 수 없습니다.');
      }
    } catch (e) {
      print('프로필 사진 업데이트 중 오류 발생: $e');
    }
  }

  //이미지
  // 유저 프로필 이미지 출력
  Future<String?> fetchProfileImageUrl(String userId) async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('T3_USER_TBL')
          .where('id', isEqualTo: userId)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in userSnapshot.docs) {
          Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
          return userData['profile_image'];
        }
      } else {
        print('해당 사용자를 찾을 수 없습니다.');
      }
    } catch (e) {
      print('데이터를 불러오는 중 오류가 발생했습니다: $e');
      throw e;
    }

    return null;
  }

  //프로필 사진을 선택하는 부분에 대한 로직
  void _pickImage() async {
    ImagePicker _picker = ImagePicker(); // ImagePicker 객체 선언 및 초기화
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // 이미지를 Firebase Storage에 업로드하고 URL을 받아옵니다.
      String imageUrl = await uploadImageToStorage(pickedFile);

      // Firestore에 이미지 URL을 저장합니다.
      updateProfileImageInFirestore(imageUrl);

      // 미리보기 이미지 업데이트
      setState(() {
        _selectedImage = Image.file(File(pickedFile.path));
      });
    }
    Navigator.pop(context); // 모달 바텀 시트 닫기
  }

  // Firebase Storage에 이미지를 업로드하는 함수
  Future<String> uploadImageToStorage(XFile pickedFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg'; // 현재시간기준으로 파일 이름 자동생성
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('user') // 선택된 이미지 파일을 저장할 Firebase Storage 폴더 이름
          .child(fileName);

      await ref.putFile(File(pickedFile.path));

      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('이미지 업로드 중 오류 발생: $e');
      throw e;
    }
  }

  // Firestore에 이미지 URL을 업데이트하는 함수
  void updateProfileImageInFirestore(String imageUrl) async {
    try {
      String userId = widget.userId ?? '';
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('T3_USER_TBL')
          .where('id', isEqualTo: userId)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot doc = userSnapshot.docs.first;
        await doc.reference.update({'profile_image': imageUrl});
        print('프로필 이미지가 업데이트되었습니다.');
      } else {
        print('해당 사용자를 찾을 수 없습니다.');
      }
    } catch (e) {
      print('프로필 이미지 업데이트 중 오류 발생: $e');
    }
  }
//----------------------
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


  //화면
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
                                  onTap: () async {
                                    _pickImage();
                                    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                                    if (pickedFile != null) {
                                      // 이미지를 Firebase Storage에 업로드하고 URL을 받아옵니다.
                                      String imageUrl = await uploadImageToStorage(pickedFile);

                                      // Firestore에 이미지 URL을 저장합니다.
                                      updateProfileImageInFirestore(imageUrl);

                                      Navigator.pop(context); // 모달 바텀 시트 닫기
                                    }
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
                        width: 100,
                        height: 100,
                        child: ClipOval(
                          child: FutureBuilder<String?>(
                            future: fetchProfileImageUrl(widget.userId!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator(); // 데이터를 기다리는 동안 로딩 표시
                              } else if (snapshot.hasError) {
                                return Text('오류 발생: ${snapshot.error}');
                              } else {
                                String? imageUrl = snapshot.data;
                                if (imageUrl != null) {
                                  return Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover, // 이미지가 원 안에 꽉 차게 표시됩니다.
                                    width: 100,
                                    height: 100,
                                  );
                                } else {
                                  return Image.asset('assets/user/userProfile.png');
                                }
                              }
                            },
                          ),
                        ),
                      )
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
                        onChanged: (newIntro) {
                          // 자기소개 변경될 때 호출되는 함수
                          String userId = widget.userId ?? ''; // 사용자 ID가 없는 경우를 대비하여 빈 문자열로 초기화
                          updateIntroInFirestore(userId, newIntro);// 파이어스토어에 업데이트된 닉네임 전달
                        },
                        decoration: InputDecoration(
                          hintText: '자신을 알릴 수 있는 소개글을 작성해주세요.',
                          alignLabelWithHint: true,
                          hintStyle: TextStyle(color: Colors.grey[400]!,
                            fontSize: 14,),
                          contentPadding: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
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
                        onChanged: (newArea) {
                          // 활동 지역 변경 호출 함수
                          String userId = widget.userId ?? ''; // 사용자 ID가 없는 경우를 대비하여 빈 문자열로 초기화
                          updateAreaInFirestore(userId, newArea);
                        },
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
