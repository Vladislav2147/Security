import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lab_2/hash_generator.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
//  runApp(MyApp());
  runApp(HashGenerator());
}

class MyApp extends StatelessWidget {
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
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final textIpController = TextEditingController();
  final textPortController = TextEditingController();
  final textDataController = TextEditingController();
  final textOutputController = TextEditingController();

  // String _hash = "";
  static const platform = const MethodChannel('com.shichko.flutter/hash_channel');

  // Future<void> _getHash(String data) async {
  //   String hash;
  //   try {
  //     final int result = await platform.invokeMethod('getHash', {"data": data});
  //     hash = '$result%';
  //   } on PlatformException catch (e) {
  //     hash = "Failed to get hash: '${e.message}'.";
  //   }
  //
  //   setState(() {
  //     _hash = hash;
  //   });
  // }


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
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: textIpController,
              style: TextStyle(fontSize: 22),
              decoration: InputDecoration(
                hintText: 'Server\'s address',
              ),
            ),
            TextField(
              controller: textPortController,
              style: TextStyle(fontSize: 22),
              maxLength: 5,
              decoration: InputDecoration(
                hintText: 'Server\'s Port',
              ),
            ),
            TextField(
              controller: textDataController,
              style: TextStyle(fontSize: 22),
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Data String',
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  textOutputController.clear();
                    sendData("${textIpController.text}:${textPortController.text}", textDataController.text)
                        .then((response) {
                          String message = "Data corrupted";
                          if(jsonDecode(response.body)["status"] == 0) {
                            message = "Data successfully received";
                          }
                          Fluttertoast.showToast(
                              msg: message,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                          );
                    });
                  },
                child: Text("Send data", style: TextStyle(fontSize: 22))
            ),
            TextField(
              controller: textOutputController,
              enabled: false,
              style: TextStyle(fontSize: 22),
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Output',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<http.Response> sendData (String uri, String data) async {
    String encodedData = base64.encode(utf8.encode(data));
    // String hash = sha256.convert(utf8.encode(data)).toString();
    // textOutputController.text = hash;
    String hash = "";
    try {
      hash = await platform.invokeMethod('getHash', {"data": data});
      textOutputController.text = hash;
    } on PlatformException catch (e) {
      hash = "Failed to get hash: '${e.message}'.";
    }


    return http.post(
      //10.0.2.2:1337 || hash.my-services.com
      Uri.https(uri, 'vhash'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: jsonEncode(<String, String>{
        'data': encodedData,
        'hash': hash
      }),
    );
  }

}

