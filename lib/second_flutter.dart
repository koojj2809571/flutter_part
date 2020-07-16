import 'package:flutter/material.dart';

class SecondFlutterWidget extends StatefulWidget {
  @override
  _SecondFlutterState createState() => _SecondFlutterState();
}

class _SecondFlutterState extends State<SecondFlutterWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter页面"),
      ),
      body: Center(
        child: Text('第二个Flutter页面'),
      ),
    );
  }
}
