//
// Created by @sh1l0n
//
// Licensed by GPLv3
//

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'ble_devices_list.dart';

class BLEDevicesListScreen extends StatefulWidget {
  const BLEDevicesListScreen();

  @override
  State<StatefulWidget> createState() => _BLEDevicesListScreenState();
}

class _BLEDevicesListScreenState extends State<BLEDevicesListScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  PreferredSize(
        preferredSize: Size.fromHeight(50), // here the desired height
        child: AppBar(
          backgroundColor: Color(0xff424242),
          title: Text(
            'BLE Scanner', 
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            CircularProgressIndicator()
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xffababab),
        child: const BLEDeviceList()
      )
    );
  }
}