//This is a non-preemptive SJF logic

import 'dart:core';

class InputProcess {
  int id;
  int burstTime;
  int endBurstTime;
  double waitingTime;
  InputProcess(
      {this.id = 0,
      this.burstTime = 0,
      this.endBurstTime = 0,
      this.waitingTime = 0});
}
class SJF {
  var avgWaitingTime;
  List<InputProcess> input = [];
  List<InputProcess> output = [];

  SJF(List<InputProcess> input) {
    output = prepareOutput(input);
    avgWaitingTime = calculateAvgWaitingTime(output);
  }

  List<InputProcess> prepareOutput(List<InputProcess> input) {
    input.sort((a, b) => a.burstTime.compareTo(b.burstTime));
    List<InputProcess> output = [];
    for (var i = 0; i < input.length; i++) {
      output.add(InputProcess(
          id: input[i].id,
          burstTime: input[i].burstTime,
          waitingTime: calculateProcessWaitingTime(input, i),
          endBurstTime: input[i].burstTime +
              calculateProcessWaitingTime(input, i).toInt()));
    }
    return output;
  }

  double calculateProcessWaitingTime(
      List<InputProcess> input, int processIndex) {
    var output = 0.0;
    if (processIndex != 0) {
      for (var i = processIndex - 1; i >= 0; i--) {
        output += input[i].burstTime;
      }
    }
    return output;
  }

  double calculateAvgWaitingTime(List<InputProcess> input) {
    var sum = 0.0;
    for (var i = 0; i < input.length; i++) {
      sum = sum + input[i].waitingTime;
    }
    return sum / (input.length);
  }
}
