import 'package:gantt_chart/classes/process.dart';
import 'package:gantt_chart/logic/fcfs_logic.dart' as fcfs;
import 'package:flutter/material.dart';

import '../chart.dart';

class FCFSUI extends StatefulWidget {
  @override
  _FCFSUIState createState() => _FCFSUIState();
}

class _FCFSUIState extends State<FCFSUI> {
  TextEditingController numberOfProcesses = TextEditingController();
  int numberOfFields = 2;
  var controllers;
  List<fcfs.InputProcess> input = [];
  void generateInput() {
    input = [];
    int numOfProcesses = numberOfProcesses.text.length == 0
        ? 0
        : double.tryParse(numberOfProcesses.text) == null
            ? 0
            : int.tryParse(numberOfProcesses.text);
    for (var i = 0; i < numOfProcesses; i++) {
      input.add(fcfs.InputProcess(id: i, burstTime: 0));
    }
  }

  void generateControllers() {
    int numOfProcesses = numberOfProcesses.text.length == 0
        ? 0
        : double.tryParse(numberOfProcesses.text) == null
            ? 0
            : int.tryParse(numberOfProcesses.text);
    controllers = List.generate(numOfProcesses, (index) => List(numberOfFields),
        growable: false);
    for (var i = 0; i < numOfProcesses; i++) {
      for (var j = 0; j < numberOfFields; j++) {
        controllers[i][j] = TextEditingController();
      }
    }
  }

  var validators;
  void generatevalidators() {
    int numOfProcesses = numberOfProcesses.text.length == 0
        ? 0
        : double.tryParse(numberOfProcesses.text) == null
            ? 0
            : int.tryParse(numberOfProcesses.text);
    validators = List.generate(numOfProcesses, (index) => List(numberOfFields),
        growable: false);
    for (var i = 0; i < numOfProcesses; i++) {
      for (var j = 0; j < numberOfFields; j++) {
        validators[i][j] = false;
      }
    }
  }

  void clearControllers() {
    int numOfProcesses = numberOfProcesses.text.length == 0
        ? 0
        : double.tryParse(numberOfProcesses.text) == null
            ? 0
            : int.tryParse(numberOfProcesses.text);

    for (var i = 0; i < numOfProcesses; i++) {
      for (var j = 0; j < numberOfFields; j++) {
        controllers[i][j].clear();
      }
    }
  }

  void emptyControllers() {
    int numOfProcesses = numberOfProcesses.text.length == 0
        ? 0
        : double.tryParse(numberOfProcesses.text) == null
            ? 0
            : int.tryParse(numberOfProcesses.text);

    for (var i = 0; i < numOfProcesses; i++) {
      for (var j = 0; j < numberOfFields; j++) {
        controllers[i][j].clear();
      }
    }
  }

  TextEditingController general = TextEditingController();

