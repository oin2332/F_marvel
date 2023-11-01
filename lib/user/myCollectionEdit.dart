import 'package:flutter/material.dart';

class MyCollectionEdit extends StatefulWidget {
  final String? collectionName;
  final String? description;
  final bool? isPublic;

  MyCollectionEdit({
    Key? key,
    this.collectionName,
    this.description,
    this.isPublic,
  }) : super(key: key);

  @override
  State<MyCollectionEdit> createState() => _MyCollectionEditState();
}

class _MyCollectionEditState extends State<MyCollectionEdit> {
  TextEditingController collectionNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isCollectionPublic = false;

  void _showConfirmationDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16),
              Text('변경사항을 저장하지 않고 나가시겠어요?',
                style: TextStyle(color: Colors.grey),),
              SizedBox(height: 50),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(
                        Size(180, 45), // 버튼의 너비와 높이를 동일한 값으로 설정
                      ),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                        return Colors.white; // 배경색을 흰색으로 설정
                      }),
                      side: MaterialStateProperty.all(
                        BorderSide(color: Colors.grey, width: 1), // 회색 보더 설정
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // 모달 닫기
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('취소',style: TextStyle(
                        color: Colors.black, // 검정 글자색
                      ),),

                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(
                        Size(180, 45), // 버튼의 너비와 높이를 동일한 값으로 설정
                      ),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                        return Color(0xFFFF6347); // 배경색을 ff6347로 설정
                      }),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // 모달 닫기
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('나가기'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // 초기값 설정
    collectionNameController.text = widget.collectionName ?? "";
    descriptionController.text = widget.description ?? "";
    isCollectionPublic = widget.isPublic ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _showConfirmationDialog,
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('컬렉션 수정', style: TextStyle(color: Colors.black)),
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
                activeTrackColor: Color(0xFFFF6347),
                activeColor: Colors.white,
              ),
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  final String updatedCollectionName = collectionNameController.text;
                  final String updatedDescription = descriptionController.text;
                  final bool updatedIsPublic = isCollectionPublic;

                  // 수정된 데이터를 전달
                  Navigator.pop(context, {
                    'collectionName': updatedCollectionName,
                    'description': updatedDescription,
                    'isPublic': updatedIsPublic,
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFF6347)),
                  minimumSize: MaterialStateProperty.all<Size>(Size(375, 50)),
                ),
                child: Text(
                  "저장",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,)
        ],
      ),
    );
  }
}