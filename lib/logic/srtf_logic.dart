//This is preemptive SJF logic

import 'dart:core';

class InputProcess {
  int id;
  int burstTime;
  int arrivalTime;
  InputProcess({
    this.id = 0,
    this.burstTime = 0,
    this.arrivalTime = 0,
  });
}

class AvgOutputProcess {
  double waitingTime;
  int id;
  int completionTime;
  int turnAroundTime;
  int arrivalTime;
  int burstTime;
  AvgOutputProcess(
      {this.id = 0,
      this.arrivalTime = 0,
      this.burstTime = 0,
      this.completionTime = 0,
      this.turnAroundTime = 0});
}

class OutputProcess {
  int id;
  int endBurstTime;
  double waitingTime;
  OutputProcess({this.id = 0, this.endBurstTime = 0, this.waitingTime = 0});
}

class SRTF {
  var avgWaitingTime;
  List<InputProcess> input = [];
  List<OutputProcess> output = [];
  List<AvgOutputProcess> avgOutput = [];

  SRTF(List<InputProcess> input) {
    input.forEach((element) {
      avgOutput.add(AvgOutputProcess(
          id: element.id,
          arrivalTime: element.arrivalTime,
          burstTime: element.burstTime));
    });
    output = prepareOutput(input);
    avgOutput = prepareAvgOutputList(output, avgOutput);
    avgWaitingTime = calculateAvgWaitingTime(avgOutput);
  }

  List<OutputProcess> prepareOutput(List<InputProcess> input) {
    List<OutputProcess> output = [];
    //sort input according to arrival time
    input.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
    var burstTimeList = [];
    input.forEach((element) {
      burstTimeList.add(element.burstTime);
    });

    var minArrivalTime = input.first.arrivalTime;
    var currentTime = 0;
    var currentPid = -1;
    int currentIndex;
    //used to incremant on process endtime
    var lastEndTime = 0;
    //to stop the while loop after reaching max arrivaltime and applying simple SJF
    var maxArrivalTime = input.last.arrivalTime;
    //counter for the running process burst time finished
    //used for calculating endtime
    var currentFinishedBurst = 0;

    while (currentTime <= maxArrivalTime) {
      //=-1 to avoid the second if scope
      int nextIndex = -1;

      //used to find next process to compare its remaining burst time
      nextIndex = minBurstProcessIndex(input, currentTime);
      input.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
      //for idle state
      if (nextIndex == -1 && currentFinishedBurst == 0) {
        for (int m = 0; m < input.length; m++) {
          int mBurstTime = input[m].burstTime;
          int mArrivalTime = input[m].arrivalTime;
          if ((mBurstTime != 0) && (mArrivalTime > currentTime)) {
            output.add(OutputProcess(id: -1, endBurstTime: mArrivalTime));
            currentTime = mArrivalTime;
            lastEndTime = mArrivalTime;
            currentFinishedBurst = 0;
            nextIndex = minBurstProcessIndex(input, currentTime);
            currentIndex = nextIndex;
            currentPid = input[currentIndex].id;
            break;
          }
        }
      }
      //this scope used for the first iteration
      if (currentTime == minArrivalTime) {
        currentPid = input[nextIndex].id;

        currentIndex = nextIndex;
        currentFinishedBurst = 0;
      }
      //this scope used for the rest of iterations
      else if (currentPid != 0 && nextIndex != -1) {
        //if the currentIndexed process was not the shortest remaining job
        if (input[currentIndex].burstTime > input[nextIndex].burstTime) {
          //adding outputProcess
          output.add(OutputProcess(id: currentPid, endBurstTime: currentTime));
          burstTimeList[currentIndex] -= currentFinishedBurst;
          lastEndTime = currentTime;
          currentPid = input[nextIndex].id;

          currentIndex = nextIndex;
          currentFinishedBurst = 0;
        }
      } else if (currentPid == -1 && currentIndex == null) {
        output.add(OutputProcess(id: currentPid, endBurstTime: minArrivalTime));
        currentTime = minArrivalTime;
        lastEndTime = minArrivalTime;
        currentFinishedBurst = 0;
      }
      //this scope to stop iterating on finished process
      bool finished = false;
      if (currentIndex != null && input[currentIndex].burstTime <= 0) {
        var x = minBurstProcessIndexLessthanCurrentTime(input, currentTime);

        lastEndTime += currentFinishedBurst;
        //workaround for the 0 currentFinishedBurst
        if (currentFinishedBurst == 0) {
          lastEndTime++;
        }
        output.add(OutputProcess(id: currentPid, endBurstTime: lastEndTime));
        burstTimeList[currentIndex] -= currentFinishedBurst;
        finished = true;

        if (x != -1) {
          currentPid = input[x].id;

          currentIndex = x;
          currentFinishedBurst = 0;
          finished = false;
        }
        currentFinishedBurst = 0;
      }

      if (currentPid != -1 && finished == false) {
        currentFinishedBurst++;
        input[currentIndex].burstTime--;
        currentTime++;
      }
    }
    //after reachimg maxArrivalTime

    //if the current process is the shortest remainig job of all the rest
    if (currentPid == minBurstProcessid(input)) {
      lastEndTime = currentTime + input[currentIndex].burstTime;

      output.add(OutputProcess(id: currentPid, endBurstTime: lastEndTime));

      //remove finished jobs from input
      input.remove(input[currentIndex]);
    }
    //calculating the remainig burst time for the remaining jobs
    else {
      int finishedBurst =
          burstTimeList[currentIndex] - input[currentIndex].burstTime;
      lastEndTime += finishedBurst;
      output.add(OutputProcess(id: currentPid, endBurstTime: lastEndTime));

      var removalIndex = input.indexWhere((element) => element.burstTime <= 0);
      input.remove(input[removalIndex]);
    }
    //removing all zero burst time jobs
    for (int i = 0; i < input.length; i++) {
      if (input[i].burstTime <= 0) {
        input.remove(input[i]);
        i = -1;
      }
    }

    //sorting the remaining jobs according to burst time as simple SJF
    input.sort((a, b) => a.burstTime.compareTo(b.burstTime));
    for (var i = 0; i < input.length; i++) {
      output.add(OutputProcess(
          id: input[i].id, endBurstTime: lastEndTime + input[i].burstTime));

      lastEndTime = lastEndTime + input[i].burstTime;
    }
    return output;
  }

