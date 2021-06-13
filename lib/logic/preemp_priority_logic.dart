//This is a preemptive Priority logic

import 'dart:core';

import 'package:gantt_chart/classes/process.dart';
import 'dart:math';

class PreemPriorityInputProcess {
  int id;
  int burstTime;
  int priority;
  int arrivalTime;
  PreemPriorityInputProcess(
      {this.id = 0, this.burstTime = 0, this.priority = 0, this.arrivalTime});
}

class PreemptivePriority {
  var avgWaitingTime;
  List<Process> output = [];

  PreemptivePriority({List<PreemPriorityInputProcess> input}) {
    List<PreemPriorityInputProcess> victimList = [];
    input.forEach((element) {
      victimList.add(PreemPriorityInputProcess(
          arrivalTime: element.arrivalTime,
          burstTime: element.burstTime,
          priority: element.priority,
          id: element.id));
    });
    output = calculateOutput(victimList);
    avgWaitingTime = calculateAvgWaitingTime(input);
  }

  List<Process> calculateOutput(List<PreemPriorityInputProcess> input) {
    List<Process> output = [];

    int cpuTime = 0;

    while (input.length > 0) {
      int minArrival = input.map((p) => p.arrivalTime).toList().reduce(min);
      if (minArrival > cpuTime) {
        cpuTime = minArrival;
        output.add(Process(processTitle: "idle", endTime: cpuTime));
      }

      List<PreemPriorityInputProcess> minArrivalProcesses =
          input.where((p) => p.arrivalTime <= cpuTime).toList();
      int highestPriority = minArrivalProcesses
          .map((p) => p.priority)
          .toList()
          .reduce(min); //lowest num => highest priority
      PreemPriorityInputProcess process =
          minArrivalProcesses.firstWhere((p) => p.priority == highestPriority);

      // finding processes with higher priority
      // then finding the earlies process among them
      int interruptTime = -1;
      List<PreemPriorityInputProcess> higherPriorityProcesses =
          input.where((p) => p.priority < process.priority).toList();
      if (higherPriorityProcesses.length > 0) {
        int minArrival2 = higherPriorityProcesses
            .map((p) => p.arrivalTime)
            .toList()
            .reduce(min);
        PreemPriorityInputProcess earliestProcess = higherPriorityProcesses
            .firstWhere((p) => p.arrivalTime == minArrival2);
        interruptTime = earliestProcess.arrivalTime;
      }

      if (interruptTime == -1 || cpuTime + process.burstTime <= interruptTime) {
        cpuTime += process.burstTime;
        output.add(
            Process(processTitle: process.id.toString(), endTime: cpuTime));
        int index = input.indexWhere((p) => p.id == process.id);
        input.removeAt(index);
      } else {
        int elapsedTime = interruptTime - cpuTime;
        cpuTime = interruptTime;
        output.add(
            Process(processTitle: process.id.toString(), endTime: cpuTime));
        process.burstTime -= elapsedTime;
      }
    }

    return output;
  }

  double calculateAvgWaitingTime(List<PreemPriorityInputProcess> input) {
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
