import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../shop/detailpage.dart';
import '../shop/loading.dart';



class SearchListShop extends StatefulWidget {
  final List<Map<String, dynamic>> searchResults;

  SearchListShop({required this.searchResults}) : super();

  @override
  State<SearchListShop> createState() => _SearchListShop();
}

class _SearchListShop extends State<SearchListShop> {
  List<Map<String, dynamic>> userDataList = [];
  @override

  void initState() {
    super.initState();
    fetchAllUserData();
  }

  void fetchAllUserData() async {
    try {
      QuerySnapshot storeSnapshot = await FirebaseFirestore.instance
          .collection('T3_STORE_TBL')
          .get();


      if (storeSnapshot.docs.isNotEmpty) {
        for (var storeDoc in storeSnapshot.docs) {
          Map<String, dynamic> storeData = storeDoc.data() as Map<String, dynamic>;
          String docId = storeDoc.id;

          QuerySnapshot starSnapshot = await FirebaseFirestore.instance
              .collection('T3_STORE_TBL')
              .doc(docId)
              .collection('T3_STAR_TBL')
              .get();

          List<String> starList = [];
          double x = 0;
          int y = 0;

          if (starSnapshot.docs.isNotEmpty) {
            for (var starDoc in starSnapshot.docs) {
              Map<String, dynamic> starData = starDoc.data() as Map<String, dynamic>;

              starData.forEach((key, value) {
                if (value is String) {
                  double numericValue = double.parse(value);
                  if (numericValue != null) {
                    starList.add(value);
                    x += numericValue;
                    y++;
                  }
                }
              });
            }
          } else {
            starList.add('0');
          }

          if (y > 0) {
            x = x / y;
          }
          storeData['STARlength'] = y;
          storeData['STARage'] = x.toStringAsFixed(1);
          storeData['STARlist'] = starList;
          userDataList.add(storeData);
        }
        setState(() {

        });
      } else {
        print('상점 데이터를 찾을 수 없습니다.');

      }
    } catch (e) {
      print('데이터를 불러오는 중 오류가 발생했습니다: $e');

    }
  }


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.searchResults.length,
      itemBuilder: (context, index) {
        final documentData = widget.searchResults[index];

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
                  child: CachedNetworkImage(
                    placeholder: (context, url) => LoadingSpinner3(),
                    imageUrl: documentData['S_IMG'],
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 13),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 200,
                      child: InkWell(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${documentData['S_NAME']}',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text('${documentData['S_SILPLEMONO']}'),
                            Row(
                              children: [
                                Icon(Icons.star, size: 25, color: Colors.yellow[600]),
                                Text(
                                  '${documentData['STARage'] ?? 0}', // 평균 별점 표시
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '(${documentData['STARlength']})', // 별점 개수 표시
                                  style: TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ),
                            Text(
                              '${documentData['S_ADDR1']} ${documentData['S_ADDR2']} ${documentData['S_ADDR3']}',
                              style: TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                            Text(
                              '${documentData['S_TIME']}',
                              style: TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(docId: documentData['yourDocId']),
                            ),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
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
                                horizontal: 15, vertical: 10),
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
                                horizontal: 15, vertical: 10),
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
        );

      },
    );
  }

}