import 'package:flutter/material.dart';

class VersionInfo extends StatelessWidget {
  const VersionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('버전 정보')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('V. 0. 0. 1'),
      ),
    );
  }
}
