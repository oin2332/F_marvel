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