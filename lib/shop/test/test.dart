import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {


  Widget _buildVideoListItem(Map<String, dynamic> videoDetailData, String id, Map<String, dynamic>? data) {
    String title = videoDetailData['title'];
    String url = videoDetailData['url'];
    int cnt = videoDetailData['cnt'];
    var time = videoDetailData['cDateTime'];


    if (title.length > 30) {
      title = title.substring(0, 30) + "...";
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => VideoDetailed(videoDetailData, id),)).then((value) => setState(() {}));
      },
      child: Container(
        height: 370,
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'https://img.youtube.com/vi/$url/0.jpg', height: 270,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('조회수 $cnt', style: TextStyle(fontSize: 12)),
                      Text(DateFormat('yyyy-MM-dd').format(time.toDate()),
                          style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Widget>> _videoListSearch() async {
    var videoDetailsQuerySnapshot = await fs.collection('video').orderBy(
        'cDateTime', descending: true).get();

    if (videoDetailsQuerySnapshot.docs.isNotEmpty) {
      var list = <Widget>[];
      videoDetailsQuerySnapshot.docs.forEach((videoDetailDocument) async{
        var videoDetailData = videoDetailDocument.data();
        if (_searchControl != null && _searchControl.text.isNotEmpty) {
          // 검색어가 비어 있지 않고 title에 검색어가 포함되어 있으면 리스트에 아이템 추가
          if (videoDetailData['title'].contains(_searchControl.text)) {
            var artisDoc = await fs.collection('artis').doc(videoDetailData['artisId']).get();
            list.add(_buildVideoListItem(videoDetailData, videoDetailDocument.id, artisDoc.data()));
          }
        } else {
          // 검색어가 비어있거나 null인 경우 모든 아이템 추가
          var artisDoc = await fs.collection('artis').doc(videoDetailData['artisId']).get();
          list.add(_buildVideoListItem(videoDetailData, videoDetailDocument.id, artisDoc.data()));
        }
      });
      return list;
    } else {
      var list = <Widget>[];
      return list;
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            testfb()
          ],
        ),
      ),
    );
  }
}
