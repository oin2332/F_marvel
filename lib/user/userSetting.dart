import 'package:flutter/material.dart';
import 'package:food_marvel/etc/customerSuggest.dart';
import 'package:food_marvel/etc/noticeList.dart';
import 'package:food_marvel/user/blockList.dart';
import 'package:food_marvel/user/connectNumber.dart';
import 'package:food_marvel/user/notificationSetting.dart';
import 'package:food_marvel/user/profileEdit.dart';
import 'package:food_marvel/user/userInfoEdit.dart';
import 'package:food_marvel/user/userModel.dart';
import 'package:provider/provider.dart';

class UserSetting extends StatelessWidget {
  const UserSetting({super.key});

  @override
  Widget build(BuildContext context) {
    String? userId = Provider.of<UserModel>(context).userId; // UserModel에서 사용자 아이디 받아오기
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {Navigator.pop(context);},
            ),
            title: Text('설정', style: TextStyle(color: Colors.black)), backgroundColor: Colors.white,elevation: 0),
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
                children: [
                  Text('내 정보', style: TextStyle(color: Colors.grey[600]!),),
                  TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileEdit(userId: userId)));},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Text('프로필 수정', style: TextStyle(color: Colors.black)),
                        Icon(Icons.keyboard_arrow_right, color: Colors.black)
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => UserInfoEdit()));},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('내 정보 수정', style: TextStyle(color: Colors.black)),
                          Icon(Icons.keyboard_arrow_right, color: Colors.black)
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ConnectNumber()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('연락처 연결하기', style: TextStyle(color: Colors.black)),
                          Icon(Icons.keyboard_arrow_right, color: Colors.black)
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: (){},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('예약 연동하기', style: TextStyle(color: Colors.black)),
                          Icon(Icons.keyboard_arrow_right, color: Colors.black)
                        ],
                      ),
                    ),
                  ),
                  Container(height: 1, width: 250, color: Colors.grey),
                  Text('서비스 이용', style: TextStyle(color: Colors.grey[600]!),),
                  TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => BlockList()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('차단한 사용자 관리', style: TextStyle(color: Colors.black)),
                          Icon(Icons.keyboard_arrow_right, color: Colors.black)
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationSetting()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('알림 설정', style: TextStyle(color: Colors.black)),
                          Icon(Icons.keyboard_arrow_right, color: Colors.black)
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: (){},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('1:1 문의', style: TextStyle(color: Colors.black)),
                          Icon(Icons.keyboard_arrow_right, color: Colors.black)
                        ],
                      ),
                    ),
                  ),
                  Container(height: 1, width: 250, color: Colors.grey),
                  Text('기타', style: TextStyle(color: Colors.grey[600]!),),
                  TextButton(
                    onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (_) => NoticeList()));},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('공지사항 및 이용약관', style: TextStyle(color: Colors.black)),
                          Icon(Icons.keyboard_arrow_right, color: Colors.black)
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerSuggest()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('개선 제안하기', style: TextStyle(color: Colors.black)),
                          Icon(Icons.keyboard_arrow_right, color: Colors.black)
                        ],
                      ),
                    ),
                  ),
                ],
            ),
          ),
        ),
      );
  }
}
