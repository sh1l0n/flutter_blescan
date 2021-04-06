
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
      setState(() {});
    });
  }

  Widget homeButton(final BuildContext context) {
    return BackButton(
      color: Color(0xffffffff),
      onPressed: () {
        bleDevice?.peripheral.disconnect().then((value) {
          Navigator.pop(context);
        });
      },
    );
  }

  String _connecionStatusToString(final BLEDeviceConnectionStatus? o) {
    switch(o) {
      case BLEDeviceConnectionStatus.connected: return 'connected';
      case BLEDeviceConnectionStatus.connecting: return 'connecting';
      case BLEDeviceConnectionStatus.disconnecting: return 'disconnecting';
      case BLEDeviceConnectionStatus.disconnected: return 'disconnected';
      default: return 'connecting';
    }
  }

  Widget _connectionStatus(final BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 23,
      color: Color(0xff242424),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        child: FutureBuilder(
        initialData: BLEDeviceConnectionStatus.disconnected,
        future: bleDevice?.peripheral.status,
        builder: (final BuildContext c, final AsyncSnapshot<BLEDeviceConnectionStatus> snp) {
          final state = _connecionStatusToString(snp.data);
          return Text('Status: $state', style: TextStyle(color: Color(0xffefefef), fontSize: 15));
        }),
      ),
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
        child: Column(
          children: [
            _connectionStatus(context),
          ],
        ),
      )
    );
  }
  
}