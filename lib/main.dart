import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gantt_chart/classes/process.dart';

import 'components/chart.dart';
import 'logic/os_logic.dart' as os_logic;

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
    ///////////
    var input = [
      os_logic.InputProcess(id: 1, burstTime: 24),
      os_logic.InputProcess(id: 2, burstTime: 3),
      os_logic.InputProcess(id: 3, burstTime: 3),
    ];
    var obj = os_logic.FCFS(input);
    print(obj.avgWaitingTime);
    /////////////////
    return Scaffold(
      appBar: AppBar(
        title: Text('Chart'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              child: Chart(procesess: procesess),
            ),
            Text(obj.avgWaitingTime.toString())
          ],
        ),
      ),
    );
  }
}
