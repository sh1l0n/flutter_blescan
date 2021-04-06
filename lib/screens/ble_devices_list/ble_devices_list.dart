//
// Created by @sh1l0n
//
// Licensed by GPLv3
//

import 'package:flutter/widgets.dart';

import '../../ble/ble.dart';
import '../../ble/ble_device.dart';

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
        return ListView.separated(
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (final BuildContext c, final int index) {  
            return BLEDeviceCard(id: data[index].peripheral.id, name: data[index].peripheral.name, rssi: data[index].rssi);
          },
          separatorBuilder: (final BuildContext c, final int index) {  
            if (index>=data.length-1) {
              return Container();
            }
            return Container(height: 4);
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