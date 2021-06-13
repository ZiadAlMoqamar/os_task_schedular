import 'dart:core';

import 'package:gantt_chart/classes/process.dart';
import 'dart:math';

class FCFSInputProcess {
  int id;
  int burstTime;
  int arrivalTime;
  FCFSInputProcess({this.id = 0, this.burstTime = 0, this.arrivalTime});
}

class FCFS {
  var avgWaitingTime;
  List<Process> output = [];

  FCFS(List<FCFSInputProcess> input) {
    List<FCFSInputProcess> victimInput = [];
    input.forEach((element) {
      victimInput.add(FCFSInputProcess(
          arrivalTime: element.arrivalTime,
          burstTime: element.burstTime,
          id: element.id));
    });
    output = calculateOutput(victimInput);
    avgWaitingTime = calculateAvgWaitingTime(input);
  }

  List<Process> calculateOutput(List<FCFSInputProcess> input) {
    List<Process> output = [];
    int cpuTime = 0;

    while (input.length > 0) {
      int minArrival = input.map((p) => p.arrivalTime).toList().reduce(min);
      if (minArrival > cpuTime) {
        cpuTime = minArrival;
        output.add(Process(processTitle: "idle", endTime: cpuTime));
      }

      FCFSInputProcess process =
          input.firstWhere((p) => p.arrivalTime == minArrival);

      cpuTime += process.burstTime;
      output
          .add(Process(processTitle: process.id.toString(), endTime: cpuTime));
      int index = input.indexWhere((p) => p.id == process.id);
      input.removeAt(index);
    }

    return output;
  }

  double calculateAvgWaitingTime(List<FCFSInputProcess> input) {
    double avg = 0;
    for (int i = 0; i < input.length; i++) {
      avg += output
              .lastWhere(
                  (element) => element.processTitle == input[i].id.toString())
              .endTime
              .toDouble() -
          input[i].burstTime.toDouble() -
          input[i].arrivalTime.toDouble();
    }

    return avg / input.length;
  }
}
