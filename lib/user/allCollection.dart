import 'package:flutter/material.dart';

import 'myCollection.dart';
import 'newCollection.dart';

class AllCollection extends StatefulWidget {
  final String? collectionName;
  final String? description;
  final bool? isPublic;

  AllCollection({
    Key? key,
    this.collectionName,
    this.description,
    this.isPublic,
  }) : super(key: key);

  @override
  State<AllCollection> createState() => _AllCollectionState();
}

class _AllCollectionState extends State<AllCollection> {
  String? description;
  String? collectionName;
  bool? isPublic;
  String sortOrder = '최신순';
  _AllCollectionState({this.collectionName, this.description, this.isPublic});

  void toggleSortOrder() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('정렬 방식 선택'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('최신순'),
                onTap: () {
                  setState(() {
                    sortOrder = '최신순';
                    Navigator.pop(context);
                  });
                },
              ),
              ListTile(
                title: Text('오래된순',),
                onTap: () {
                  setState(() {
                    sortOrder = '오래된순';
                    Navigator.pop(context);
                  });
                },
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
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('컬렉션 전체보기',style: TextStyle(color: Colors.black),),
      ),
        body: Container(
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                SizedBox(height: 20,),
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      overlayColor: MaterialStateProperty.all<Color>(Colors.grey[200]!),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => NewCollection()));
                    },
                    child: Text('+ 새 컬렉션 만들기', style: TextStyle(color: Colors.black)),
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('내가만든 컬렉션', style: TextStyle(color: Colors.black, fontSize: 16)),
                    ),
                    GestureDetector(
                      onTap: () {
                        toggleSortOrder();
                      },
                    child: Row(
                      children:  <Widget> [
                        Text('$sortOrder'),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey, // 색상을 회색으로 설정하세요.
                        ),
                      ],
                    ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) => MyCollection(
                      collectionName: collectionName,
                      description: description,
                      isPublic: isPublic,
                    ),
                    ),
                    );
                  },
                  child: Row(
                    children: [
                      SizedBox(width: 10,),
                      Column(
                        children: [
                          if (description == null || collectionName == null)
                            Text(
                              '컬렉션이 존재하지 않습니다.',
                              style: TextStyle(color: Colors.grey),
                            )
                          else
                          Container(
                            height: 70,
                            width: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10.0),
                              ),
                              gradient: LinearGradient(
                                colors: [Colors.white10, Colors.grey],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Center(
                              child: Text(
                                'FOOD MARVEL',
                                style: TextStyle(color: Colors.black38, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                          ),
                          SizedBox(height: 1),
                          if (description != null && collectionName != null)
                          Container(
                            height: 30,
                            width: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(10.0),
                              ),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('  ${widget.description}', style: TextStyle(color: Colors.deepOrange)),
                                Icon(
                                  Icons.turned_in_not_outlined,
                                  color: Colors.deepOrange,
                                ),
                              ],
                            ),
                          ),
                          if (description != null && collectionName != null)
                          Row(
                            children: [
                              Icon(
                                isPublic == true ? Icons.lock_open : Icons.lock_outline,
                                color: Colors.black, // 색상을 조정하세요.
                              ),
                              Text(' ${widget.collectionName}',style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
