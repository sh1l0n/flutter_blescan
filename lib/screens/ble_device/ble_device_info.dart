
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ble/screens/ble_device/ble_service_card.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../ble/ble.dart';
import '../../ble/ble_device.dart';


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
    bleDevice?.peripheral.connect(timeout: Duration(seconds: 3)).then((final bool isConnected) async {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    bleDevice?.peripheral.disconnect();
    super.dispose();
  }

  Widget homeButton(final BuildContext context) {
    return BackButton(
      color: Color(0xffffffff),
      onPressed: () {
        Navigator.pop(context);
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

  Widget _buildSections(final BuildContext context) {
   return StreamBuilder(
     initialData: List<BLEService>.empty(),
     stream: bleDevice?.peripheral.servicesStream,
     builder: (final BuildContext context, final AsyncSnapshot<List<BLEService>> snp) {
        final services = snp.data ?? [];
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 23 - 50,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return BLEServiceCard(service: services[index]);
              }, 
              itemCount: services.length,
            ),
          );
     }
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
            bleDevice?.peripheral.name ?? 'N/A', 
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
          leading: homeButton(context),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color(0xffababab),
        child: Column(
          children: [
            _connectionStatus(context),
            _buildSections(context),
          ],
        ),
      )
    );
  }
  
}