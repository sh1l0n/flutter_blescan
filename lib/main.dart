//
// Created by @sh1l0n
//
// Licensed by GPLv3
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/ble_devices_list/ble_devices_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(AppRootWidget());
}

class AppRootWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLE Scanner',
      home: const BLEDevicesListScreen(),
    );
  }
}