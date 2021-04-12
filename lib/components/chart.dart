import 'package:flutter/material.dart';
import 'package:gantt_chart/classes/process.dart';

class Chart extends StatelessWidget {
  const Chart({
    Key key,
    @required this.procesess,
  }) : super(key: key);

  final List<Process> procesess;

  @override
  Widget build(BuildContext context) {
    double minimumWidth = 30;

    return Scrollbar(
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: procesess.map((process) {
          return ProcessWidget(
              width: ((process.endTime - process.startTime) * 10).toDouble() <
                      minimumWidth
                  ? minimumWidth
                  : ((process.endTime - process.startTime) * 10).toDouble(),
              start: process.startTime,
              end: process.endTime,
              processTitle: process.processTitle);
        }).toList(),
      ),
    );
  }
}

class ProcessWidget extends StatelessWidget {
  const ProcessWidget({
    @required this.width,
    this.start,
    this.end,
    this.processTitle,
    Key key,
  }) : super(key: key);
  final double width;
  final int start;
  final String processTitle;
  final int end;
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      textStyle: TextStyle(fontSize: 16, color: Colors.white),
      message: 'P$processTitle\n$start ~ $end',
      child: Container(
        child: Column(
          children: [
            Container(
              height: 60,
              width: width,
              decoration: BoxDecoration(border: Border.all(width: 1)),
              child: Center(
                child: Text(
                  "P"+processTitle,
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
            Container(
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      start == null ? '' : ' $start ',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      end == null ? '' : '$end',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
