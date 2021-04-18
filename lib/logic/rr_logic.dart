//This is a round robin logic

import 'dart:core';

class InputProcess {
  int id;
  int burstTime;
  InputProcess({
    this.id = 0,
    this.burstTime = 0,
  });
}
class OutputProcess {
  int id;
  int endBurstTime;
  double waitingTime;
  OutputProcess({this.id = 0, this.endBurstTime = 0, this.waitingTime = 0});
}
class RR {
  var avgWaitingTime;
  var timeQuantum;
  List<InputProcess> input = [];
  List<OutputProcess> output = [];

  RR(List<InputProcess> input, int timeQuantum){
    output= prepareOutput(input, timeQuantum);
  }

  List<OutputProcess> prepareOutput(List<InputProcess> input, int timeQuantum ){
    List<OutputProcess> output = [];
    var burstTimeSum = 0;
    int currentTime = 0;
    int lastBurstTime = 0;
    input.forEach((element) {burstTimeSum += element.burstTime; });

    while(currentTime < burstTimeSum){
      // input.forEach((element) {
      //   if(element.burstTime>=timeQuantum){
      //     output.add(OutputProcess(id: element.id, endBurstTime: lastBurstTime+timeQuantum));
      //     lastBurstTime += lastBurstTime + timeQuantum;
      //     element.burstTime -= timeQuantum;
      //     currentTime += timeQuantum;
      //   }
      //   else{
      //     output.add(OutputProcess(id: element.id, endBurstTime: lastBurstTime+element.burstTime));
      //     lastBurstTime += lastBurstTime + element.burstTime;
      //     currentTime += element.burstTime;
      //     element.burstTime=0;
      //   }
      //  });
      for(int i=0; i<input.length; i++){
        if(input[i].burstTime>=timeQuantum){
          output.add(OutputProcess(id: input[i].id, endBurstTime: lastBurstTime+timeQuantum));
          lastBurstTime += timeQuantum;
          input[i].burstTime -= timeQuantum;
          currentTime += timeQuantum;
        }
        else if(input[i].burstTime!=0){
          output.add(OutputProcess(id: input[i].id, endBurstTime: lastBurstTime+input[i].burstTime));
          lastBurstTime += input[i].burstTime;
          currentTime += input[i].burstTime;
          input[i].burstTime=0;
        }
      
      
    }
    // input.removeWhere((element) => element.burstTime==0);
  }
  return output;
}
}