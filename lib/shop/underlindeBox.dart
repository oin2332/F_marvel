import 'package:flutter/material.dart';

class UnderLindeBox {

  Widget underlineBox(double x) {
    return SizedBox(
      width: double.infinity,
      height: x,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey[400],
        ),
      ),
    );
  }
}
