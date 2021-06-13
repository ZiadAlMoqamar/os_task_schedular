import 'package:flutter/material.dart';
import 'package:gantt_chart/components/technique_views/fcfs_view.dart';
import 'package:gantt_chart/components/technique_views/non_preem_priority_view.dart';
import 'package:gantt_chart/components/technique_views/preemp_priority_RR_view.dart';
import 'package:gantt_chart/components/technique_views/preemp_priority_view.dart';
import 'package:gantt_chart/components/technique_views/rr_view.dart';
import 'package:gantt_chart/components/technique_views/sjf_view.dart';
import 'package:gantt_chart/components/technique_views/srtf_view.dart';

class InputScreen extends StatefulWidget {
  String technique;
  Function change;
  InputScreen({this.technique, this.change});

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  ScrollController _scrollController = ScrollController();
  List<String> availableTechniques = [
    'FCFS',
    'Preemptive SJF',
    'Non-preemptive SJF',
    'Preemptive priority',
    'Priority with Round Robin',
    'Non-preemptive priority',
    'Round Robin'
  ];
  Widget RadioBtn(String selectedTechnique) {
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        setState(() {
          widget.change(selectedTechnique);
          widget.technique = selectedTechnique;
        });
      },
      child: Row(
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
            style: TextStyle(
              color: widget.technique == selectedTechnique
                  ? Colors.blueAccent
                  : null,
            ),
            overflow: TextOverflow.clip,
          ))
        ],
      ),
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
      case 'Priority with Round Robin':
        return PreempPriorityWRR();
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
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    Text(
                      'Choose Technique',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                  ] +
                  availableTechniques.map((e) => RadioBtn(e)).toList()),
        ),
        Expanded(
          child: Scrollbar(
            isAlwaysShown: true,
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: selectTechnequeView()),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 8,
        )
      ],
    );
  }
}
