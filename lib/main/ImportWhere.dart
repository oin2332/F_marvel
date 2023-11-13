import 'package:flutter/material.dart';

import '../shop/Addshop/storeboardAdd.dart';
import '../map/maptotal.dart';
import '../shop/Addshop/storemenuimgAdd2.dart';
import '13_tapBar.dart';

class ImportWhere extends StatefulWidget {

  @override
  State<ImportWhere> createState() => _ImportWhereState();
}

class _ImportWhereState extends State<ImportWhere> {
  Widget buildIconWithText(String imagePath, String text, VoidCallback onTap) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(5),
          child: Material(
            color: Colors.grey,
            child: InkWell(
              onTap: onTap,
              child: Image.asset(imagePath, fit: BoxFit.cover, width: 110, height: 80),
            ),
          ),
        ),
        Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
  void navigatePlacePage(int index) {
    final pages = [
      Sample13(),
      Sample13(),
      Sample13(),
      Sample13(),
      Sample13(),
      Sample13(),
    ];

    if (index >= 0 && index < pages.length) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => pages[index]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 15,),
            Text("어디로 가시나요?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
          ],
        ),
        SizedBox(height: 10,),
        Container(
          height: 150,
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                buildIconWithText('assets/main/gpsgps.png', '내주변', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GooGleMap()));
                }),
                buildIconWithText('assets/main/incheon.jpg', '인천/부평', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StoremenuimgAdd2(storeDocumentId: 'ㄹㅇ',)));
                }),
                buildIconWithText('assets/main/incheon2.jpg', '인천/연수', () {

                }),
                buildIconWithText('assets/main/seoul.jpg', '서울/동암', () {
                  navigatePlacePage(2);
                }),
                buildIconWithText('assets/main/seoul2.jpg', '서울/중구', () {
                  navigatePlacePage(3);
                }),
                buildIconWithText('assets/main/seoul3.jpg', '서울/남동구', () {
                  navigatePlacePage(4);
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
