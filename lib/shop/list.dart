import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../user/userModel.dart';
import 'detailpage.dart';



class ListsShop extends StatefulWidget {
  ListsShop({super.key});


  @override
  State<ListsShop> createState() => _TestState();
}

class _TestState extends State<ListsShop> {


  List<Map<String, dynamic>> userDataList = [];

  void fetchAllUserData() async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('T3_STORE_TBL')
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        for (var doc in userSnapshot.docs) {
          Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
          userDataList.add(userData); // 데이터를 userDataList에 추가
        }

        setState(() {
          // 데이터가 추가된 userDataList를 화면에 반영
        });
      } else {
        print('사용자 데이터를 찾을 수 없습니다.');
      }
    } catch (e) {
      print('데이터를 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAllUserData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: userDataList.length,
      itemBuilder: (context, index) {
        final documentData = userDataList[index];
        // documentData['S_INFO1'] == '양식'
        if (true) {
          return ListTile(
            title: Container(
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
                      'assets/storePageIMG/${documentData['S_IMG']}',
                      fit: BoxFit.cover,
                    ),
                  ),

                  SizedBox(width: 13),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${documentData['S_NAME']}',
                              style: TextStyle(fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text('${documentData['S_SILPLEMONO']}'),
                            Row(
                              children: [
                                Icon(Icons.star, size: 25,
                                    color: Colors.yellow[600]),
                                Text(
                                  '4.7',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '(123)',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ),
                            Text(
                              '${documentData['S_ADDR1']} ${documentData['S_ADDR2']} ${documentData['S_ADDR3']}',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey),
                            ),
                            Text(
                              '${documentData['S_TIME']}',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage()));
                        },
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {

                            },
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xFFFF6347),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                            ),
                            child: Text('13:00'),
                          ),
                          SizedBox(width: 6),
                          ElevatedButton(
                            onPressed: () {

                            },
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xFFFF6347),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                            ),
                            child: Text('18:00'),
                          ),
                          SizedBox(width: 6),
                          ElevatedButton(
                            onPressed: () {

                            },
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xFFFF6347),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                            ),
                            child: Text('21:00'),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ), // 변환된 DateTime 값을 출력
          );
        }
      },
    );
  }
}