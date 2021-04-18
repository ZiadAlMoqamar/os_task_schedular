import 'package:flutter/material.dart';
import 'package:gantt_chart/constants.dart' as constants;
import 'package:gantt_chart/logic/fcfs_logic.dart';
import 'package:provider/provider.dart';

class InputScreen extends StatefulWidget {
  String technique;
  Function change;
  InputScreen({this.technique, this.change});

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  TextEditingController numberOfProcesses = TextEditingController();
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

  List<InputProcess> input = [];
  void generateInput() {
    input = [];
    int numOfProcesses = numberOfProcesses.text.length == 0
        ? 0
        : int.parse(numberOfProcesses.text);
    for (var i = 0; i < numOfProcesses; i++) {
      input.add(InputProcess(id: i, burstTime: 0, waitingTime: 0));
    }
  }

  Widget inputField(Function onChanged) {
    return Container(
      width: 50,
      child: TextFormField(
        decoration: InputDecoration(),
        textAlign: TextAlign.center,
        onChanged: onChanged,
      ),
    );
  }

  int i = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
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
                  });
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:
                      availableTechniques.map((e) => RadioBtn(e)).toList()),
            ),
          ],
        ),
        SizedBox(width: 25),
        Expanded(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Title'),
                Text('Arrival'),
                Text('Burst time'),
              ],
            ),
            // user input
            Container(
                height: 200,
                child: Scrollbar(
                  isAlwaysShown: true,
                  child: ListView.builder(
                      itemCount:
                          numberOfProcesses.text.length == 0 ? 0 : input.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            inputField(
                              (s) {
                                setState(() {
                                  input[index].id = int.parse(s);
                                });
                              },
                            ),
                            inputField(
                              (s) {
                                setState(() {
                                  input[index].burstTime = int.parse(s);
                                });
                              },
                            ),
                            inputField(
                              (s) {
                                setState(() {
                                  input[index].waitingTime = double.parse(s);
                                });
                              },
                            ),
                          ],
                        );
                      }),
                )),
          ]),
        )
      ],
    );
  }
}
