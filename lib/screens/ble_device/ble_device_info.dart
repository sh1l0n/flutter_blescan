
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ble/ble/ble.dart';
import 'package:flutter_ble/ble/ble_device.dart';

class BLEInfoScreen extends StatefulWidget {
  const BLEInfoScreen({Key? key, required this.uuid}) : super(key: key);

  final String uuid;
  static String get route => '/info';


  @override
  State<StatefulWidget> createState() => _BLEInfoScreen();

}

class _BLEInfoScreen extends State<BLEInfoScreen> {

  String get uuid => widget.uuid;
  BLEDevice? get bleDevice => BLEManager().devices[uuid];

  @override
  void initState() {
    super.initState();
    print('uuid: $uuid bleDevice: $bleDevice');
    print('devices: ${BLEManager().devices}');
    bleDevice?.peripheral.connect(timeout: Duration(seconds: 3)).then((value) {
      print('device could connect: $value');
    });
  }

  Widget homeButton(final BuildContext context) {
    return BackButton(
      color: Color(0xffffffff),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  PreferredSize(
        preferredSize: Size.fromHeight(50), // here the desired height
        child: AppBar(
          backgroundColor: Color(0xff424242),
          title: Text(
            uuid, 
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
          leading: homeButton(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xffababab),
      )
    );
  }
  
}