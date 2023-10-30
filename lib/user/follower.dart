import 'package:flutter/material.dart';

class Follower extends StatelessWidget {
  const Follower({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('팔로워')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            SizedBox(height: 180),
            Center(
              child: Column(
                children: [
                  Text('아직 팔로워가 없습니다.'),
                  Text('다른 사람이 팔로우 하면 여기에 표시됩니다.', style: TextStyle(fontSize: 10))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