  Widget inputField(
      Function onChanged, TextEditingController controller, bool valid) {
    return Container(
      width: 60,
      margin: EdgeInsets.symmetric(vertical: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          fillColor: Color(0xfff0f2f5),
          filled: true,
          errorText: valid
              ? controller.text.length == 0
                  ? 'Empty'
                  : double.tryParse(controller.text) == null
                      ? 'Invalid'
                      : null
              : null,
          border: OutlineInputBorder(),
        ),
        textAlign: TextAlign.center,
        onChanged: onChanged,
      ),
    );
  }

  var obj;
  double avgWaitingTime;
  List<fcfs.InputProcess> output = [];
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // number of processes
      Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 16),
          Text('Number of processes:'),
          SizedBox(width: 15),
          Container(
            width: 50,
            height: 50,
            child: TextField(
              decoration: InputDecoration(
                // errorText: numberOfProcesses.text.length == 0
                //     ? null
                //     : double.tryParse(numberOfProcesses.text) == null
                //         ? 'Invalid'
                //         : null,
                fillColor: Color(0xfff0f2f5),
                filled: true,
                border: OutlineInputBorder(),
              ),
              textAlign: TextAlign.center,
              controller: numberOfProcesses,
              onChanged: (s) {
                if (double.tryParse(numberOfProcesses.text) != null)
                  setState(() {
                    generateInput();
                    generateControllers();
                    generatevalidators();
                  });
                else
                  setState(() {
                    generateInput();
                    generateControllers();
                    generatevalidators();
                  });
              },
            ),
          ),
        ],
      ),
      SizedBox(height: 25),
      // titles
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 60,
              alignment: Alignment.center,
              child: Text(
                '#',
                textAlign: TextAlign.center,
              )),
          SizedBox(width: 25),
          Container(
              width: 60,
              alignment: Alignment.center,
              child: Text(
                'Id',
                textAlign: TextAlign.center,
              )),
          SizedBox(width: 25),
          Container(
              width: 60,
              alignment: Alignment.center,
              child: Text(
                'Burst time',
                textAlign: TextAlign.center,
              )),
        ],
      ),
      // user input
      Container(
        height: 250,
        child: Scrollbar(
          isAlwaysShown: true,
          thickness: 14,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: numberOfProcesses.text.length == 0 ? 0 : input.length,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      child: CircleAvatar(
                          backgroundColor: Color(0xfff0f2f5),
                          child: Text('${index + 1}')),
                    ),
                    SizedBox(width: 25),
                    inputField((s) {
                      setState(() {
                        input[index].id = int.tryParse(s);
                      });
                    }, controllers[index][0], validators[index][0]),
                    SizedBox(width: 25),
                    inputField((s) {
                      setState(() {
                        input[index].burstTime = int.tryParse(s);
                      });
                    }, controllers[index][1], validators[index][1]),
                    // SizedBox(width: 50),
                    // inputField((s) {
                    //   setState(() {
                    //     input[index].waitingTime = double.tryParse(s);
                    //   });
                    // }, controllers[index][2],validators[index][2]),
                  ],
                );
              }),
        ),
      ),
      // function buttons
      SizedBox(
        height: 25,
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 40),
          ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Draw",
                style: TextStyle(fontSize: 17),
              ),
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
            onPressed: () {
              bool go = true;
              setState(() {
                go = true;
              });
              int numOfProcesses = numberOfProcesses.text.length == 0
                  ? 0
                  : double.tryParse(numberOfProcesses.text) == null
                      ? 0
                      : int.tryParse(numberOfProcesses.text);
              for (var i = 0; i < numOfProcesses; i++) {
                for (var j = 0; j < numberOfFields; j++) {
                  if (controllers[i][j].text.isEmpty ||
                      double.tryParse(controllers[i][j].text) == null) {
                    setState(() {
                      validators[i][j] = true;
                      go = false;
                    });
                  } else {
                    setState(() {
                      validators[i][j] = false;
                    });
                  }
                }
              }
              if (go && numberOfProcesses.text.length != 0) {
                setState(() {
                  obj = fcfs.FCFS(input);
                  output = obj.output;
                  avgWaitingTime = obj.avgWaitingTime;
                });
              }
            },
          ),
          SizedBox(width: 25),
          ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Clear',
                style: TextStyle(fontSize: 17),
              ),
            ),
            onPressed: () {
              setState(() {
                generateInput();
                clearControllers();
                numberOfProcesses.clear();
                output = [];
              });
            },
          ),
        ],
      ),
      SizedBox(height: 40),
      // chart
      Center(
        child: output.length == 0
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    child: Chart(
                        procesess: output.map((process) {
                      return Process(
                          processTitle: process.id.toString(),
                          startTime: 0,
                          endTime: process.endBurstTime.toInt());
                    }).toList()),
                  ),
                  Text(
                    "AVG Waiting time: " + avgWaitingTime.toStringAsFixed(3),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ),
    ]);
  }
}
