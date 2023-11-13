import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


// 기념일 설정
Future<void> setDay(String userId, String dayType, DateTime date, String memo) async {
  try {
    CollectionReference userCollection = FirebaseFirestore.instance.collection('T3_USER_TBL');
    var userDocSnapshot = await userCollection.where('id', isEqualTo: userId)
        .limit(1)
        .get();

    if (userDocSnapshot.docs.isNotEmpty) {
      await userDocSnapshot.docs.first.reference.collection('USER_CELEBRATEDAY_TBL').add({
        'type': dayType,
        'date': date,
        'memo': memo,
      });
      print('기념일이 성공적으로 설정되었습니다.');
    }

  } catch (e) {
    print('기념일 설정 에러: $e');
  }
}

// 기념일 리스트 불러오기
Future<List<String>> getUserDay(String userId) async {
  List<String> days = [];

  try {
    CollectionReference userCollection = FirebaseFirestore.instance.collection('T3_USER_TBL');
    var userDocSnapshot = await userCollection.where('id',isEqualTo: userId).limit(1).get();

    if (userDocSnapshot.docs.isNotEmpty) {
      var dayDocSnapshot = await userDocSnapshot.docs.first.reference.collection('USER_CELEBRATEDAY_TBL').get();
      print('if 동작확인');

      dayDocSnapshot.docs.forEach((doc) {
        days.add(doc.id);
      });
    }

    return days;
  } catch (e) {
    print('기념일 리스트 조회 실패: $e');
    return [];
  }
}


// 기념일 리스트 조회
Widget buildBdayList(String userId) {
  // Firestore에서 기념일 데이터 가져오기
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('T3_USER_TBL')
        .where('id', isEqualTo: userId)  // 사용자의 ID와 일치하는 문서 가져오기
        .limit(1)
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      var userDocs = snapshot.data!.docs;

      // 사용자 문서가 존재하면 해당 사용자의 ID로 USER_CELEBRATEDAY_TBL의 데이터 가져오기
      if (userDocs.isNotEmpty) {
        var userDoc = userDocs.first;
        var userId = userDoc['id'];

        return StreamBuilder<QuerySnapshot>(
          stream: userDoc.reference
              .collection('USER_CELEBRATEDAY_TBL')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            var bdays = snapshot.data!.docs;

            // 기념일 리스트를 출력하는 ListView.builder
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: bdays.length,
              itemBuilder: (context, index) {
                var bday = bdays[index];
                var type = bday['type'];
                var timestamp = bday['date']; // Timestamp로 가져옴
                var memo = bday['memo'];

                // Timestamp를 DateTime으로 변환
                DateTime date = timestamp.toDate();

                // 이제 날짜를 원하는 형식으로 표시할 수 있음
                var formattedDate = DateFormat("yyyy년 MM월 dd일").format(date);


                return ListTile(
                  leading: type == '결혼 기념일'
                      ? Image.asset(
                    'assets/main/heart-removebg-preview.png',
                    width: 35,
                    height: 35,
                  )
                      : Image.asset(
                    'assets/main/celebration-removebg-preview.png',
                    width: 35,
                    height: 35,
                  ),
                  title: Text(
                    '$type - $formattedDate',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(memo, style: TextStyle(
                    color: Colors.grey,
                  )),
                );
              },
            );
          },
        );
      } else {
        // 사용자 문서가 없을 경우 빈 화면 또는 다른 처리를 수행할 수 있습니다.
        return Center(
          child: Text('사용자를 찾을 수 없습니다.'),
        );
      }
    },
  );
}

