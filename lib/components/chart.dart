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
    double minimumWidth = 50;
    int i = 0;
    double calcWidth(Process process, int i) {
      return ((process.endTime - (i == 1 ? 0 : procesess[i - 2].endTime)) * 60)
                  .toDouble() <
              minimumWidth
          ? minimumWidth
          : ((process.endTime - (i == 1 ? 0 : procesess[i - 2].endTime)) * 60)
              .toDouble();
    }

    return Scrollbar(
      child: Container(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 8),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: procesess.map((process) {
            i++;

            return ProcessWidget(
              width: calcWidth(process, i),
              start: (i == 1 ? 0 : procesess[i - 2].endTime),
              end: process.endTime,
              processTitle: process.processTitle,
              first: (i == 1),
              last: (procesess.length == i),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ProcessWidget extends StatelessWidget {
  const ProcessWidget({
    @required this.width,
    this.start,
    this.end,
    this.first,
    this.last,
    this.processTitle,
    Key key,
  }) : super(key: key);
  final double width;
  final int start;
  final String processTitle;
  final int end;
  final bool last;
  final bool first;
  @override
  Widget build(BuildContext context) {
    double borderSideWidth = 3;
    double borderTopBotWidth = 3;
    Color topBotBorderColor = Colors.grey[700];
    Color inBetweenBorderColor = Colors.grey[500];

    return Tooltip(
      textStyle: TextStyle(fontSize: 16, color: Colors.white),
      message:
          'Process: $processTitle\n$start ~ $end\nDuration: ${end - start}',
      child: Container(
        child: Column(
          children: [
            Container(
              height: 60,
              width: width,
              decoration: BoxDecoration(
                // color: Colors.grey[200],
                border: Border(
                  left: !first
                      ? BorderSide(
                          color: inBetweenBorderColor,
                          width: 1,
                        )
                      : BorderSide(
                          color: topBotBorderColor,
                          width: borderSideWidth,
                        ),
                  top: BorderSide(
                    color: topBotBorderColor,
                    width: borderTopBotWidth,
                  ),
                  right: !last
                      ? BorderSide(
                          color: inBetweenBorderColor,
                          width: 1,
                        )
                      : BorderSide(
                          color: topBotBorderColor,
                          width: borderSideWidth,
                        ),
                  bottom: BorderSide(
                    color: topBotBorderColor,
                    width: borderTopBotWidth,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  (processTitle == "idle" ? '' : "P") + processTitle,
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
                    child: first
                        ? Text(
                            start == null ? '' : ' $start ',
                            overflow: TextOverflow.ellipsis,
                          )
                        : Text(''),
                  ),
                  Flexible(
                    child: Transform.translate(
                      offset: Offset(3, 0),
                      child: Text(
                        end == null ? '' : '$end',
                        overflow: TextOverflow.ellipsis,
                      ),
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
