import 'package:gantt_chart/classes/process.dart';
import 'package:gantt_chart/logic/srtf_logic.dart' as srtf;
import 'package:flutter/material.dart';

import '../chart.dart';

class SRTFUI extends StatefulWidget {
  @override
  _SRTFUIState createState() => _SRTFUIState();
}

class _SRTFUIState extends State<SRTFUI> {
  TextEditingController numberOfProcesses = TextEditingController();
  bool _validate = false;
  int numberOfFields = 3;
  var controllers;
  List<srtf.InputProcess> input = [];
  void generateInput() {
    input = [];
    int numOfProcesses = numberOfProcesses.text.length == 0
        ? 0
        : int.parse(numberOfProcesses.text);
    for (var i = 0; i < numOfProcesses; i++) {
      input.add(srtf.InputProcess(id: i, burstTime: 0, arrivalTime: 0));
    }
  }

  void generateControllers() {
    int numOfProcesses = numberOfProcesses.text.length == 0
        ? 0
        : int.parse(numberOfProcesses.text);
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
        : int.parse(numberOfProcesses.text);
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
        : int.parse(numberOfProcesses.text);

    for (var i = 0; i < numOfProcesses; i++) {
      for (var j = 0; j < numberOfFields; j++) {
        controllers[i][j].clear();
      }
    }
  }

  void emptyControllers() {
    int numOfProcesses = numberOfProcesses.text.length == 0
        ? 0
        : int.parse(numberOfProcesses.text);

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
          errorText: controller.text.length == 0
              ? null
              : controller.text.isEmpty
                  ? 'Empty'
                  : double.tryParse(controller.text) == null
                      ? 'Invalid'
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
  List<srtf.OutputProcess> output = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(children: [
          // number of processes
          Container(
            width: MediaQuery.of(context).size.width / 5,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 40),
                Row(
                  children: [
                    Text('Number of processes:'),
                    SizedBox(width: 15),
                    Container(
                      width: 50,
                      height: 50,
                      child: TextField(
                        decoration: InputDecoration(
                          fillColor: Color(0xfff0f2f5),
                          filled: true,
                          border: OutlineInputBorder(),
                        ),
                        textAlign: TextAlign.center,
                        controller: numberOfProcesses,
                        onChanged: (s) {
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
              ],
            ),
          ),
          SizedBox(height: 25),
          // titles
          Container(
            width: MediaQuery.of(context).size.width / 4,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
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
                SizedBox(width: 25),
                Container(
                    width: 60,
                    alignment: Alignment.center,
                    child: Text(
                      'Arrival time',
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
          ),
          // user input
          Container(
              height: 250,
              width: MediaQuery.of(context).size.width / 4,
              child: Scrollbar(
                child: ListView.builder(
                    itemCount:
                        numberOfProcesses.text.length == 0 ? 0 : input.length,
                    itemBuilder: (context, index) {
                      return Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              input[index].id = int.parse(s);
                            });
                          }, controllers[index][0], validators[index][0]),
                          SizedBox(width: 25),
                          inputField((s) {
                            setState(() {
                              input[index].burstTime = int.parse(s);
                            });
                          }, controllers[index][1], validators[index][1]),
                          SizedBox(width: 25),
                          inputField((s) {
                            setState(() {
                              input[index].arrivalTime = int.parse(s);
                            });
                          }, controllers[index][2], validators[index][2]),
                        ],
                      );
                    }),
              )),
          // function buttons
          SizedBox(
            height: 25,
          ),
          Container(
            // margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            width: MediaQuery.of(context).size.width / 5,

            child: Row(
              children: [
                SizedBox(width: 40),
                ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Calculate',
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
                        : int.parse(numberOfProcesses.text);
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
                    List<srtf.InputProcess> victimList = [];
                    if (go && numberOfProcesses.text.length != 0) {
                      setState(() {
                        victimList.addAll(input);
                        obj = srtf.SRTF(victimList);
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
                )
              ],
            ),
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
                        "AVG Waiting time: " +
                            avgWaitingTime.toStringAsFixed(3),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
          ),
        ]),
      ),
    );
  }
}
