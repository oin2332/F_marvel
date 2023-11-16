import 'package:flutter/material.dart';
import 'package:food_marvel/map/localmap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../shop/Addshop/storeboardAdd.dart';
import '../map/maptotal.dart';
import '../shop/Addshop/storemenuimgAdd2.dart';


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
      GooGleMap(),
      SMap(initialLocation: LatLng(37.4563, 126.7052)),
      SMap(initialLocation: LatLng(37.5665, 126.9780)),
      SMap(initialLocation: LatLng(37.4138, 127.5185)),
      SMap(initialLocation: LatLng(33.4996, 126.5312)),
      //Sample13(),
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
                buildIconWithText('assets/main/incheon.jpg', '인천', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SMap(initialLocation: LatLng(37.4563, 126.7052))));
                }),
                buildIconWithText('assets/main/seoul2.jpg', '서울', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SMap(initialLocation: LatLng(37.5665, 126.9780))));
                }),
                buildIconWithText('assets/main/rudrleh.jpg', '경기', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SMap(initialLocation: LatLng(37.4138, 127.5185))));
                }),
                buildIconWithText('assets/main/wpwneh.jpg', '제주', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SMap(initialLocation: LatLng(33.4996, 126.5312))));
                }),
                // buildIconWithText('assets/main/seoul3.jpg', '서울/남동구', () {
                //   navigatePlacePage(4);
                // }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
