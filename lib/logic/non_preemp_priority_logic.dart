//This is a non-preemptive Priority logic

import 'dart:core';

import 'package:gantt_chart/classes/process.dart';
import 'dart:math';

class NonPremPriorityInputProcess {
  int id;
  int burstTime;
  int priority;
  int arrivalTime;
  NonPremPriorityInputProcess(
      {this.id, this.burstTime, this.priority, this.arrivalTime});
}

class NonPreemptivePriority {
  var avgWaitingTime;
  List<Process> output = [];
  NonPreemptivePriority(List<NonPremPriorityInputProcess> input) {
    List<NonPremPriorityInputProcess> victimInput = [];
    input.forEach((element) {
      victimInput.add(NonPremPriorityInputProcess(
          arrivalTime: element.arrivalTime,
          burstTime: element.burstTime,
          priority: element.priority,
          id: element.id));
    });
    output = calculateOutput(victimInput);
    avgWaitingTime = calculateAvgWaitingTime(input);
  }

  List<Process> calculateOutput(List<NonPremPriorityInputProcess> input) {
    List<Process> output = [];

    int cpuTime = 0;
    while (input.length > 0) {
      // getting minimum arrival time
      int minArrival = input.map((p) => p.arrivalTime).toList().reduce(min);
      // if minimum arrival time is more than the current cpu time => draw idle time
      if (minArrival > cpuTime) {
        cpuTime = minArrival;
        output.add(Process(processTitle: "idle", endTime: cpuTime));
      }
      // get all processes having the same arrival time
      // for the scenario where there are multiple processes having the same arrival time
      List<NonPremPriorityInputProcess> minArrivalProcesses =
          input.where((p) => p.arrivalTime <= cpuTime).toList();

      // get the maximum priority process from those processes
      int maxPriority = minArrivalProcesses
          .map((p) => p.priority)
          .toList()
          .reduce(min); //smallest num => max priority
      NonPremPriorityInputProcess chosenProcess =
          minArrivalProcesses.firstWhere((p) => p.priority == maxPriority);
      // set the cpu time (its value after the process had been finished)
      cpuTime += chosenProcess.burstTime;
      output.add(
          Process(processTitle: chosenProcess.id.toString(), endTime: cpuTime));
      // removing the process from the input array
      int processIndex = input.indexWhere((p) => p.id == chosenProcess.id);
      input.removeAt(processIndex);
    }

    return output;
  }

  double calculateAvgWaitingTime(List<NonPremPriorityInputProcess> input) {
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
