import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImportSuddenPopular extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('T3_STORE_TBL').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        var stores = snapshot.data!.docs.toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                "관심 급상승 음식점",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FutureBuilder(
              future: Future.wait(stores.map((store) async {
                var bookmarkSnapshot = await FirebaseFirestore.instance
                    .collection('T3_STORE_TBL')
                    .doc(store.id)
                    .collection('T3_BOOKMARK_TBL')
                    .where('Booktime', isEqualTo: 'Y')
                    .get();
                int bookmarkCount = bookmarkSnapshot.docs.length;


                return {'store': store, 'bookmarkCount': bookmarkCount};
              })),
              builder: (context, storeSnapshots) {
                if (storeSnapshots.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (storeSnapshots.hasError) {
                  return Text("Error: ${storeSnapshots.error}");
                }

                var sortedStores = (storeSnapshots.data as List)
                  ..sort((a, b) {
                    int aCount = a['bookmarkCount'] as int;
                    int bCount = b['bookmarkCount'] as int;
                    return bCount.compareTo(aCount);
                  });

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var i = 0; i < 5; i++)
                            Container(
                              margin: EdgeInsets.only(top:15.0,right: 15.0,bottom: 15.0,left: 10),
                              padding: EdgeInsets.only(top:10.0,right: 10.0,bottom: 10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),

                              ),
                              child: Text(
                                "${i + 1}. ${sortedStores[i]['store']['S_NAME']} (${sortedStores[i]['bookmarkCount']})",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  height: 1.5,
                                ),
                              ),
                            ),
                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var i = 5; i < 10; i++)
                            Container(
                              margin: EdgeInsets.all(15.0),
                              padding: EdgeInsets.only(top:10.0,right: 10.0,bottom: 10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                "${i + 1}. ${sortedStores[i]['store']['S_NAME']} (${sortedStores[i]['bookmarkCount']})",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  height: 1.5,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

