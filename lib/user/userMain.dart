import 'package:flutter/material.dart';

class UserMain extends StatefulWidget {
  const UserMain({super.key});

  @override
  State<UserMain> createState() => _UserMainState();
}

class _UserMainState extends State<UserMain> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {},
                child: Image.asset('assets/userProfile.png', width: 100, height: 100),
              ),
              Column(
                children: [
                  Text('고독한 미식가_11909', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  Row(
                    children: [
                      TextButton(onPressed: (){setState(() {});}, child: Text('팔로잉')),
                      Divider(color: Colors.black, thickness: 5, height: 50),
                      TextButton(onPressed: (){setState(() {});}, child: Text('팔로워')),
                    ],
                  )
                ],
              )
            ],
          ),
          ElevatedButton(
              onPressed: (){},
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(16.0)),
                minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 0)),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                elevation: MaterialStateProperty.all<double>(0),
                overlayColor: MaterialStateProperty.all<Color>(Colors.grey[200]!), // 터치 효과 색상
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black), // border 색상 black
                    borderRadius: BorderRadius.circular(10), // 버튼 테두리 모양 조정
                  ),
                ),
              ),
              child: Text('프로필 수정', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
          ),
          SizedBox(height: 20),
          TabBar(
            tabs: [
              Tab(text: '나의 저장'),
              Tab(text: '리뷰'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                Center(child: Text('나의 저장 내용')),
                Center(child: Text('리뷰 내용')),
              ],
            ),
          ),
        ],
    ),
    );
  }
}