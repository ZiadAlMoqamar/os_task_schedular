import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gantt_chart/classes/process.dart';
import 'package:gantt_chart/screens/InputScreen/Input_screen.dart';
import 'package:provider/provider.dart';

import 'classes/process.dart';
import 'components/chart.dart';
import 'constants.dart' as constants;
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
  String technique = '';
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String changeTechnique(String techneque) {
    setState(() {
      widget.technique = techneque;
    });
  }

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
    // print(obj.avgWaitingTime);
    /////////////////
    return Scaffold(
      appBar: AppBar(
        title: Text('Chart'),
      ),
      body: ListView(
        children: [
          InputScreen(technique: widget.technique, change: changeTechnique),
          Expanded(
            child: Center(
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
                  Text("AVG Waiting time: ${widget.technique}" +
                      obj.avgWaitingTime.toString())
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
