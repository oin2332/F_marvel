import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../user/userModel.dart';

class BoardAdd extends StatefulWidget {
  const BoardAdd({super.key});

  @override
  State<BoardAdd> createState() => _BoardAddState();
}

class _BoardAddState extends State<BoardAdd> {

  // 입력 데이터 변수
  final TextEditingController _title = TextEditingController();
  final TextEditingController _content = TextEditingController();

  String? index;
  String? uId;
  String? like;
  String? sId;
  String? comment;
  String? url;

  String? _selectUser;

  bool isContentValid = false; // 리뷰 글 작성 감지

  //CRUD - Create,Add
  void _addBoard() async {
    if (_title.text.isNotEmpty && _content.text.isNotEmpty) {
      FirebaseFirestore fs = FirebaseFirestore.instance; // 싱글톤 구성
      CollectionReference review = fs.collection("T3_REVIEW_TBL"); // 리뷰 컬렉션 이름 -> T3_REVIEW_TBL

      //리뷰 컬렉션 데이터 입력
      await review.add({
        'index' : index,
        'u_id' : uId,
        'title': _title.text,
        'content': _content.text,
        'r_img_url' : url,
        'like' : like,
        'comment' : comment,
        's_id' : sId,
        'timestamp' : FieldValue.serverTimestamp(),
      });

      _title.clear();
      _content.clear();
    } else {
      print("제목 또는 내용을 입력해주세요.");
    }
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
      String fileName = 'R' + DateTime.now().millisecondsSinceEpoch.toString() + '.jpg'; // 현재시간기준으로 파일 이름 자동생성
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('review') // 선택된 이미지 파일을 저장할 Firebase Storage 폴더 이름
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
      String userId = uId ?? '';
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


  // 이미지 선택 + 업로드 + 미리보기
  List<File> _selectedImages = []; // 선택된 이미지들을 저장하는 리스트

  Image? _selectedImage; // 선택된 이미지를 저장하는 변수

  // void _selectPic() async {
  //   final imagePicker = ImagePicker();
  //
  //   // 앨범에서 사진을 선택
  //   final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery); // 단일 이미지 선택
  //
  //   if (pickedFile != null) {
  //     setState(() {
  //       _selectedImage = Image.file(File(pickedFile.path)); // 선택된 파일을 File로 변환하여 리스트에 추가
  //     });
  //   }
  // }

  void _selectPics() async {
    final imagePicker = ImagePicker();

    final pickedFiles = await imagePicker.pickMultiImage(); // 다중 이미지 선택

    if (pickedFiles != null) {
      setState(() {
        _selectedImages.addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)).toList());
      });
    }
  }

  // 모달창으로 전체보기
  void _showAllImages() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('전체 이미지 미리보기'),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              children: List.generate(_selectedImages.length, (index) {
                return Container(
                  height: 100,
                  child: Image.file(_selectedImages[index]),
                );
              }),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // 별점 기능
  double _rating = 0.0; // 초기 별점 설정

  void _onRatingUpdate(double rating) {
    setState(() {
      _rating = rating;
    });
  }



  @override
  Widget build(BuildContext context) {
    // UserModel에서 사용자 아이디 받아오기
    UserModel userModel = Provider.of<UserModel>(context);
    String? userId = userModel.userId;
    uId = userId;
    print('현재 로그인 아이디 : $uId');

    return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            title: Text('리뷰 작성', style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios))),
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  width: double.infinity,
                  height: 400,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_selectedImages.length < 4)
                            IconButton(
                              onPressed: _selectPics,
                              icon: Icon(Icons.add_circle),
                            ),
                          SizedBox(height: 10),
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            children: List.generate(_selectedImages.length, (index) {
                              return Container(
                                height: 100,
                                child: Image.file(
                                  _selectedImages[index],
                                  fit: BoxFit.cover, // 이미지를 컨테이너에 맞게 크기 조절
                                ),
                              );
                            }),
                          ),
                          if (_selectedImages.length >= 4 && _selectedImages.length < 5)
                            GestureDetector(
                              onTap: _showAllImages,
                              child: Container(
                                height: 100,
                                color: Colors.grey[200],
                                child: Icon(Icons.add, size: 50),
                              ),
                            ),
                        ],
                      ),
                      if (_selectedImages.length >= 4 && _selectedImages.length < 5)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.add_circle, color: Colors.black),
                            onPressed: _showAllImages,
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 10),
                TextField(
                  controller: _content,
                  onChanged: (text) {
                    setState(() {
                      isContentValid = text.isNotEmpty; // 입력값이 비어있지 않다면 true로 설정
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "경험이나 정보를 자세히 작성할수록...",
                  ),
                ),
                SizedBox(height: 5),
                Text('FoodMarvel 리뷰 작성 정책을 위반하는 경우에는 숨김 처리 될 수 있습니다.', style: TextStyle(fontSize: 10)),
                SizedBox(height: 20),
                TextField(
                  controller: _title,
                  onChanged: (text) {
                    setState(() {
                      isContentValid = text.isNotEmpty; // 입력값이 비어있지 않다면 true로 설정
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "가게 이름",
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                    onPressed: (){},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('방문한 날짜', style: TextStyle(color: Colors.black)),
                        Icon(Icons.arrow_forward_ios, color: Colors.black)
                      ],
                    )),
                RatingBar(
                  initialRating: _rating,
                  itemSize: 40,
                  glowColor: Colors.amber,
                  allowHalfRating: true,
                  onRatingUpdate: (value) {
                    setState(() {
                      _rating = value;
                    });
                  },
                  ratingWidget: RatingWidget(
                    full: Icon(Icons.star, color: Colors.amber),
                    half: Icon(Icons.star_half, color: Colors.amber),
                    empty: Icon(Icons.star_border, color: Colors.amber),
                  ),
                ),
                ElevatedButton(
                  onPressed: isContentValid ? _addBoard : null, // 입력값이 유효할 때만 버튼 활성화
                  child: Text("작성 완료"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey; // 비활성화 상태일 때 배경색
                      }
                      return Theme.of(context).primaryColor; // 활성화 상태일 때 기본 테마의 primary color
                    }),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.white; // 비활성화 상태일 때 텍스트 색상
                      }
                      return Colors.white; // 활성화 상태일 때 텍스트 색상 (기본은 흰색)
                    }),
                  ),
                ),
              ],
            )
          ),
        ),
    );
  }
}


