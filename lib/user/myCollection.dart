import 'package:food_marvel/user/myCollectionEdit.dart';
import 'package:food_marvel/user/newStore.dart';
import 'package:food_marvel/user/userMain.dart';
import 'package:flutter/material.dart';

import 'newCollection.dart';

class MyCollection extends StatefulWidget {
  final String? collectionName;
  final String? description;
  final bool? isPublic;

  MyCollection({
    Key? key,
    this.collectionName,
    this.description,
    this.isPublic,
  }) : super(key: key);

  @override
  State<MyCollection> createState() => _MyCollectionState();
}

class _MyCollectionState extends State<MyCollection> {

  void showCollectionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('컬렉션 수정'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => MyCollectionEdit(
                  collectionName: widget.collectionName,
                  description: widget.description,
                  isPublic: widget.isPublic,
                ))); //
                // 컬렉션 수정 동작을 수행하도록 추가하세요.
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('컬렉션 삭제'),
              onTap: () {
                Navigator.pop(context); // 팝업 메뉴 닫기
                // 컬렉션 삭제 동작을 수행하도록 추가하세요.
              },
            ),
            ListTile(
              leading: Icon(widget.isPublic == true ? Icons.lock_open : Icons.lock),
              title: Text(widget.isPublic == true ? '컬렉션 비공개하기' : '컬렉션 공개하기'),
              onTap: () {
                Navigator.pop(context); // 팝업 메뉴 닫기
                // 컬렉션 상태에 따라 동작을 수행하도록 추가하세요.
              },
            ),
          ],
        );
      },
    );
  }

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
              Text('${widget.collectionName ?? 'N/A'}컬렉션을 프로필에 '
                  '${widget.isPublic != null && widget.isPublic == true ? '비공개' : '공개'} 하시겠습니까?',
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
                      child: Text(widget.isPublic == true ? '비공개로 바꾸기' : '공개로 바꾸기'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black), // 아이콘 색상을 검정색으로 설정
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                _showConfirmationDialog();
              },
              icon: Icon(Icons.call_split, color: Colors.black),
            ),
            IconButton(
              onPressed: () {
                showCollectionMenu(context);
              },
              icon: Icon(Icons.more_horiz, color: Colors.black),
            ),
          ]
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
          Row(
            children: [
              SizedBox(width: 20,),
              Icon(
                widget.isPublic != null && widget.isPublic == true
                    ? Icons.lock_open  // 만약 widget.isPublic이 true(공개)이면 lock_open 아이콘 사용
                    : Icons.lock_outline,  // 그 외의 경우 lock_outline 아이콘 사용
                color: Colors.black,
              ),
              Text('${widget.collectionName ?? 'N/A'}',style: TextStyle(fontWeight:FontWeight.bold ,fontSize: 20),),
            ],
          ),
          SizedBox(height: 10,),
          Row(children: [
            SizedBox(width: 25,),
            Text('내가만든 컬렉션',),],),
          Row(children: [
            SizedBox(width: 25,),
            Text('설명: ${widget.description ?? 'N/A'}'),],),
          SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => NewStore()));
              // 이 버튼을 클릭했을 때 수행할 동작을 여기에 추가하세요.
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black), // 글자색을 검정색으로 설정
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // 배경색을 흰색으로 설정
              overlayColor: MaterialStateProperty.all<Color>(Colors.grey[200]!), // 터치 효과 색상을 회색으로 설정
              side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Colors.grey)), // 보더 색상을 회색으로 설정
              fixedSize: MaterialStateProperty.all<Size>(
                Size(350, 45), // 버튼의 너비와 높이를 설정
              ),
            ),
            child: Text('+ 스토어 추가하기'),
          ),
        ],
      ),
    );
  }
}
