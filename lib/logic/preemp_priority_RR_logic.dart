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

class PreemptivePriorityWRR {
  var avgWaitingTime;
  var timeQuantum;
  List<Process> output = [];

  PreemptivePriorityWRR(
      {List<PreemPriorityInputProcess> input, int timeQuantum}) {
    List<PreemPriorityInputProcess> victimList = [];
    input.forEach((element) {
      victimList.add(PreemPriorityInputProcess(
          arrivalTime: element.arrivalTime,
          burstTime: element.burstTime,
          priority: element.priority,
          id: element.id));
    });
    output = calculateOutput(victimList, timeQuantum);
    avgWaitingTime = calculateAvgWaitingTime(input);
  }

  List<Process> calculateOutput(
      List<PreemPriorityInputProcess> input, int timeQuantum) {
    List<Process> output = [];

//sort the array based on arrivalTime, if equal then based on id
    input.sort((a, b) => a.arrivalTime > b.arrivalTime
        ? 1
        : (a.arrivalTime == b.arrivalTime && a.id > b.id)
            ? 1
            : -1);

    int cpuTime = 0;

    while (input.length > 0) {
      int minArrival = input.map((p) => p.arrivalTime).toList().reduce(min);
      if (minArrival > cpuTime) {
        cpuTime = minArrival;
        output.add(Process(processTitle: "idle", endTime: cpuTime));
      }
      List<PreemPriorityInputProcess> minArrivalProcesses =
          input.where((p) => p.arrivalTime <= cpuTime).toList();
      int maxPriority = minArrivalProcesses
          .map((p) => p.priority)
          .toList()
          .reduce(min); //smallest num => max priority

      // finding out if there is a process with higher priority than the process at hands
      int interruptTime = -1;
      PreemPriorityInputProcess higherPriorityProcess = input.firstWhere(
          (p) => p.priority < maxPriority,
          orElse: () =>
              null); //it finds the process with least arrival time (bec. array is sorted)
      if (higherPriorityProcess != null) {
        interruptTime = higherPriorityProcess.arrivalTime;
      }

      //making 2 arrays: same priority array & arrived processes array
      List<PreemPriorityInputProcess> samePriorityArray =
          input.where((p) => p.priority == maxPriority).toList();
      List<PreemPriorityInputProcess> arrivedProcessesArray = [];
      if (samePriorityArray.length != 0) {
        PreemPriorityInputProcess dum = samePriorityArray
            .firstWhere((element) => element.arrivalTime <= cpuTime);
        arrivedProcessesArray.add(dum);
        samePriorityArray.remove(dum);
      }

      //applying the RR cycle keeping in mind the arrival of a higher priority process
      while (arrivedProcessesArray.length > 0) {
        PreemPriorityInputProcess process = arrivedProcessesArray[0];
        if (process.burstTime > timeQuantum) {
          if (interruptTime == -1 || cpuTime + timeQuantum <= interruptTime) {
            cpuTime += timeQuantum;
            output.add(
                Process(processTitle: process.id.toString(), endTime: cpuTime));
            process.burstTime -= timeQuantum;
          } else {
            int difference = interruptTime - cpuTime;
            cpuTime = interruptTime;
            output.add(
                Process(processTitle: process.id.toString(), endTime: cpuTime));
            process.burstTime -= difference;
          }
        } else {
          if (interruptTime == -1 ||
              cpuTime + process.burstTime <= interruptTime) {
            cpuTime += process.burstTime;
            output.add(
                Process(processTitle: process.id.toString(), endTime: cpuTime));
            process.burstTime = 0;
          } else {
            int difference = interruptTime - cpuTime;
            cpuTime = interruptTime;
            output.add(
                Process(processTitle: process.id.toString(), endTime: cpuTime));
            process.burstTime -= difference;
          }
        }

        //checking if another process from the processes with the same priority has arrived during the last RR cycle
        if (samePriorityArray.length != 0) {
          PreemPriorityInputProcess dum = samePriorityArray.firstWhere(
              (element) => element.arrivalTime <= cpuTime,
              orElse: () => null);

          if (dum != null) {
            arrivedProcessesArray.add(dum);
            samePriorityArray.remove(dum);
          }
        }

        //removing the process from the "arrived processes" array and input array if it has finished its burst time
        if (process.burstTime == 0) {
          int index =
              arrivedProcessesArray.indexWhere((p) => p.id == process.id);
          arrivedProcessesArray.removeAt(index);
          index = input.indexWhere((p) => p.id == process.id);
          input.removeAt(index);
        } else {
          arrivedProcessesArray.removeAt(0); //remove 1st process
          arrivedProcessesArray.add(process); //add it to the back
        }

        if (cpuTime == interruptTime) break;
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
