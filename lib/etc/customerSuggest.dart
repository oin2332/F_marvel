import 'package:flutter/material.dart';

class CustomerSuggest extends StatefulWidget {
  const CustomerSuggest({super.key});

  @override
  State<CustomerSuggest> createState() => _CustomerSuggestState();
}

class _CustomerSuggestState extends State<CustomerSuggest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text('개선 제안하기', style: TextStyle(color: Colors.black)), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Text('저희 푸드마블이 보다 나은 서비스와 사용 경험을 제공할 수 있도록 사용 의견이나 제안을 보내주세요. '
            '보내주신 의겨은 제품 개선 활도에 큰 도움이 됩니다.',
              style: TextStyle(fontSize: 12, color: Colors.black54)),
            Text('* 예약 관련 또는 푸드마블의 답변이 필요한 문의사항은"1:1문의" 메뉴를 사용 부탁드립니다.',
                style: TextStyle(fontSize: 12, color: Colors.black54)),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: '피드백을 작성해주세요...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5, // 여러 줄 입력을 위한 설정
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text('문의 내용에 대한 상세한 확인이 필요하거나 긴급한 문의일 경우, 회원 가입시 입력하신 휴대전화 번호로 연락을'
                '드릴 수 있습니다. 개인정보 처리 방침에 대한 자세한 내용은 개인정보 취급방침을 참고하시기 바랍니다.',
                style: TextStyle(fontSize: 10, color: Colors.black54)),
            SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: true, // 사용자가 동의했는지 여부를 저장하는 변수와 연결해야 합니다.
                  onChanged: (bool? value) {
                    // 사용자가 체크박스를 선택했을 때의 로직을 추가하세요.
                  },
                ),
                Text('위 내용에 동의합니다.'),
              ],
            ),
            SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                // 여기에 제출 로직 추가
              },
              child: Text('등록'),
            ),
          ]
        ),
      ),
    );
  }
}