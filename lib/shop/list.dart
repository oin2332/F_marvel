import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'detailpage.dart';

class list extends StatefulWidget {
  const list({super.key});

  @override
  State<list> createState() => _listState();
}

class _listState extends State<list> {
  Widget _listUser() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("T3_STORE_TBL").orderBy("timestamp", descending: true).snapshots(),
      ///////////////////users/////////////////////
      //게시글 정렬 후 출력 (orderBy(descending: ,))
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap){
        if(!snap.hasData) {
          return Transform.scale(
            scale: 0.1,
            child: CircularProgressIndicator(strokeWidth: 20),
          );
        }
        return ListView(
          children: snap.data!.docs.map(
                (DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 20),
                        Container(
                          width: 80,
                          height: 110, // 원하는 높이 설정
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Image.asset(
                            'assets/storePageIMG/${data['S_IMG']}',
                            fit: BoxFit.cover,
                          ),
                        ),

                        SizedBox(width: 13),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 280, // 원하는 너비 설정
                              child: InkWell(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${data['S_NAME']}',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    Text('${data['S_SILPLEMONO']}'),
                                    Row(
                                      children: [
                                        Icon(Icons.star, size: 25, color: Colors.yellow[600]),
                                        Text(
                                          '88',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          '(123)',
                                          style: TextStyle(fontSize: 11, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${data['S_ADDR1']} ${data['S_ADDR2']} ${data['S_ADDR3']}',
                                      style: TextStyle(fontSize: 11, color: Colors.grey),
                                    ),
                                    Text(
                                      '${data['S_TIME']}',
                                      style: TextStyle(fontSize: 11, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => DetailPage()),
                                  );
                                },
                              ),
                            ),

                            SizedBox(height: 20),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {

                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFFFF6347),
                                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                  ),
                                  child: Text('13:00'),
                                ),
                                SizedBox(width: 6),
                                ElevatedButton(
                                  onPressed: () {

                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFFFF6347),
                                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                  ),
                                  child: Text('18:00'),
                                ),
                                SizedBox(width: 6),
                                ElevatedButton(
                                  onPressed: () {

                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFFFF6347),
                                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                  ),
                                  child: Text('21:00'),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          ).toList(),
        );

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _listUser()
        ],
      ),
    );
  }
}
