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
    );
  }
}
