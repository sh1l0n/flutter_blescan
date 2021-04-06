import 'package:flutter/material.dart';
// import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
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

  late Map<String, BLEDevice> devices = {};

  Future<void> scan() async {
    if (scanning) {
      print('is scanning');
      return;
    }

    if (!(await flutterBlue.isAvailable)) {
      //TODO: Alert ble is not avaialble on your phone
      return;
    }

    if (!(await flutterBlue.isOn)) {
      //TODO: Alert request activate bLE
      return;
    }

    scanning = true;
    bool granted = false;
    while (!granted) {
      granted = await Permission.location.request().isGranted;
    }

    print('start scann!');

    final List<ScanResult> results =
        await flutterBlue.startScan(timeout: Duration(seconds: 5));

    for(final ScanResult sr in results) {

      final id = sr.device.id.id;
      final name = sr.device.name;
      final status = await sr.device.state.first;
      final rssi = sr.rssi;
      final device = BLEDevice(rssi, name, id, parseLibraryStatus(status));

      if (devices.containsKey(id)) {
        devices.update(id, (value) => device);
      } else {
        devices[id] = device;
      }
    }
    scanning = false;
  }


  @override
  void initState() {
    super.initState();
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
                    scan().then((value) {
                      print('devices: $devices');
                    });
                  },
                  child: Text('hello scan')),
            ),
          ],
        ),
      ),
    );
  }
}

enum BLEDeviceConnectionStatus {
  connected,
  connecting,
  disconnected,
  disconnecting,
  unknown
}

BLEDeviceConnectionStatus parseLibraryStatus(final BluetoothDeviceState state) {
  switch(state) {
    case BluetoothDeviceState.connected:
      return BLEDeviceConnectionStatus.connected;
    case BluetoothDeviceState.connecting:
      return BLEDeviceConnectionStatus.connecting;
    case BluetoothDeviceState.disconnected:
      return BLEDeviceConnectionStatus.disconnected;
    case BluetoothDeviceState.disconnecting:
      return BLEDeviceConnectionStatus.disconnecting;
    default:
      return BLEDeviceConnectionStatus.unknown;
  }
}

class BLEDevice {
  const BLEDevice(this.rssi, this.name, this.id, this.status);
  final int rssi;
  final String name;
  final String id;
  final BLEDeviceConnectionStatus status;

  Map<String, dynamic> toJson() {
    return {
      "rssi": rssi,
      "name": name,
      "id": id,
      "status": status,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
