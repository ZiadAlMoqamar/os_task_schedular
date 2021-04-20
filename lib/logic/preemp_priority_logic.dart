//This is a preemptive Priority logic

import 'dart:core';

class InputProcess {
  int id;
  int burstTime;
  int priority;
  int endBurstTime;
  double waitingTime;
  InputProcess(
      {this.id = 0,
      this.burstTime = 0,
      this.endBurstTime = 0,
      this.priority = 0,
      this.waitingTime = 0});
}

class OutputProcess {
  int id;
  int endBurstTime;
  double waitingTime;
  OutputProcess({this.id = 0, this.endBurstTime = 0, this.waitingTime = 0});
}

class AvgOutputProcess {
  double waitingTime;
  int id;
  int completionTime;
  int burstTime;
  AvgOutputProcess({
    this.id = 0,
    this.burstTime = 0,
    this.completionTime = 0,
  });
}

class PreemptivePriority {
  var avgWaitingTime;
  var timeQuantum;
  List<InputProcess> input = [];
  List<OutputProcess> output = [];
  List<AvgOutputProcess> avgOutput = [];

  PreemptivePriority({List<InputProcess> input, int timeQuantum}) {
    input.forEach((element) {
      avgOutput
          .add(AvgOutputProcess(id: element.id, burstTime: element.burstTime));
    });
    output = prepareOutput(input, timeQuantum);
    avgOutput = prepareAvgOutputList(output, avgOutput);
    avgWaitingTime = calculateAvgWaitingTime(avgOutput);
  }

  List<OutputProcess> prepareOutput(List<InputProcess> input, int timeQuantum) {
    List<OutputProcess> output = [];

    int currentTime = 0;
    int lastBurstTime = 0;
    input.sort((a, b) => a.priority.compareTo(b.priority));
    for (int i = 0; i < input.length; i++) {
      if (input[i].burstTime != 0) {
        if (i != input.length - 1 &&
                input[i].priority != input[i + 1].priority ||
            i == input.length - 1) {
          output.add(OutputProcess(
              id: input[i].id,
              endBurstTime: lastBurstTime + input[i].burstTime));
          currentTime += input[i].burstTime;
          lastBurstTime += input[i].burstTime;
          input[i].burstTime = 0;
        } else {
          List<InputProcess> roundRobinList = [];
          roundRobinList.add(input[i]);
          if (i != input.length - 1) {
            for (int j = i + 1; j < input.length; j++) {
              if (input[j].priority == input[i].priority) {
                roundRobinList.add(input[j]);
              }
            }

            var burstTimeSum = currentTime;
            roundRobinList.forEach((element) {
              burstTimeSum += element.burstTime;
            });
            while (currentTime < burstTimeSum) {
              for (int k = 0; k < roundRobinList.length; k++) {
                if (roundRobinList[k].burstTime >= timeQuantum) {
                  output.add(OutputProcess(
                      id: roundRobinList[k].id,
                      endBurstTime: lastBurstTime + timeQuantum));
                  lastBurstTime += timeQuantum;
                  input[k + i].burstTime -= timeQuantum;
                  
                  currentTime += timeQuantum;
                } else if (roundRobinList[k].burstTime != 0) {
                  output.add(OutputProcess(
                      id: roundRobinList[k].id,
                      endBurstTime:
                          lastBurstTime + roundRobinList[k].burstTime));
                  lastBurstTime += roundRobinList[k].burstTime;
                  currentTime += roundRobinList[k].burstTime;
                  input[k + i].burstTime = 0;
                  
                }
              }
            }
          }
        }
      }
    }
   
    return output;
  }

  List<AvgOutputProcess> prepareAvgOutputList(
      List<OutputProcess> input, List<AvgOutputProcess> input2) {
    input.sort((a, b) => a.endBurstTime.compareTo(b.endBurstTime));
    var inReverse = input.reversed;
    var reversed = inReverse.toList();

    for (var i = 0; i < input2.length; i++) {
      int index;
      index = reversed.indexWhere((element) => element.id == input2[i].id);
      input2[i].completionTime = reversed[index].endBurstTime;
      input2[i].waitingTime =
          (input2[i].completionTime - input2[i].burstTime).toDouble();
    }
    return input2;
  }

  double calculateAvgWaitingTime(List<AvgOutputProcess> input) {
    var sum = 0.0;
    for (var i = 0; i < input.length; i++) {
      sum = sum + input[i].waitingTime;
    }
    return sum / (input.length);
  }
}
