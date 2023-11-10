import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Temp extends StatefulWidget {
  const Temp({super.key});

  @override
  State<Temp> createState() => _TempState();
}

class _TempState extends State<Temp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('임시리스트')),
      body: ListView(
        shrinkWrap: true,
        children: [
          _listReview()
        ],
      ),
    );
  }
}


Widget _listReview() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('T3_REVIEW_TBL').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return CircularProgressIndicator(); // 데이터를 불러올 때까지 로딩 중을 표시합니다.
      }
      var reviews = snapshot.data!.docs; // 데이터가 있는 경우 문서 리스트를 가져옵니다.
      List<Widget> reviewWidgets = [];
      for (var review in reviews) {
        var title = review['title'];
        var content = review['content'];
        var imageUrls = review['r_img_urls']; // 이미지 URL 리스트
        var rating = review['rating'];

        var imageSlider = Container(
          height: 400, // 슬라이드 높이 설정
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: List.generate(imageUrls.length, (index) {
              return Container(
                width: 400, // 이미지의 폭을 동일하게 설정
                child: Image.network(
                  imageUrls[index],
                  fit: BoxFit.cover, // 이미지를 화면에 맞게 조절
                ),
              );
            }),
          ),
        );

        var reviewWidget = ListTile(
          title: Text(title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(content),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  Text(rating.toString()),
                ],
              ),
              imageSlider, // 슬라이더 추가
            ],
          ),
        );

        reviewWidgets.add(reviewWidget);
      }

      return ListView(
        shrinkWrap: true,
        children: reviewWidgets,
      );
    },
  );
}
