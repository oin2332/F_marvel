import 'package:flutter/material.dart';

class ImportTimeLine extends StatefulWidget {
  const ImportTimeLine({super.key});

  @override
  State<ImportTimeLine> createState() => _ImportTimeLineState();
}

class _ImportTimeLineState extends State<ImportTimeLine> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 15,),
        Text("타임라인",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
      ],
    );
  }
}
