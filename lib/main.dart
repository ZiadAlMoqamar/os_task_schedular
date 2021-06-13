import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gantt_chart/screens/InputScreen/Input_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OS_task_scheduler',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  String technique = '';
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String changeTechnique(String techneque) {
    setState(() {
      widget.technique = techneque;
    });
  }

  bool rightShift = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: InputScreen(technique: widget.technique, change: changeTechnique),
    );
  }
}
