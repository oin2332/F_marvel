import 'package:flutter/material.dart';

class Sample20 extends StatefulWidget {
  const Sample20({super.key});

  @override
  State<Sample20> createState() => _Sample20State();
}

class _Sample20State extends State<Sample20> {
  double _x = 0, _y = 0;
  Offset? _startPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanStart: (details) {
          _startPosition = details.localPosition;
        },
        onPanUpdate: (details) {
          if (_startPosition != null) {
            final dx = details.localPosition.dx - _startPosition!.dx;
            final dy = details.localPosition.dy - _startPosition!.dy;

            setState(() {
              _x += dx;
              _y += dy;
            });

            _startPosition = details.localPosition;
          }
        },
        onPanEnd: (details) {

        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(_x, _y),
              child: Container(
                width: 250,
                height: 250,
                color: Colors.lightBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}