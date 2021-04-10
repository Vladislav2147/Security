import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:core';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:sensors/sensors.dart';

import 'service/Entropy.dart';

class HashGenerator extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Hash',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Hash Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HashGeneratorPageState createState() => _HashGeneratorPageState();
}

class _HashGeneratorPageState extends State<MyHomePage> {

  final _textHexController = TextEditingController();
  final _textEntropyController = TextEditingController();

  final _textInputController = TextEditingController();
  int length = 0;
  Stopwatch stopwatch = new Stopwatch();
  List<int> times = [];

  @override
  void dispose() {
    _textInputController.dispose();
    _textEntropyController.dispose();
    _textHexController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _textInputController,
              onChanged: onTextChanged,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[a-z]")),
              ],
              maxLength: 33,
              style: TextStyle(fontSize: 22),
              decoration: InputDecoration(
                hintText: 'Enter your string',
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: ElevatedButton(
                      onPressed: onSubmit,
                      child: Text("Submit", style: TextStyle(fontSize: 22))
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: ElevatedButton(
                      onPressed: onRandom,
                      child: Text("Random", style: TextStyle(fontSize: 22))
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: ElevatedButton(
                      onPressed: reset,
                      child: Text("Reset", style: TextStyle(fontSize: 22))
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: ElevatedButton(
                      onPressed: accelerometer,
                      child: Text("Start Accelerometer Generator", style: TextStyle(fontSize: 22))
                  ),
                ),
              ],
            ),
            TextField(
              controller: _textHexController,
              style: TextStyle(fontSize: 22),
              maxLines: 5,
              enabled: false,
              decoration: InputDecoration(
                hintText: 'Hex String',
              ),
            ),
            TextField(
              controller: _textEntropyController,
              style: TextStyle(fontSize: 22),
              maxLines: 1,
              enabled: false,
              decoration: InputDecoration(
                hintText: 'Entropy String',
              ),
            ),
          ],
        ),
      )
    );
  }

  void onTextChanged(String value) {
    if (value.length == length + 1) {
      if (length > 0) {
        stopwatch.stop();
        times.add(stopwatch.elapsedMilliseconds);
      }
      stopwatch.reset();
      length++;
      stopwatch.start();
    }
  }

  void onSubmit() {

    String hex = hexStringFromIntList(times);
    _textHexController.text = hex;
    print(hex);

    double entrpy = entropy(times);
    _textEntropyController.text = entrpy.toString();
    print(entrpy);

    _textInputController.clear();
    length = 0;
    times.clear();
  }

  void onRandom() {
    List<int> random = getRandomList();
    String hex = hexStringFromIntList(random);
    _textHexController.text = hex;
    print(hex);

    double entrpy = entropy(random);
    _textEntropyController.text = entrpy.toString();
    print(entrpy);
  }

  void reset() {
    _textInputController.clear();
    _textEntropyController.clear();
    _textHexController.clear();
    length = 0;
    times.clear();
  }

  void accelerometer() {
    List<AccelerometerEvent> events = [];
    Stopwatch accelerometerTimer = new Stopwatch();
    accelerometerTimer.start();
    StreamSubscription<AccelerometerEvent> subscription;
    subscription = accelerometerEvents.listen((AccelerometerEvent current) {
      if (events.length == 32) {
        subscription.cancel();
        var normalizedList = events.map((e) => (e.x * e.y * e.z * 31).abs().ceil()).toList();
        String hex = hexStringFromIntList(normalizedList);
        _textHexController.text = hex;
        print(hex);

        double entrpy = entropy(normalizedList);
        _textEntropyController.text = entrpy.toString();
        print(entrpy);

      }
      if (accelerometerTimer.elapsedMilliseconds > 100) {
        if (events.isEmpty || isMoving(events.last, current, 0.2)) {
          events.add(current);
        }

        accelerometerTimer.reset();
      }

    });
  }

  bool isMoving(AccelerometerEvent previous, AccelerometerEvent current, double precision) {
    return (previous.x - current.x).abs() > precision
        || (previous.y - current.y).abs() > precision
        || (previous.z - current.z).abs() > precision;
  }




}
