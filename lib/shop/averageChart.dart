import 'package:flutter/material.dart';
import 'package:vertical_barchart/vertical-barchart.dart';
import 'package:vertical_barchart/vertical-barchartmodel.dart';
import 'package:vertical_barchart/vertical-legend.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(
        title: "Vertical Barchart",
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<VBarChartModel> bardata = [
    VBarChartModel(
      index: 0,
      label: "5점",
      colors: [Colors.orange, Colors.deepOrange],
      jumlah: 20,
      tooltip: "20 Pcs",
      description: Text(
        "Most selling fruit last week",
        style: TextStyle(fontSize: 10),
      ),
    ),
    VBarChartModel(
      index: 1,
      label: "4점",
      colors: [Colors.orange, Colors.deepOrange],
      jumlah: 55,
      tooltip: "55 Pcs",
      description: Text(
        "Most selling fruit this week",
        style: TextStyle(fontSize: 10),
      ),
    ),
    VBarChartModel(
      index: 2,
      label: "3점",
      colors: [Colors.teal, Colors.indigo],
      jumlah: 12,
      tooltip: "12 Pcs",
    ),
    VBarChartModel(
      index: 3,
      label: "2점",
      colors: [Colors.teal, Colors.indigo],
      jumlah: 1,
      tooltip: "5 Pcs",
    ),
    VBarChartModel(
      index: 4,
      label: "1점",
      colors: [Colors.orange, Colors.deepOrange],
      jumlah: 15,
      tooltip: "15 Pcs",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ""),
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [
              _buildGrafik(bardata),
            ],
          )),
    );
  }

  Widget _buildGrafik(List<VBarChartModel> bardata) {
    return VerticalBarchart(
      maxX: 55,
      data: bardata,
      showLegend: true,
      showBackdrop: true,
      barStyle: BarStyle.DEFAULT,
      alwaysShowDescription: true,
    );
  }
}