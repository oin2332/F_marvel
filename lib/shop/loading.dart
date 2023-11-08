import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSpinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitThreeInOut(
        color: Color(0xFFFF6347), // 스피너의 색상 설정
        size: 50.0, // 스피너의 크기 설정
        duration: Duration(seconds: 1), // 스피너의 애니메이션 지속 시간 설정
      ),
    );
  }
}
//SpinKit( 자동완성에 나오는것들 확인) 해서 로딩 모양 변경할수있음