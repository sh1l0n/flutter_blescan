//
// Created by @sh1l0n
//
// Licensed by GPLv3
//

import 'package:flutter/material.dart';

import 'ble_devices_list/ble_devices_list_screen.dart';
import 'ble_device/ble_device_info.dart';

class NavigatorManager extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLE Scanner',
      initialRoute: BLEDevicesListScreen.route,
      onGenerateRoute: (final RouteSettings settings) {
        final route = settings.name;
        if (route == BLEDevicesListScreen.route) {
           return MaterialPageRoute(builder: (context) {
            return const BLEDevicesListScreen();
          });
        } else if (route == BLEInfoScreen.route) {
          return MaterialPageRoute(builder: (context) {
            final String uuid = settings.arguments as String;
            print('received id: $uuid');
            return BLEInfoScreen(uuid: uuid);
          });       
        } else {
          return MaterialPageRoute(builder: (context) => Container());
        }
      },
    );
  }
}