import 'dart:core';

import 'package:gantt_chart/classes/process.dart';
import 'dart:math';

class SRTFInputProcess {
  int id;
  int burstTime;
  int arrivalTime;
  SRTFInputProcess({this.id = 0, this.burstTime = 0, this.arrivalTime});
}

class SRTF {
  var avgWaitingTime;
  List<Process> output = [];

  SRTF(List<SRTFInputProcess> input) {
    List<SRTFInputProcess> victimInput = [];
    input.forEach((element) {
      victimInput.add(SRTFInputProcess(
          arrivalTime: element.arrivalTime,
          burstTime: element.burstTime,
          id: element.id));
    });
    output = calculateOutput(victimInput);
    avgWaitingTime = calculateAvgWaitingTime(input);
  }

  List<Process> calculateOutput(List<SRTFInputProcess> dummyInput) {
    List<Process> output = [];

    int cpuTime = 0;

    while (dummyInput.length > 0) {
      int minArrival = dummyInput.map((p) => p.arrivalTime).reduce(min);
      if (minArrival > cpuTime) {
        cpuTime = minArrival;
        output.add(Process(processTitle: "idle", endTime: cpuTime));
      }

      List<SRTFInputProcess> minArrivalProcesses =
          dummyInput.where((p) => p.arrivalTime <= cpuTime).toList();
      int minBurst =
          minArrivalProcesses.map((p) => p.burstTime).toList().reduce(min);
      SRTFInputProcess process =
          minArrivalProcesses.firstWhere((p) => p.burstTime <= minBurst);

      int interruptTime = -1;
      List<SRTFInputProcess> lowerBurstProcesses =
          dummyInput.where((p) => p.burstTime < process.burstTime).toList();
      if (lowerBurstProcesses.length > 0) {
        int minArrival2 =
            lowerBurstProcesses.map((p) => p.arrivalTime).reduce(min);
        SRTFInputProcess earliestProcess =
            lowerBurstProcesses.firstWhere((p) => p.arrivalTime == minArrival2);
        interruptTime = earliestProcess.arrivalTime;
      }

      if (interruptTime == -1 || cpuTime + process.burstTime <= interruptTime) {
        cpuTime += process.burstTime;
        output.add(
            Process(processTitle: process.id.toString(), endTime: cpuTime));
        int index = dummyInput.indexWhere((p) => p.id == process.id);
        dummyInput.removeAt(index);
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

  double calculateAvgWaitingTime(List<SRTFInputProcess> input) {
    double avg = 0;
    for (int i = 0; i < input.length; i++) {
      int endTime = output
          .lastWhere(
              (element) => element.processTitle == input[i].id.toString())
          .endTime;
      int burstTime = input[i].burstTime;
      int arrivalTime = input[i].arrivalTime;
      avg += endTime - burstTime - arrivalTime;
    }

    return avg / input.length;
  }
}
