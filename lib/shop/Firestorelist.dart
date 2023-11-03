
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../firebase/firebase_options.dart';
import '../user/userModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: teee(),
    );
  }
}

class teee extends StatefulWidget {
  const teee({super.key});

  @override
  State<teee> createState() => _teeeState();
}

class _teeeState extends State<teee> {

  @override
  void initState() {
    super.initState();
    fetchAllUserData();
  }


  List<Map<String, dynamic>> userDataList = [];

  void fetchAllUserData() async {
    try {
      QuerySnapshot storeSnapshot = await FirebaseFirestore.instance
          .collection('T3_STORE_TBL')
          .get();


      if (storeSnapshot.docs.isNotEmpty) {
        for (var storeDoc in storeSnapshot.docs) {
          Map<String, dynamic> storeData = storeDoc.data() as Map<String, dynamic>;
          String docId = storeDoc.id;

          // 해당 상점의 별점 정보 가져오기
          QuerySnapshot starSnapshot = await FirebaseFirestore.instance
              .collection('T3_STORE_TBL')
              .doc(docId)
              .collection('T3_STAR_TBL')
              .get();

          List<Map<String, dynamic>> starDataList = [];
          if (starSnapshot.docs.isNotEmpty) {
            for (var starDoc in starSnapshot.docs) {
              Map<String, dynamic> starData = starDoc.data() as Map<String, dynamic>;
              starDataList.add(starData);

            }
          } else {
            // 별점 정보가 없는 경우, 빈 리스트로 처리하거나 필요에 따라 다른 처리를 수행
            starDataList = [];

          }

          // storeData에 'STAR' 키를 사용하여 starDataList 추가
          storeData['STAR'] = starDataList;

          userDataList.add(storeData);


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
