//
// Created by @sh1l0n
//
// Licensed by GPLv3
//

import 'package:flutter/widgets.dart';

import '../../ble/ble.dart';
import '../../ble/ble_device.dart';

import 'ble_device_card.dart';

class BLEDeviceList extends StatefulWidget {
  const BLEDeviceList({Key? key, required this.onTapOnDevice});

  final Function onTapOnDevice;

  @override
  State<StatefulWidget> createState() => _BLEDeviceListState();
}

class _BLEDeviceListState extends State<BLEDeviceList> {

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
            final id = data[index].peripheral.id;
            return BLEDeviceCard(
              id: id, 
              name: data[index].peripheral.name, 
              rssi: data[index].rssi,
              onTap: () {
                widget.onTapOnDevice(id);
              });
          },
          separatorBuilder: (final BuildContext c, final int index) {  
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