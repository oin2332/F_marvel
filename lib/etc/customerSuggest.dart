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
      appBar: AppBar(title: Text('개선 제안하기')),
      body: Container(
        child: Column(
          children: [
            Text('고객의 소리함'),
            Text('불편한점 또는 업데이트 되면 좋겠다 싶은 것들을 편하게 적어주세요'),
            TextField(
              decoration: InputDecoration(
                hintText: '피드백을 작성해주세요...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5, // 여러 줄 입력을 위한 설정
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 여기에 제출 로직 추가
              },
              child: Text('제출'),
            ),
          ],
        ),
      ),
    );
  }
}