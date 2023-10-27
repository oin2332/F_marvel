import 'package:flutter/material.dart';
import 'package:food_marvel/user/bdayRegister.dart';
import 'package:food_marvel/user/flavorChoice.dart';

class ProfileEdit extends StatelessWidget {
  const ProfileEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('프로필 수정')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                  onTap: (){
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.photo),
                              title: Text('앨범에서 선택'),
                              onTap: () {
                                // 앨범에서 선택하는 로직을 추가하세요
                                // 예를 들어, 이미지 선택 코드를 넣어주세요.
                                Navigator.pop(context); // 모달 바텀 시트 닫기
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.image),
                              title: Text('기본 이미지로 변경'),
                              onTap: () {
                                // 기본 이미지로 변경하는 로직을 추가하세요
                                Navigator.pop(context); // 모달 바텀 시트 닫기
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                      width: 100, // 너비 조절
                      height: 100, // 높이 조절
                      child: Image.asset('assets/user/userProfile.png'))
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.topLeft,
                child: Text('닉네임', style: TextStyle(color: Colors.grey[600]!)),
              ),
              Container(
                width: 380, //TextField 너비 설정
                height: 50, //TextField 높이 설정
                child: TextField(decoration: InputDecoration(
                  labelText: '닉네임을 설정해주세요.',
                  alignLabelWithHint: true,
                  labelStyle: TextStyle(
                    color: Colors.grey[400]!, // 힌트 텍스트의 색상 설정
                    fontSize: 14, // 힌트 텍스트의 크기 설정
                    // 추가적인 스타일 설정 가능
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red, // 테두리 색상 설정
                      width: 2.0, // 테두리 두께 설정
                    ),
                  ),
                )),
              ),
              SizedBox(height: 15),
              Align(
                alignment: Alignment.topLeft,
                child: Text('자기소개', style: TextStyle(color: Colors.grey[600]!)),
              ),
              Container(
                width: 380, //TextField 너비 설정
                height: 100, //TextField 높이 설정
                child: TextField(decoration: InputDecoration(
                  labelText: '자신을 알릴 수 있는 소개글을 작성해주세요.',
                  alignLabelWithHint: true,
                  labelStyle: TextStyle(
                    color: Colors.grey[400]!,
                    fontSize: 14,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 50),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red, // 테두리 색상 설정
                      width: 2.0, // 테두리 두께 설정
                    ),
                  ),
                )),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.topLeft,
                child: Text('활동지역', style: TextStyle(color: Colors.grey[600]!)),
              ),
              Container(
                width: 380, //TextField 너비 설정
                height: 50, //TextField 높이 설정
                child: TextField(decoration: InputDecoration(
                  labelText: '활동지역을 자유롭게 입력해주세요.',
                  alignLabelWithHint: true,
                  labelStyle: TextStyle(
                    color: Colors.grey[400]!,
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red, // 테두리 색상 설정
                      width: 2.0, // 테두리 두께 설정
                    ),
                  ),
                )),
              ),
              SizedBox(height: 20),
              Container(height: 1, width: 400, color: Colors.grey[300]!),
              Container(
                height: 300,
                child: ListView(
                  children: [
                    TextButton(
                        onPressed: (){},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('SNS 설정하기', style: TextStyle(color: Colors.grey[500]!)),
                            Icon(Icons.keyboard_arrow_right_outlined, color: Colors.grey[500]!)
                          ],
                        )
                    ),
                    TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_) => FlavorChoice()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('내 취향 선택하기', style: TextStyle(color: Colors.grey[500]!)),
                            Icon(Icons.keyboard_arrow_right_outlined, color: Colors.grey[500]!)
                          ],
                        )
                    ),
                    TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_) => BdayRegister()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('생일기념일 등록하기', style: TextStyle(color: Colors.grey[500]!)),
                            Icon(Icons.keyboard_arrow_right_outlined, color: Colors.grey[500]!)
                          ],
                        )
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      );
  }
}
