import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gantt_chart/screens/InputScreen/Input_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'gantt_chart',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      // appBar: AppBar(
      //   title: Text('gantt_chart'),
      // ),
      body: SingleChildScrollView(
        // scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          // scrollDirection: Axis.vertical,
          child: Scrollbar(
            child: InputScreen(
                technique: widget.technique, change: changeTechnique),
          ),
        ),
      ),
    );
  }
}
