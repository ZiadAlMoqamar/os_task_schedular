//This is a round robin logic

import 'dart:core';

import 'package:gantt_chart/classes/process.dart';
import 'dart:math';

class RRInputProcess {
  int id;
  int burstTime;
  int arrivalTime;
  RRInputProcess({this.id = 0, this.burstTime = 0, this.arrivalTime});
}

class RR {
  double avgWaitingTime;
  List<Process> output = [];

  RR({List<RRInputProcess> input, int timeQuantum}) {
    List<RRInputProcess> victimInput = [];
    input.forEach((element) {
      victimInput.add(RRInputProcess(
          arrivalTime: element.arrivalTime,
          burstTime: element.burstTime,
          
          id: element.id));
    });
    output = calculateOutput(victimInput, timeQuantum);
    avgWaitingTime = calculateAvgWaitingTime(input);
  }

  List<Process> calculateOutput(List<RRInputProcess> input, int timeQuantum) {
    List<Process> output = [];
    //sort the array based on arrivalTime, if equal then based on id
    input.sort((a, b) => a.arrivalTime > b.arrivalTime
        ? 1
        : (a.arrivalTime == b.arrivalTime && a.id > b.id)
            ? 1
            : -1);

    int cpuTime = 0;

    while (input.length > 0) {
      int minArrival = (input.map((p) => p.arrivalTime)).toList().reduce(min);
      if (minArrival > cpuTime) {
        cpuTime = minArrival;
        output.add(Process(processTitle: 'idle', endTime: cpuTime));
      }
      List<RRInputProcess> activeProcessesArray =
          input.where((p) => p.arrivalTime <= cpuTime).toList();

      //applying the RR cycles
      while (activeProcessesArray.length != 0) {
        RRInputProcess process = activeProcessesArray[0];
        if (process.burstTime > timeQuantum) {
          cpuTime += timeQuantum;
          output.add(
              Process(processTitle: process.id.toString(), endTime: cpuTime));
          process.burstTime -= timeQuantum;
        } else {
          cpuTime += process.burstTime;
          output.add(
              Process(processTitle: process.id.toString(), endTime: cpuTime));
          process.burstTime = 0;
        }

        //checking if another process from the input processes has arrived during the last RR cycle
        input.forEach((p) {
          if (p.arrivalTime <= cpuTime && !activeProcessesArray.contains(p)) {
            activeProcessesArray.add(p);
          }
        });

        //removing the process from the "active processes" array and input array if it has finished its burst time
        if (process.burstTime == 0) {
          int index =
              activeProcessesArray.indexWhere((p) => p.id == process.id);
          activeProcessesArray.removeAt(index);
          index = input.indexWhere(((p) => p.id == process.id));
          input.removeAt(index);
        } else {
          activeProcessesArray.removeAt(0); //remove 1st process
          activeProcessesArray.add(process); //add it to the back
        }
      }
    }

//joining processes of the same id together (they are separated from RR cycles)
    for (int i = 0; i < output.length - 1; i++) {
      if (output[i].processTitle == output[i + 1].processTitle) {
        output.removeAt(i);
        i--;
      }
    }

    return output;
  }

  double calculateAvgWaitingTime(List<RRInputProcess> input) {
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
