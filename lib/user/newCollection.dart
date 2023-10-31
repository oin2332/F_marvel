import 'package:flutter/material.dart';
import 'package:food_marvel/user/follower.dart';
import 'package:food_marvel/user/following.dart';
import 'package:food_marvel/user/profileEdit.dart';
import 'package:food_marvel/user/userMain.dart';
import 'package:food_marvel/user/userSetting.dart';

class NewCollection extends StatefulWidget {
  const NewCollection({super.key});

  @override
  State<NewCollection> createState() => _NewCollectionState();
}



class _NewCollectionState extends State<NewCollection> {
  TextEditingController collectionNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isCollectionPublic = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('새 컬렉션 만들기', style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text("컬렉션 이름 "),
                Text("* ",style: TextStyle(color: Color(0xFFFF6347))),
              ],
            ),
          ),
          SizedBox(height: 10,),
          TextField(
            controller: collectionNameController,
            maxLength: 30,
            style: TextStyle(color: Colors.grey),
            decoration: InputDecoration(
              hintText: "컬렉션 이름을 입력해 주세요",
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding: EdgeInsets.all(8.0),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("설명"),
          ),
          SizedBox(height: 10,),
          TextField(
            controller: descriptionController,
            maxLength: 2000,
            style: TextStyle(color: Colors.grey),
            decoration: InputDecoration(
              hintText: "설명을 입력해 주세요",
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding: EdgeInsets.all(8.0),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('컬렉션 공개하기', style: TextStyle(fontSize: 17)),
              Switch(
                value: isCollectionPublic,
                onChanged: (value) {
                  setState(() {
                    isCollectionPublic = value;
                  });
                },
                activeTrackColor: Color(0xFFFF6347), // 활성 상태에서의 트랙(바탕) 색상
                activeColor: Colors.white,
              ),
            ],
          ),
          Expanded(child: Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                final String collectionName = collectionNameController.text;
                final String description = descriptionController.text;
                final bool isPublic = isCollectionPublic;

                // UserMain 화면으로 데이터를 전달하는 방법
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserMain(
                      collectionName: collectionName,
                      description: description,
                      isPublic: isPublic,
                    ),
                  ),
                );
                // 버튼 클릭 시 수행할 동작 추가
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFF6347)), // 배경색 설정
                minimumSize: MaterialStateProperty.all<Size>(Size(375, 50)), // 버튼의 width와 height 설정
              ),
              child: Text(
                "등록",
                style: TextStyle(
                    color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15 // 글자색 설정
                ),
              ),
            ),
          )
          ),
          SizedBox(height: 20,)
        ],
      ),
    );
  }
}