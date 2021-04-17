import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gantt_chart/classes/process.dart';

import 'classes/process.dart';
import 'components/chart.dart';
import 'logic/fcfs_logic.dart' as fcfs_logic;
import 'logic/sjf_logic.dart' as sjf_logic;
import 'logic/srtf_logic.dart' as srtf_logic;

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
  // List<Process> procesess = [
  //   Process(processTitle: 'P1', startTime: 0, endTime: 4),
  //   Process(processTitle: 'P2', startTime: 5, endTime: 50),
  //   Process(processTitle: 'P3', startTime: 0, endTime: 5),
  //   Process(processTitle: 'P3', startTime: 0, endTime: 5),
  //   Process(processTitle: 'P3', startTime: 0, endTime: 5),
  //   Process(processTitle: 'P3', startTime: 0, endTime: 5),
  //   Process(processTitle: 'P3', startTime: 0, endTime: 5),
  // srtf_logic.InputProcess(id: 1, burstTime: 7, arrivalTime: 0),
  // srtf_logic.InputProcess(id: 2, burstTime: 5, arrivalTime: 1),
  // srtf_logic.InputProcess(id: 3, burstTime: 3, arrivalTime: 2),
  // srtf_logic.InputProcess(id: 4, burstTime: 1, arrivalTime: 3),
  // srtf_logic.InputProcess(id: 5, burstTime: 2, arrivalTime: 4),
  // srtf_logic.InputProcess(id: 6, burstTime: 1, arrivalTime: 5),
  // ];

  // doctoer example
// srtf_logic.InputProcess(id: 1, burstTime: 8, arrivalTime: 0),
//       srtf_logic.InputProcess(id: 2, burstTime: 4, arrivalTime: 1),
//       srtf_logic.InputProcess(id: 3, burstTime: 9, arrivalTime: 2),
//       srtf_logic.InputProcess(id: 4, burstTime: 5, arrivalTime: 3),
// net example
// srtf_logic.InputProcess(id: 1, burstTime: 3, arrivalTime: 0),
  // srtf_logic.InputProcess(id: 2, burstTime: 2, arrivalTime: 0),
  // srtf_logic.InputProcess(id: 3, burstTime: 1, arrivalTime: 2),
  // srtf_logic.InputProcess(id: 4, burstTime: 2, arrivalTime: 3),
  // another example
  // srtf_logic.InputProcess(id: 1, burstTime: 4, arrivalTime: 0),
  //     srtf_logic.InputProcess(id: 2, burstTime: 5, arrivalTime: 1),
  //     srtf_logic.InputProcess(id: 3, burstTime: 2, arrivalTime: 2),
  //     srtf_logic.InputProcess(id: 4, burstTime: 1, arrivalTime: 3),
  //     srtf_logic.InputProcess(id: 5, burstTime: 6, arrivalTime: 4),
  //     srtf_logic.InputProcess(id: 6, burstTime: 3, arrivalTime: 5),
  // another one
  // srtf_logic.InputProcess(id: 1, burstTime: 7, arrivalTime: 0),
  // srtf_logic.InputProcess(id: 2, burstTime: 4, arrivalTime: 2),
  // srtf_logic.InputProcess(id: 3, burstTime: 1, arrivalTime: 4),
  // srtf_logic.InputProcess(id: 4, burstTime: 4, arrivalTime: 5),
  @override
  Widget build(BuildContext context) {
    ///////////
    var input = [
      srtf_logic.InputProcess(id: 1, burstTime: 7, arrivalTime: 0),
      srtf_logic.InputProcess(id: 2, burstTime: 5, arrivalTime: 1),
      srtf_logic.InputProcess(id: 3, burstTime: 3, arrivalTime: 2),
      srtf_logic.InputProcess(id: 4, burstTime: 1, arrivalTime: 3),
      srtf_logic.InputProcess(id: 5, burstTime: 2, arrivalTime: 4),
      srtf_logic.InputProcess(id: 6, burstTime: 1, arrivalTime: 5),
    ];

    var obj = srtf_logic.SRTF(input);
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
              child: Chart(
                  procesess: obj.output.map((process) {
                return Process(
                    processTitle: process.id.toString(),
                    startTime: 0,
                    endTime: process.endBurstTime.toInt());
              }).toList()),
            ),
            Text("AVG Waiting time: " + obj.avgWaitingTime.toString())
          ],
        ),
      ),
    );
  }
}
