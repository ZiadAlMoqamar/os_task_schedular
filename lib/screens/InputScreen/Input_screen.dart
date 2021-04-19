import 'package:flutter/material.dart';
import 'package:gantt_chart/classes/process.dart';
import 'package:gantt_chart/components/chart.dart';
import 'package:gantt_chart/constants.dart';
import 'package:gantt_chart/logic/fcfs_logic.dart' as fcfs;

class InputScreen extends StatefulWidget {
  String technique;
  Function change;
  InputScreen({this.technique, this.change});

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  List<String> availableTechniques = [
    'FCFS',
    'Preemptive SJF',
    'Non-preemptive SJF',
    'Preemptive priority',
    'Non-preemptive priority',
    'Round Robin'
  ];
  Widget RadioBtn(String selectedTechnique) {
    return Row(
      children: [
        Radio(
            value: selectedTechnique,
            groupValue: widget.technique,
            onChanged: (e) {
              setState(() {
                widget.change(selectedTechnique);
                widget.technique = selectedTechnique;
              });
            }),
        Text(selectedTechnique)
      ],
    );
  }

  Widget selectTechnequeView() {
    switch (widget.technique) {
      case "FCFS":
        return FCFSUI();
        break;
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Colors.black,
                width: 1,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose technique',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:
                      availableTechniques.map((e) => RadioBtn(e)).toList()),
            ],
          ),
        ),
        Expanded(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: selectTechnequeView())),
      ],
    );
  }
}

class FCFSUI extends StatefulWidget {
  @override
  _FCFSUIState createState() => _FCFSUIState();
}

class _FCFSUIState extends State<FCFSUI> {
  TextEditingController numberOfProcesses = TextEditingController();
  var controllers;
  List<fcfs.InputProcess> input = [];
  void generateInput() {
    input = [];
    int numOfProcesses = numberOfProcesses.text.length == 0
        ? 0
        : int.parse(numberOfProcesses.text);
    for (var i = 0; i < numOfProcesses; i++) {
      input.add(fcfs.InputProcess(id: i, burstTime: 0, waitingTime: 0));
    }
  }

  void generateControllers() {
    int numOfProcesses = numberOfProcesses.text.length == 0
        ? 0
        : int.parse(numberOfProcesses.text);
    controllers =
        List.generate(numOfProcesses, (index) => List(3), growable: false);
    for (var i = 0; i < numOfProcesses; i++) {
      for (var j = 0; j < 3; j++) {
        controllers[i][j] = TextEditingController();
      }
    }
  }

  void clearControllers() {
    int numOfProcesses = numberOfProcesses.text.length == 0
        ? 0
        : int.parse(numberOfProcesses.text);

    for (var i = 0; i < numOfProcesses; i++) {
      for (var j = 0; j < 3; j++) {
        controllers[i][j].clear();
      }
    }
  }

  TextEditingController general = TextEditingController();

  Widget inputField(Function onChanged, TextEditingController controller) {
    return Container(
      width: 50,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(),
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
      Container(
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Number of processes'),
                Container(
                  width: 40,
                  height: 40,
                  child: TextField(
                    controller: numberOfProcesses,
                    onSubmitted: (s) {
                      setState(() {
                        generateInput();
                        generateControllers();
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
      Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Title'),
          SizedBox(width: 60),
          Text('Burst time'),
        ],
      ),
      // user input
      Container(
          height: 250,
          child: Scrollbar(
            isAlwaysShown: true,
            child: ListView.builder(
                itemCount:
                    numberOfProcesses.text.length == 0 ? 0 : input.length,
                itemBuilder: (context, index) {
                  return Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      inputField((s) {
                        setState(() {
                          input[index].id = int.parse(s);
                        });
                      }, controllers[index][0]),
                      SizedBox(width: 50),
                      inputField((s) {
                        setState(() {
                          input[index].burstTime = int.parse(s);
                        });
                      }, controllers[index][1]),
                      // SizedBox(width: 50),
                      // inputField((s) {
                      //   setState(() {
                      //     input[index].waitingTime = double.parse(s);
                      //   });
                      // }, controllers[index][2]),
                    ],
                  );
                }),
          )),
      Container(
        // margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            RaisedButton(
              child: Text('Calculate'),
              onPressed: () {
                if (input[0].burstTime != 0)
                  setState(() {
                    obj = fcfs.FCFS(input);
                    output = obj.output;
                    avgWaitingTime = obj.avgWaitingTime;
                  });
              },
            ),
            SizedBox(width: 25),
            RaisedButton(
              child: Text('Clear'),
              onPressed: () {
                setState(() {
                  generateInput();
                  clearControllers();
                  output = [];
                });
              },
            )
          ],
        ),
      ),
      SizedBox(height: 40),
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
                  Text("AVG Waiting time: " + avgWaitingTime.toString()),
                ],
              ),
      ),
    ]);
  }
}
