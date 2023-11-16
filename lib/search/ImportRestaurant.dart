import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'ImportSearchlist.dart';


class ImportRestaurant extends StatefulWidget {

  final VoidCallback onTapCallback;

  ImportRestaurant({required this.onTapCallback});

  @override
  State<ImportRestaurant> createState() => _ImportRestaurantState();
}
class RestaurantItem {
  final String image;
  final String title;
  final String content;

  RestaurantItem({
    required this.image,
    required this.title,
    this.content = "",
  });
}

class _ImportRestaurantState extends State<ImportRestaurant> {
  bool isImportSuddenPopularVisible = true;
  bool isImportRestaurantVisible = false;
  List<Map<String, dynamic>> parkingDataList = [];


  final List<RestaurantItem> restaurantItems = [
    RestaurantItem(
      image: 'assets/searchIMG/searchimg0.jpg',
      title: "#주차가능매장",
      content: "내용0",
    ),
    RestaurantItem(
      image: 'assets/searchIMG/searchimg1.jpg',
      title: "#데이트하기\n좋은",
      content: "내용1",
    ),
    RestaurantItem(
      image: 'assets/searchIMG/searchimg2.jpg',
      title: "#엘리베이터\n있는",
      content: "내용2",
    ),
    RestaurantItem(
      image: 'assets/searchIMG/searchimg3.jpg',
      title: "#재방문많은",
      content: "내용3",
    ),
    RestaurantItem(
      image: 'assets/searchIMG/searchimg4.jpg',
      title: "#숨은맛집",
      content: "내용4",
    ),
    RestaurantItem(
      image: 'assets/searchIMG/searchimg5.jpg',
      title: "#1층매장",
      content: "내용5",
    ),
    RestaurantItem(
      image: 'assets/searchIMG/searchimg6.jpg',
      title: "#키즈존",
      content: "내용6",
    ),
    RestaurantItem(
      image: 'assets/searchIMG/searchimg7.jpg',
      title: "#이국적인",
      content: "내용7",
    ),
    RestaurantItem(
      image: 'assets/searchIMG/searchimg8.jpg',
      title: "#소박한",
      content: "내용8",
    ),
    RestaurantItem(
      image: 'assets/searchIMG/searchimg9.jpg',
      title: "#아늑한",
      content: "내용9",
    ),
    RestaurantItem(
      image: 'assets/searchIMG/searchimg10.jpg',
      title: "#착한가격",
      content: "내용10",
    ),
    RestaurantItem(
      image: 'assets/searchIMG/searchimg11.jpg',
      title: "#특별한날",
      content: "내용11",
    ),
    RestaurantItem(
      image: 'assets/searchIMG/searchimg12.jpg',
      title: "#신선한",
      content: "내용12",
    ),
    RestaurantItem(
      image: 'assets/searchIMG/searchimg13.jpg',
      title: "#비오는날",
      content: "내용13",
    ),
  ];


  @override
  Widget build(BuildContext context) {
    restaurantItems.shuffle(Random());

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "어떤 맛집 찾으세요??",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 15.0,
            ),
            itemCount: 4,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final restaurantItem = restaurantItems[index];
              return _buildItemWithImage(
                image: restaurantItem.image,
                title: restaurantItem.title,
                content: restaurantItem.content,
                onTapCallback: () => _handleItemTap(restaurantItem.title),
              );
            },
          ),
          if (isImportRestaurantVisible)
            Container(
              height: 500,
              child: SearchListShop(searchResults: parkingDataList),
            ),
        ],
      ),
    );
  }

  Widget _buildItemWithImage({
    required String image,
    required String title,
    String content = "",
    required VoidCallback onTapCallback,
  }) {
    return GestureDetector(
      onTap: onTapCallback,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(15.0),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 10,
            right: 10,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            top: 130,
            left: 10,
            right: 10,
            child: Text(
              content,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.lightBlueAccent,
              ),
              textAlign: TextAlign.center,
            ),
          ),

        ],
      ),
    );
  }


  Future<void> _handleItemTap(String title) async {
    print('handleItemTap 호출: $title');
    try {
      QuerySnapshot storeSnapshot = await FirebaseFirestore.instance
          .collection('T3_STORE_TBL')
          .get();
      print('Number of documents in storeSnapshot: ${storeSnapshot.size}');
      List<Map<String, dynamic>> updatedParkingDataList = [];

      for (var storeDoc in storeSnapshot.docs) {
        String storeDocId = storeDoc.id;

        if (title == "#주차가능매장") {
          QuerySnapshot convenienceSnapshot = await FirebaseFirestore.instance
              .collection('T3_STORE_TBL')
              .doc(storeDocId)
              .collection('T3_CONVENIENCE_TBL')
              .where('S_PARKING', isEqualTo: true)
              .get();



          convenienceSnapshot.docs.forEach((convenienceDoc) {
            Map<String, dynamic> convenienceData = convenienceDoc.data() as Map<String, dynamic>;
            print('서브컬렉션 데이터: $convenienceData');
            updatedParkingDataList.add(convenienceData);
          });
        }
      }


      if (updatedParkingDataList.isNotEmpty) {
        setState(() {
          parkingDataList = updatedParkingDataList;
          isImportRestaurantVisible = true;
        });

        print('주차가능매장이 선택됨!');
        widget.onTapCallback();
      }
    } catch (e) {
      print('데이터 가져오기 오류: $e');
    }
  }
}