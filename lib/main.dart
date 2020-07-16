import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_part/second_flutter.dart';

void main() => runApp(_widgetForRoute());

Widget _widgetForRoute() {
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Flutter页面'),
      ),
      body: ContentWidget(),
    ),
  );
}

class ContentWidget extends StatefulWidget {
  @override
  _ContentWidgetState createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  static const nativeChannel =
      const MethodChannel('com.example.flutter/native');
  static const flutterChannel =
      const MethodChannel('com.example.flutter/flutter');

  String message, route;

  void onDataChanged(val) {
    setState(() {
      message = val;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    message = "";
    route = "";

    Future<dynamic> handler(MethodCall call) async {
      switch (call.method) {
        case 'onActivityResult':
          onDataChanged(call.arguments['message']);
          print('1234' + call.arguments['message']);
          break;
        case 'backAction':
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          } else {
            nativeChannel.invokeMethod('backAction');
          }
          break;
      }
    }

    flutterChannel.setMethodCallHandler(handler);
  }

  @override
  Widget build(BuildContext context) {
    print("123");
    return Center(
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            top: 100,
            right: 0,
            height: 100,
            child: Text(
              message,
              style: TextStyle(color: Colors.amber),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            top: 200,
            left: 100,
            right: 100,
            height: 100,
            child: RaisedButton(
                child: Text('打开上一个原生页面'),
                onPressed: () {
                  returnLastNativePage(nativeChannel);
                }),
          ),
          Positioned(
            top: 330,
            left: 100,
            right: 100,
            height: 100,
            child: RaisedButton(
                child: Text('打开下一个原生页面'),
                onPressed: () {
                  openNextNativePage(nativeChannel);
                }),
          ),
          Positioned(
            top: 460,
            left: 100,
            right: 100,
            height: 100,
            child: RaisedButton(
                child: Text('打开下一个Flutter页面'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecondFlutterWidget(),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}

Future<String> returnLastNativePage(MethodChannel channel) async {
  Map<String, dynamic> para = {'message': '嗨，本文案来自Flutter页面，回到第一个原生页面将看到我'};
  final String result = await channel.invokeMethod('backFirstNative', para);
  print('这是在flutter打印的$result');
  return result;
}

Future<dynamic> openNextNativePage(MethodChannel channel) async {
  Map<String, dynamic> para = {'message': '嗨，本文案来自Flutter页面，打开第二个原生页面将看到我'};
  final String result = await channel.invokeMethod('openSecondNative', para);
  print('这是在flutter中打印的' + result);
  return result;
}
