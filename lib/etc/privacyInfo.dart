import 'package:flutter/material.dart';

class PrivacyInfo extends StatelessWidget {
  const PrivacyInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('개인정보 처리방침'),
        leading: IconButton(
          icon: Icon(Icons.close), // "X" 아이콘
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Table(
              border: TableBorder.all(),
              columnWidths: {
                0: FlexColumnWidth(2), // 첫 번째 열의 너비
                1: FlexColumnWidth(3), // 두 번째 열의 너비
                2: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        '예약 연동이란?',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '`- 전화 또는 예약 링크로 한 예약을 앱에서 관리할 수 있게 하는 기능입니다. 예약에`',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            '` 사용한 휴대폰 번호로 방문예정일을 불러올 수 있어요!`',
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '`- 푸드마블 가맹점 예약만 연동 가능하며,`',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            '` 연동하기 활성화 이전에 방문했던 전화 예약 내역은 불러올 수 없습니다.`',
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '`- 전화 또는 예약 링크로 한 예약은 각 레스토랑의 운영 정책에 따라 앱에서 예약 취소 및`',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            '` 변경이 불가능할 수 있습니다.`',
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '`- 예약 링크는 푸드마블 가맹점을 예약할 수 있는 웹페이지 링크를 말합니다.`',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 40),
            Text("data"),
          ],
        ),
      ),
    );
  }
}