  int minBurstProcessid(List<InputProcess> input) {
    var x;
    input.sort((a, b) => a.burstTime.compareTo(b.burstTime));
    for (var i = 0; i < input.length; i++) {
      if (input[i].burstTime != 0) {
        x = input[i].id;
        break;
      }
    }
    input.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
    return x;
  }

  int minBurstProcessIndex(List<InputProcess> input, int currentTime) {
    var index = -1;
    var pid;
    input.sort((a, b) => a.burstTime.compareTo(b.burstTime));
    for (int i = 0; i < input.length; i++) {
      if (input[i].arrivalTime == currentTime) {
        pid = input[i].id;

        input.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));

        index = input.indexWhere((element) => element.id == pid);

        break;
      }
    }
    return index;
  }

  //get process still have burst with arrival time less than current time
  int minBurstProcessIndexLessthanCurrentTime(
      List<InputProcess> input, int currentTime) {
    var index = -1;
    var pid;
    input.sort((a, b) => a.burstTime.compareTo(b.burstTime));
    for (int i = 0; i < input.length; i++) {
      if (input[i].arrivalTime <= currentTime && input[i].burstTime > 0) {
        pid = input[i].id;

        input.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
        //search for index of pid in a sorted to arrival time input
        index = input.indexWhere((element) => element.id == pid);

        break;
      }
    }
    return index;
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
      input2[i].turnAroundTime =
          input2[i].completionTime - input2[i].arrivalTime;
      input2[i].waitingTime =
          (input2[i].turnAroundTime - input2[i].burstTime).toDouble();
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

//تم بحمد الله
