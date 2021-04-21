import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gantt_chart/classes/process.dart';
import 'package:gantt_chart/components/chart.dart';
import 'package:gantt_chart/components/technique_views/fcfs_view.dart';
import 'package:gantt_chart/components/technique_views/non_preem_priority_view.dart';
import 'package:gantt_chart/components/technique_views/preemp_priority_view.dart';
import 'package:gantt_chart/components/technique_views/rr_view.dart';
import 'package:gantt_chart/components/technique_views/sjf.dart';
import 'package:gantt_chart/components/technique_views/srtf_view.dart';

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
        Expanded(
            child: Text(
          selectedTechnique,
          overflow: TextOverflow.clip,
        ))
      ],
    );
  }

  Widget selectTechnequeView() {
    switch (widget.technique) {
      case "FCFS":
        return FCFSUI();
        break;
      case "Preemptive SJF":
        return SRTFUI();
      case "Non-preemptive SJF":
        return SJFUI();
      case "Non-preemptive priority":
        return NonPreemPriorityUI();
      case 'Round Robin':
        return RoundRobinUI();
      case 'Preemptive priority':
        return PreempPriority();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Radio buttons
        Container(
          width: MediaQuery.of(context).size.width / 6,
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
          child: Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                      Text(
                        'Choose technique',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                    ] +
                    availableTechniques.map((e) => RadioBtn(e)).toList()),
          ),
        ),
        Expanded(
          child: Transform.translate(
            offset: Offset(-100, 0),
            child: SingleChildScrollView(
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: selectTechnequeView()),
            ),
          ),
        ),
      ],
    );
  }
}
