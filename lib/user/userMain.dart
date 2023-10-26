import 'package:flutter/material.dart';

class UserMain extends StatefulWidget {
  const UserMain({super.key});

  @override
  State<UserMain> createState() => _UserMainState();
}

class _UserMainState extends State<UserMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: ListView(
        children: [
          Row(
            children: [
              Image.asset('assets/userProfile.png'),
              Column(
                children: [
                  Text('고독한 미식가_11909', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  Row(
                    children: [
                      TextButton(onPressed: (){}, child: Text('팔로잉')),
                      Divider(color: Colors.black, thickness: 5, height: 50),
                      TextButton(onPressed: (){}, child: Text('팔로워')),
                    ],
                  )
                ],
              )
            ],
          ),
          ElevatedButton(
              onPressed: (){},
              style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(16.0)), minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 0)),),
              child: Text('프로필 수정'),
          ),
        ],
      ),
    );
  }
}
