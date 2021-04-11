import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gantt_chart/classes/process.dart';

import 'components/chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Process> procesess = [
    Process(processTitle: 'P1', startTime: 0, endTime: 4),
    Process(processTitle: 'P2', startTime: 5, endTime: 50),
    Process(processTitle: 'P3', startTime: 0, endTime: 5),
    Process(processTitle: 'P3', startTime: 0, endTime: 5),
    Process(processTitle: 'P3', startTime: 0, endTime: 5),
    Process(processTitle: 'P3', startTime: 0, endTime: 5),
    Process(processTitle: 'P3', startTime: 0, endTime: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chart'),
      ),
      body: Center(
        child: Container(
          height: 100,
          child: Chart(procesess: procesess),
        ),
      ),
    );
  }
}
