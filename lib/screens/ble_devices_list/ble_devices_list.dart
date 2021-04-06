
import 'package:flutter/widgets.dart';

import 'package:flutter_ble/ble/ble.dart';
import 'package:flutter_ble/ble/ble_device.dart';

import 'ble_device_card.dart';

class BLEDeviceListScreen extends StatefulWidget {
  const BLEDeviceListScreen();

  @override
  State<StatefulWidget> createState() => _BLEDeviceListScreenState();
}

class _BLEDeviceListScreenState extends State<BLEDeviceListScreen> {

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: List<BLEDevice>.empty(),
      stream: BLEManager().scanDevicesStream,
      builder: (final BuildContext c, final AsyncSnapshot<List<BLEDevice>> snp) {
        final data = snp.data ?? [];
        return ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (final BuildContext c, final int index) {  
            return BLEDeviceCard(id: data[index].peripheral.id, name: data[index].peripheral.name, rssi: data[index].rssi);
          },
          itemCount: data.length,
        );
      }
    );
  }

  Future<void> _startScan() async {
    try {
      await BLEManager().startScan();
    } on BLEManagerDisabledException {
      print('oo2');
    } on BLEManagerNotSupportedException {
      print('oo3');
    }
  }
}