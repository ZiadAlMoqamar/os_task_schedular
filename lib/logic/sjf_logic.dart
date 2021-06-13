//This is a non-preemptive SJF logic

import 'dart:core';

import 'package:gantt_chart/classes/process.dart';
import 'dart:math';

class SJFInputProcess {
  int id;
  int burstTime;
  int arrivalTime;
  SJFInputProcess({this.id = 0, this.burstTime = 0, this.arrivalTime});
}

class SJF {
  var avgWaitingTime;
  List<Process> output = [];

  SJF(List<SJFInputProcess> input) {
    List<SJFInputProcess> victimInput = [];
    input.forEach((element) {
      victimInput.add(SJFInputProcess(
          arrivalTime: element.arrivalTime,
          burstTime: element.burstTime,
          id: element.id));
    });
    output = calculateOutput(victimInput);
    avgWaitingTime = calculateAvgWaitingTime(input);
  }

  List<Process> calculateOutput(List<SJFInputProcess> input) {
    List<Process> output = [];
    int cpuTime = 0;

    while (input.length > 0) {
      int minArrival = input.map((p) => p.arrivalTime).toList().reduce(min);
      if (minArrival > cpuTime) {
        cpuTime = minArrival;
        output.add(Process(processTitle: "idle", endTime: cpuTime));
      }

      List<SJFInputProcess> minArrivalProcesses =
          input.where((p) => p.arrivalTime <= cpuTime).toList();
      int minBurst =
          minArrivalProcesses.map((p) => p.burstTime).toList().reduce(min);
      SJFInputProcess process =
          minArrivalProcesses.firstWhere((p) => p.burstTime <= minBurst);

      cpuTime += process.burstTime;
      output
          .add(Process(processTitle: process.id.toString(), endTime: cpuTime));
      int index = input.indexWhere((p) => p.id == process.id);
      input.removeAt(index);
    }

    return output;
  }

  double calculateAvgWaitingTime(List<SJFInputProcess> input) {
    double avg = 0;
    for (int i = 0; i < input.length; i++) {
      avg += output
              .lastWhere(
                  (element) => element.processTitle == input[i].id.toString())
              .endTime -
          input[i].burstTime -
          input[i].arrivalTime;
    }
    return avg / input.length;
  }
}
