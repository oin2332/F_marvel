import 'package:flutter/material.dart';



class Sample4 extends StatelessWidget {
  const Sample4({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        home : Scaffold(

          appBar: AppBar(
            title: Text('명함 샘플 UI'),
          ),

          body : Center(
            child: Container(
              width: 300, height: 200,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
              decoration: BoxDecoration(
                //color: Colors.purple,
                  border: Border.all(color: Colors.grey,width: 1,),
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person,size:30),
                  SizedBox(height: 8,),
                  Text("이상엽",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                  SizedBox(height: 8,),
                  Text("알바"),
                  SizedBox(height: 8,),
                  Text("olsang310@gamil.com"),
                  SizedBox(height: 8,),
                  Text("010-2242-7850"),
                ],
              )
            ),
          ),
        )
    );
  }
}