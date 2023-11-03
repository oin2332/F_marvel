import 'package:flutter/material.dart';

class EasyLogin extends StatelessWidget {
  const EasyLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {Navigator.pop(context);},
          ),
          title: Text('간편로그인 설정', style: TextStyle(color: Colors.black)), backgroundColor: Colors.white,elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          margin: EdgeInsets.only(top: 30),
          child: Column(
            children: [
              Align(alignment: Alignment.centerLeft, child: Text('간편 로그인이 설정 되었습니다.')),
              SizedBox(height: 40),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        IconButton(
                            onPressed: (){},
                            icon: Icon(Icons.login)),
                        Text('카카오톡')
                      ],
                    ),
                    Divider(color: Colors.black, thickness: 5, height: 50), //세로 선
                    Column(
                      children: [
                        IconButton(
                            onPressed: (){},
                            icon: Icon(Icons.login)),
                        Text('네이버')
                      ],
                    ),
                    Divider(color: Colors.black, thickness: 5, height: 50), //세로 선
                    Column(
                      children: [
                        IconButton(
                            onPressed: (){},
                            icon: Icon(Icons.login)),
                        Text('애플')
                      ],
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
