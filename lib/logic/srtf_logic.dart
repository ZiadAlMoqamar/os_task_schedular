//this is preemptive SJF

import 'dart:core';

import 'package:gantt_chart/logic/fcfs_logic.dart';

class InputProcess {
  int id;
  int burstTime;
  int arrivalTime;
  double waitingTime;
  InputProcess(
      {this.id = 0,
      this.burstTime = 0,
      this.arrivalTime = 0,
      this.waitingTime = 0});
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

  SRTF(List<InputProcess> input) {
    output = prepareOutput(input);
  }

  List<OutputProcess> prepareOutput(List<InputProcess> input) {
    List<OutputProcess> output = [];
    //sort input according to arrival time
    input.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
    var burstTimeList = [];
    input.forEach((element) {
      burstTimeList.add(element.burstTime);
    });
    // var originalInput = input;
    var minArrivalTime = input.first.arrivalTime;
    var currentTime = minArrivalTime;
    var currentPid = 0;
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
      //maybe useless but sort in obj passes by ref. !!
      var funcInput = input;
      //used to find next process to compare its remaining burst time
      nextIndex = minBurstProcessIndex(funcInput, currentTime);
      input.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
      //this scope used for the first iteration
      if (currentTime == minArrivalTime) {
        currentPid = input[nextIndex].id;
        // print(
        //     "current index $currentIndex will change to nextIndex $nextIndex");
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
          // print("current index $currentIndex of pid ${input[currentIndex].id}");
          // print("current index $currentIndex & pid of 0 ${input[0].id}");
          // print("currentime " + currentTime.toString());
          // print("pid added " + currentPid.toString());
          // print(
          //     "zz currentFinishedBurst =$currentFinishedBurst of pid $currentPid");
          lastEndTime = currentTime;
          currentPid = input[nextIndex].id;
          // print(
          //     "current index $currentIndex will change to nextIndex $nextIndex");
          currentIndex = nextIndex;
          currentFinishedBurst = 0;
        }
      }
      // print("current time =$currentTime will be incremented now");
      // print(
      //     "burst time of current index $currentIndex will be decremented now of pid ${input[currentIndex].id}");
      // print(
      //     "xx currentFinishedBurst =$currentFinishedBurst of pid $currentPid");
      //this scope to stop iterating on finished process
      if (input[currentIndex].burstTime <= 0) {
        // print("xx input[currentindx].burst =${input[currentIndex].burstTime} of pid $currentPid");
        var x = minBurstProcessIndexLessthanCurrentTime(input, currentTime);
        //print( "zz currentFinishedBurst =$currentFinishedBurst of pid $currentPid");
        lastEndTime += currentFinishedBurst;
        //workaround for the 0 currentFinishedBurst
        if (currentFinishedBurst == 0) {
          lastEndTime++;
        }
        output.add(OutputProcess(id: currentPid, endBurstTime: lastEndTime));
        burstTimeList[currentIndex] -= currentFinishedBurst;
        // print("hoho pid added $currentPid");

        currentPid = input[x].id;
        //print("hoho current index will be changed from $currentIndex to $x");
        currentIndex = x;
        currentFinishedBurst = 0;
      }
      //print( "yy before decrement input[currentindx].burst =${input[currentIndex].burstTime} of pid $currentPid");
      currentFinishedBurst++;
      input[currentIndex].burstTime--;
      currentTime++;
    }
    //after reachimg maxArrivalTime

    //if the current process is the shortest remainig job of all the rest
    if (currentPid == minBurstProcessid(input)) {
      //print("ana aho bursttime ${input[currentIndex].burstTime}");

      lastEndTime = currentTime + input[currentIndex].burstTime;
      // lastEndTime+= input[currentIndex].burstTime;
      output.add(OutputProcess(id: currentPid, endBurstTime: lastEndTime));
      //print("ana aho pid added $currentPid");
      //print("ana aho lastEndTime $lastEndTime");

      //remove finished jobs from input
      input.remove(input[currentIndex]);
    }
    //calculating the remainig burst time for the remaining jobs
    else {
      //var burstTimeList=[7,5,2,1,2,1];
      // int finishedBurst =
      //     originalInput[currentIndex].burstTime - input[currentIndex].burstTime;
      int finishedBurst =
          burstTimeList[currentIndex] - input[currentIndex].burstTime;
      lastEndTime += finishedBurst;
      output.add(OutputProcess(id: currentPid, endBurstTime: lastEndTime));
      //print("while loop exit added pid is $currentPid");
      var removalIndex = input.indexWhere((element) => element.burstTime <= 0);
      input.remove(input[removalIndex]);
    }
    //removing all zero burst time jobs
    for (int i = 0; i < input.length; i++) {
      if (input[i].burstTime <= 0) {
        input.remove(input[i]);
      }
    }
    //print("lastend " + lastEndTime.toString());
    //print("sjf currentime " + currentTime.toString());
    //sorting the remaining jobs according to burst time as simple SJF
    input.sort((a, b) => a.burstTime.compareTo(b.burstTime));
    for (var i = 0; i < input.length; i++) {
      //print("pid = ${input[i].id} with bursttime = ${input[i].burstTime}");
      //print("ahaaa lastEndTime = $lastEndTime");
      output.add(OutputProcess(
          id: input[i].id, endBurstTime: lastEndTime + input[i].burstTime));
      //print("pid added ${input[i].id}");
      lastEndTime = lastEndTime + input[i].burstTime;
    }
    return output;
  }

  int minBurstProcessid(List<InputProcess> input) {
    //print("hi minBurstProcessid is used");
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
        //print("at currenttime $currentTime minBurst pid is " + input[i].id.toString());
        input.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
        //search for index of pid in a sorted to arrival time input
        index = input.indexWhere((element) => element.id == pid);
        //print("right index is $index");
        //print("minBurstpid after search ${input[index].id}");
        break;
      }
    }
    return index;
  }

  int minBurstProcessIndexLessthanCurrentTime(
      List<InputProcess> input, int currentTime) {
    var index = -1;
    var pid;
    input.sort((a, b) => a.burstTime.compareTo(b.burstTime));
    for (int i = 0; i < input.length; i++) {
      if (input[i].arrivalTime <= currentTime && input[i].burstTime > 0) {
        pid = input[i].id;
        //print("at currenttime $currentTime minBurst pid is " + input[i].id.toString());
        input.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
        //search for index of pid in a sorted to arrival time input
        index = input.indexWhere((element) => element.id == pid);
        //print("right index is $index");
        //print("minBurstpid after search ${input[index].id}");
        break;
      }
    }
    return index;
  }
}

//تم بحمد الله
