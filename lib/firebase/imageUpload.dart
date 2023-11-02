import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload({super.key});

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {

  // 이미지 업로드
  // imageFile -> 업로드 할 이미지 파일 , imageName -> 이미지 파일 이름
  void uploadImage(File imageFile, String imageName) async {
    try {
      Reference storageRef = FirebaseStorage.instance.ref('images/$imageName.jpg');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      await uploadTask.whenComplete(() async {
        String imageUrl = await storageRef.getDownloadURL();
        print('Uploaded image URL: $imageUrl');
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  // initState() 내에서 코드 실행
  @override
  void initState() {
    super.initState();
    _uploadImage();
  }

  // 이미지 업로드 호출
  void _uploadImage() async {
    FirebaseStorage _storage = FirebaseStorage.instance;
    Reference _ref = _storage.ref("test/text");
    await _ref.putString("Hello World !!");

    String _image = "assets/user/basic.jpg";
    String _imageName = "basic";
    Directory systemTempDir = Directory.systemTemp;
    ByteData byteData = await rootBundle.load(_image);
    File file = File("${systemTempDir.path}/$_imageName.jpg");
    await file.writeAsBytes(
        byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    await FirebaseStorage.instance.ref("test/$_imageName").putFile(file);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: Text('')),
    body: ListView(
    ),
  );
  }
}
