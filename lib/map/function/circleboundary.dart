import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';

Circle getCircleBoundary(LatLng center, double radius) {
  return Circle(
    circleId: CircleId("boundary_circle"),
    center: center,
    radius: radius,
    fillColor: Color.fromRGBO(140, 225, 243, 0.2980392156862745), // 파란색 투명한 원
    strokeWidth: 0,
  );
}