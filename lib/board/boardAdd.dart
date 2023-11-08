import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_marvel/board/boardView.dart';
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
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _selectPics,
                        icon: Icon(Icons.add_circle),
                      ),
                      SizedBox(height: 10),
                      if (_selectedImages.isNotEmpty)
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          children: List.generate(_selectedImages.length, (index) {
                            return Container(
                              height: 100,
                              child: Image.file(_selectedImages[index]),
                            );
                          }),
                        ),
                      if (_selectedImages.isEmpty)
                        Text('사진 추가'),
                      Text('${_selectedImages.length} / 15')
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


