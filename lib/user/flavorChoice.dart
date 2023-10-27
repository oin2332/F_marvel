import 'package:flutter/material.dart';

class FlavorChoice extends StatefulWidget {
  const FlavorChoice({super.key});

  @override
  State<FlavorChoice> createState() => _FlavorChoiceState();
}

class _FlavorChoiceState extends State<FlavorChoice> {

  void _showConfirmationDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('내 취향 선택을 그만 하시겠어요?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
              SizedBox(height: 20),
              Divider( // 이 부분이 추가된 부분입니다.
                color: Colors.grey[300]!,
                thickness: 1,
                height: 1,
              ),
              SizedBox(height: 16),
              Text('취향선택을 완료하시면 취향에 맞게 추천해드려요!', style: TextStyle(color: Colors.grey),),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // 모달 닫기
                      Navigator.pop(context); // 현재 페이지 닫기
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Text('그만두기'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // 모달 닫기
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Text('계속하기'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('취향 선택'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: _showConfirmationDialog,
            ),
            bottom: TabBar(
              tabs: [
                Tab(text: '음식종류'),
                Tab(text: '가격범위')
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Padding( // 음식종류 탭
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('어떤 음식을 좋아하시나요'),
                    Text('최대 5개를 선택하실 수 있습니다.'),
                    SizedBox(height: 40),
                    Row(
                      children: [
                        ElevatedButton(onPressed: (){}, child: Text('한식')),
                        ElevatedButton(onPressed: (){}, child: Text('중식'))
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton(onPressed: (){}, child: Text('한식')),
                        ElevatedButton(onPressed: (){}, child: Text('중식'))
                      ],
                    )
                  ]
                ),
              ),
              Padding( // 가격범위 탭
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('프로필에는 노출되지 않습니다', style: TextStyle(color: Colors.deepOrange)),
                      Text('식당방문시 주로 고려하시는 가격대를'),
                      Text('선택해주세요(1인기준 가격입니다.)'),
                    ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
