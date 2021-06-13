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
  TextEditingController quantumField = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool idError = false;
  bool numberOfProcessesValidation = false;
  int numberOfFields = 3;
  var controllers;
  List<fcfs.FCFSInputProcess> input = [];
  void generateInput() {
    input = [];
    int numOfProcesses = numberOfProcesses.text.length == 0
        ? 0
        : double.tryParse(numberOfProcesses.text) == null
            ? 0
            : int.tryParse(numberOfProcesses.text);
    for (var i = 0; i < numOfProcesses; i++) {
      input.add(fcfs.FCFSInputProcess(id: i, burstTime: 0));
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
      Function onChanged, TextEditingController controller, bool valid,
      [bool burst = false]) {
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
                      : double.tryParse(controller.text).isNegative ||
                              (burst && double.tryParse(controller.text) == 0)
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
  List<Process> output = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(children: [
          // number of processes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(width: 40),
                    Row(
                      children: [
                        Container(
                            width: 150, child: Text('Number of processes:')),
                        SizedBox(width: 15),
                        Container(
                          width: 60,
                          child: TextField(
                            decoration: InputDecoration(
                              errorText: numberOfProcessesValidation
                                  ? numberOfProcesses.text.length == 0
                                      ? 'Empty'
                                      : double.tryParse(
                                                  numberOfProcesses.text) ==
                                              null
                                          ? 'Invalid'
                                          : double.tryParse(
                                                      numberOfProcesses.text) <
                                                  0
                                              ? 'Invalid'
                                              : null
                                  : null,
                              fillColor: Color(0xfff0f2f5),
                              filled: true,
                              border: OutlineInputBorder(),
                            ),
                            textAlign: TextAlign.center,
                            controller: numberOfProcesses,
                            onChanged: (s) {
                              if (double.tryParse(numberOfProcesses.text) !=
                                  null)
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
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 25),

          // titles
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
              child: Scrollbar(
                controller: _scrollController,
                isAlwaysShown: true,
                thickness: 14,
                child: ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount:
                        numberOfProcesses.text.length == 0 ? 0 : input.length,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                          }, controllers[index][1], validators[index][1], true),
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
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Row(
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        bool go = true;
                        setState(() {
                          go = true;
                          idError = false;
                          numberOfProcessesValidation = true;
                        });
                        int numOfProcesses = numberOfProcesses.text.length == 0
                            ? 0
                            : double.tryParse(numberOfProcesses.text) == null
                                ? 0
                                : int.tryParse(numberOfProcesses.text);
                        for (var i = 0; i < numOfProcesses; i++) {
                          for (var j = 0; j < numberOfFields; j++) {
                            if (controllers[i][j].text.isEmpty ||
                                double.tryParse(controllers[i][j].text) ==
                                    null ||
                                double.tryParse(controllers[i][j].text)
                                    .isNegative ||
                                double.tryParse(controllers[i][1].text) == 0) {
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
                        for (int i = 0; i < numOfProcesses; i++) {
                          for (int j = 0; j < numOfProcesses; j++) {
                            if (i == j) break;

                            if (controllers[i][0].text ==
                                controllers[j][0].text) {
                              setState(() {
                                go = false;
                                idError = true;
                              });
                            }
                          }
                        }
                        List<fcfs.FCFSInputProcess> victimList = [];
                        if (go && numberOfProcesses.text.length != 0) {
                          setState(() {
                            victimList.addAll(input);
                            obj = fcfs.FCFS(victimList);
                            output = obj.output;
                            avgWaitingTime = obj.avgWaitingTime;
                          });
                        }
                      },
                    ),
                    SizedBox(width: 25),
                    ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
                          quantumField.clear();
                          output = [];
                        });
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          !idError
              ? Container()
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      'Same id is not allowed!',
                      style: TextStyle(color: Colors.red),
                    )
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
                        child: Chart(procesess: output),
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
