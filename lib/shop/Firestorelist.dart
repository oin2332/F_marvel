
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class teee extends StatefulWidget {
  const teee({super.key});

  @override
  State<teee> createState() => _teeeState();
}

class _teeeState extends State<teee> {

  @override
  void initState() {
    super.initState();
    fetchAllUserData1();
    fetchAllUserData2();
  }


  List<Map<String, dynamic>> userDataList = [];

  void fetchAllUserData1() async {
    try {
      QuerySnapshot storeSnapshot = await FirebaseFirestore.instance
          .collection('T3_STORE_TBL')
          .get();

      if (storeSnapshot.docs.isNotEmpty) {
        for (var storeDoc in storeSnapshot.docs) {
          Map<String, dynamic> storeData = storeDoc.data() as Map<String, dynamic>;
          String sId = storeData['S_ID'];

          // 해당 상점의 별점 정보 가져오기
          QuerySnapshot starSnapshot = await FirebaseFirestore.instance
              .collection('T3_STORE_TBL')
              .doc(sId)
              .collection('T3_STAR_TBL')
              .get();

          List<Map<String, dynamic>> starDataList = [];
          if (starSnapshot.docs.isNotEmpty) {
            for (var starDoc in starSnapshot.docs) {
              Map<String, dynamic> starData = starDoc.data() as Map<String, dynamic>;
              starDataList.add({'STAR': starData['STAR']});
            }
          }

          // userDataList에 상점 정보와 별점 정보를 조합하여 추가
          userDataList.add({'S_ID': sId, 'STAR_LIST': starDataList, ...storeData});
        }

        setState(() {
          // 데이터가 추가된 userDataList를 화면에 반영
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
    return Scaffold();
  }

}
