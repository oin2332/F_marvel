import 'package:flutter/material.dart';

class Following extends StatelessWidget {
  const Following({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
        title: Text('팔로잉', style: TextStyle(color: Colors.black)), backgroundColor: Colors.white,elevation: 0, // 그림자를 제거
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              InkWell(
                child: Container(
                  height: 100,

                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.person_add_alt_1_sharp, size: 50),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('연락처를 연결해서 친구를 팔로우 하고, \n함께 갈 레스토랑을 찾아보세요'),
                          SizedBox(height: 5),
                          Text('연락처 연결하기 >', style: TextStyle(color: Colors.deepOrange))
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 140),
              Center(
                child: Column(
                  children: [
                    Text('아직 아무도 팔로우 하지 않았습니다.'),
                    Text('다른 사람을 팔로우 하면 여기에 표시됩니다.', style: TextStyle(fontSize: 10))
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
