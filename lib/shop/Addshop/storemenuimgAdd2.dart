import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:food_marvel/shop/Addshop/storeboardAdd.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../user/userModel.dart';

class StoremenuimgAdd2 extends StatefulWidget {
  final String storeDocumentId; // docId를 받을 변수 추가

  StoremenuimgAdd2({required this.storeDocumentId});


  @override
  State<StoremenuimgAdd2> createState() => _BoardAddState();
}

class _BoardAddState extends State<StoremenuimgAdd2> {


  String? _selectUser;

  bool isContentValid = false; // 리뷰 글 작성 감지
  String? docid = "upx55IlYcUeYoFvC0L8T";
  //CRUD - Create,Add
  void _addBoard() async {
    if (true) {

      CollectionReference STOREIMG = FirebaseFirestore.instance
          .collection('T3_STORE_TBL')
          .doc(docid)
          .collection('T3_menuimg_TBL');

      List<String> imageUrls = []; // 이미지 주소들

      //
      for (File imageFile in _selectedImages) {
        XFile xFile = XFile(imageFile.path); // File을 XFile로 변환
        String imageUrl = await uploadImageToStorage(xFile); // 이미지 업로드
        imageUrls.add(imageUrl);
      }

      //리뷰 컬렉션 데이터 입력
      await STOREIMG.add({
        'r_img_urls': imageUrls, // 여러 이미지의 URL을 리스트로 저장
      });
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StoreboardAdd(storeDocumentId: widget.storeDocumentId))
      );

    } else {
      print("제목 또는 내용을 입력해주세요.");
    }
  }

  // Firebase Storage에 이미지를 업로드하는 함수
  Future<String> uploadImageToStorage(XFile pickedFile) async {
    try {
      String fileName = 'R' + DateTime.now().millisecondsSinceEpoch.toString() + '.jpg'; // 현재시간기준으로 파일 이름 자동생성
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child(docid!) // 선택된 이미지 파일을 저장할 Firebase Storage 폴더 이름
          .child(fileName);

      await ref.putFile(File(pickedFile.path));

      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('이미지 업로드 중 오류 발생: $e');
      throw e;
    }
  }

  // 이미지 선택 + 업로드 + 미리보기
  List<File> _selectedImages = []; // 선택된 이미지들을 저장하는 리스트

  void _selectPics() async {
    final imagePicker = ImagePicker();

    final pickedFiles = await imagePicker.pickMultiImage(); // 다중 이미지 선택

    if (pickedFiles != null) {
      setState(() {
        _selectedImages.addAll(pickedFiles.map((pickedFile) => File(pickedFile.path)).toList());
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text('가게 메뉴판 이미지 등록', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios))
      ),
      body: InkWell(
        onTap: _selectPics,
        child: Container(
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
                    child:PageView.builder(
                      itemCount: _selectedImages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          alignment: Alignment.center,
                          child: Image.file(
                            _selectedImages[index],
                            fit: BoxFit.cover, // 이미지를 컨테이너에 맞게 크기 조절
                          ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: isContentValid ? _addBoard : _addBoard, // 입력값이 유효할 때만 버튼 활성화
                    child: Text("작성 완료"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.grey[300]!; // 비활성화 상태일 때 배경색
                        }
                        return Colors.green[400]!; // 활성화 상태일 때 기본 테마의 primary color
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
      ),
    );
  }
}


