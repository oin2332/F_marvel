import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// 공지사항 리스트 조회
Future<List<Map<String, dynamic>>> fetchNoticeDocuments() async {
  try {
    // 'T3_NOTICE_TBL' 컬렉션의 모든 문서 가져오기
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collection('T3_NOTICE_TBL').get();

    // 가져온 문서들을 List<Map> 형태로 변환
    List<Map<String, dynamic>> notices = querySnapshot.docs
        .map((document) => document.data() as Map<String, dynamic>)
        .toList();

    return notices;
  } catch (e) {
    print('데이터 가져오기 실패: $e');
    return [];
  }
}

class NoticeTab extends StatelessWidget {
  late Future<List<Map<String, dynamic>>> noticeData;


  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: noticeData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('데이터를 불러오는 도중 에러 발생: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('불러올 데이터가 없습니다.');
          } else {
            List<Map<String, dynamic>> notices = snapshot.data!;

            return ListView.builder(
              itemCount: notices.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> notice = notices[index];

                return InkWell(
                  onTap: () {
                    // 탭했을 때의 동작 정의
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(notice['title'] ?? '제목 없음'),
                            Text(notice['date'] ?? '날짜 없음'),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class AlertTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Image.asset('assets/user/notification.jpg') // 알림 내용이 아무 것도 없을 때
            //알림 내용 있을 때 동작 코드 작성 해야함.
          ],
        ),
      ),
    );
  }
}




