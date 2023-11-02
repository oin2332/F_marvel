import 'package:flutter/material.dart';
import 'package:food_marvel/user/follower.dart';
import 'package:food_marvel/user/following.dart';
import 'package:food_marvel/user/newCollection.dart';
import 'package:food_marvel/user/notification.dart';
import 'package:food_marvel/user/profileEdit.dart';
import 'package:food_marvel/user/userSetting.dart';

import 'bdayRegister.dart';
import 'myCollection.dart';

class UserMain extends StatefulWidget {
  final String? collectionName;
  final String? description;
  final bool? isPublic;

  const UserMain({
    super.key,
    this.collectionName, // NewCollection 화면에서 전달된 데이터
    this.description, // NewCollection 화면에서 전달된 데이터
    this.isPublic,});

  @override
  State<UserMain> createState() => _UserMainState();
}

class _UserMainState extends State<UserMain>with SingleTickerProviderStateMixin{
  String? description;
   String? collectionName;
  bool? isPublic;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    description = widget.description;
    isPublic = widget.isPublic;
    collectionName = widget.collectionName;
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('마이페이지',style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications,color: Colors.grey),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationPage()));
            },
          ),IconButton(
            icon: Icon(Icons.settings,color: Colors.grey),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => UserSetting()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
          Row(
            children: [
              InkWell(
                onTap: () {},
                child: Image.asset('assets/user/userProfile.png', width: 100, height: 100),
              ),
              Column(
                children: [
                  Text('고독한 미식가_11909', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  Row(
                    children: [
                      TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (_) => Following()));
                            },
                          child: Text('팔로잉 |',style: TextStyle(color: Colors.grey),)),
                      Divider(color: Colors.black, thickness: 5, height: 50),
                      TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (_) => Follower()));
                          },
                          child: Text('팔로워',style: TextStyle(color: Colors.grey),)),
                    ],
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileEdit()));
                },
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
                    Size(double.infinity, 50), // 버튼의 너비와 높이를 조절
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(10.0)),
                  minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 0)),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  elevation: MaterialStateProperty.all<double>(0),
                  overlayColor: MaterialStateProperty.all<Color>(Colors.grey[200]!), // 터치 효과 색상
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey), // border 색상 black
                      borderRadius: BorderRadius.circular(30), // 버튼 테두리 모양 조정
                    ),
                  ),
                ),
                child: Text('프로필 수정', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(5),
            color: Colors.white,
            child: Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Image.asset('assets/main/cake3-removebg-preview (1).png', width: 100, height: 100),
                ),
                SizedBox(width: 15,),
                Column(
                  children: [
                    Text('푸드마블이 특별한 날을 축하해드릴게요', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                    Row(
                      children: [
                        TextButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (_) => BdayRegister()));
                            },
                            child: Text('생일/기념일 등록하기 >',style: TextStyle(color: Colors.grey),)),
                        Divider(color: Colors.black, thickness: 5, height: 50),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: '나의 저장'),
              Tab(text: '리뷰'),
            ],
          ),
          SizedBox(height: 20),
          Container(
            height: 300,
            padding: EdgeInsets.all(10),
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_) => MyCollection(
                          collectionName: collectionName,
                          description: description,
                          isPublic: isPublic,
                        )));
                      },
                      child:Text('컬렉션', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    ),
                    SizedBox(height: 20),
                    Text('컬렉션 이름: $collectionName'),
                    Text('설명: $description'),
                    Text('컬렉션 공개 여부: ${isPublic == null ? '알 수 없음' : isPublic! ? '공개' : '비공개'}'),

                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // 백그라운드 색상을 white로 설정
                        overlayColor: MaterialStateProperty.all<Color>(Colors.grey[200]!), // 터치 효과 색상
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey), // 보더 색상을 grey로 설정
                            borderRadius: BorderRadius.circular(10), // 버튼 테두리 모양 조정
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => NewCollection()));
                      },
                      child: Text('+ 새 컬렉션 만들기',style: TextStyle(color: Colors.black),),
                    ),
                    SizedBox(height: 30),
                    Text('저장한 레스토랑', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    SizedBox(height: 10),
                    Text('저장한 레스토랑이 없습니다.', style: TextStyle(color: Colors.grey[400]!),textAlign: TextAlign.center,),
                    Text('요즘 많이 저장하는 레스토랑을 확인해보세요.', style: TextStyle(color: Colors.grey[400]!),textAlign: TextAlign.center,),
                  ],
                ),
                Text('등록된 리뷰가 없습니다', style: TextStyle(color: Colors.grey[400]!),textAlign: TextAlign.center,)
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(),
    );
  }
}