import 'dart:core';

class InputProcess {
  int id;
  int burstTime;
  double waitingTime;
  InputProcess({this.id = 0, this.burstTime = 0, this.waitingTime = 0});
}

class FCFS {
  var avgWaitingTime;
  List<InputProcess> input = [];
  List<InputProcess> output = [];

  FCFS(List<InputProcess> input) {
    output = prepareOutput(input);
    avgWaitingTime = calculateAvgWaitingTime(output);
  }
  List<InputProcess> enterInput(List<int> input) {
    List<InputProcess> output = [];
    for (var i = 0; i < input.length; i++) {
      output.add(InputProcess(burstTime: input[i]));
    }
    return output;
  }

  List<InputProcess> prepareOutput(List<InputProcess> input) {
    List<InputProcess> output = [];
    for (var i = 0; i < input.length; i++) {
      output.add(InputProcess(
          id: i,
          burstTime: input[i].burstTime,
          waitingTime: calculateProcessWaitingTime(input, i)));
      print(output[i].waitingTime);
    }
    return output;
  }

  double calculateProcessWaitingTime(
      List<InputProcess> input, int processIndex) {
    var output = 0.0;
    if (processIndex != 0) {
      for (var i = processIndex - 1; i > 0; i--) {
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
