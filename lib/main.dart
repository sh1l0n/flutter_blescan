import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  // late final flutterReactiveBle = ();

  FlutterBlue get flutterBlue => FlutterBlue.instance;

  bool scanning = false;

  void scan() async {
    if (scanning) {
      print('is scanning');
      return;
    }

    // if (!(await flutterBlue.isAvailable)) {
    //   return;
    // }

    // if (!(await flutterBlue.isOn)) {
    //   return;
    // }
    //
    // print('flutterReactiveBle.status: ${flutterReactiveBle.status} BleStatus.ready ${BleStatus.ready}');
    // if(flutterReactiveBle.status != BleStatus.ready) {
    //   return;
    // }

    scanning = true;
    bool granted = false;
    while (!granted) {
      granted = await Permission.location.request().isGranted;
    }

    print('start scann!');
    // FlutterReactiveBle().scanForDevices(
    //     withServices: [],
    //     scanMode: ScanMode.lowLatency).listen((device) {
    //   //code for handling results
    //   print('device: $device');
    // }, onDone: () {
    //   print('onDone');
    // }, onError: (final Object object, [final StackTrace? st]) {
    //   print('onbError: $object $st');
    //   //code for handling error
    // });

    flutterBlue.startScan(timeout: Duration(seconds: 5)).then((value) {
      print('finish scan: $value');
      scanning = false;
    }, onError: (final Object object, [final StackTrace? trace]) {
      print('onError $object trace: $trace');
    });

    // flutterBlue.stopScan();
    // .listen((event) {
    //   print('ooo');
    //   print('onData: $event');
    // }, onDone: () {
    //   print('onDone');
    // }, onError: (final Object object, [final StackTrace? trace]) {
    //     print('onError $object trace: $trace');
    // }, cancelOnError: true);
  }

  // void sc() {
  //   // Start scanning
  //   print('hello world');
  //   flutterBlue.startScan(timeout: Duration(seconds: 4));

  // // Listen to scan results
  //   var subscription = flutterBlue.scanResults.listen((results) {
  //     // do something with scan results
  //     for (ScanResult r in results) {
  //       print('${r.device.name} found! rssi: ${r.rssi}');
  //     }
  //   });

  // // Stop scanning
  //   flutterBlue.stopScan();
  // }

  @override
  void initState() {
    super.initState();

    // flutterBlue.scanResults.listen((results) {
    //   print('scanResults. results: $results');
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Container(
              width: 300,
              height: 80,
              color: Color(0x22ffaa22),
              child: TextButton(
                onPressed: () {
                  scan();
                },
                child: Text('hello scan')),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     scan();
      //     // sc();
      //   },
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
