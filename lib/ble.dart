//
// Created by @sh1l0n
//
// Licensed by GPLv3
// This file is part of lib_screen package
//


import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

import 'ble_device.dart';

class BLEManagerLocationPermissionException implements Exception {
  String message() =>  'Location permission needed';
}

class BLEManagerDisabledException implements Exception {
  String message() => 'BLE toggle needs to turn on';
}

class BLEManagerNotSupportedException implements Exception {
  String message() => 'BLE not supported on your device';
}

class BLEManager {
  static final BLEManager _singleton = BLEManager._internal();
  factory BLEManager() {
    return _singleton;
  }

  BLEManager._internal() {
    _flutterBlue.scanResults.listen((results) async {
      for (final ScanResult sr in results) {
        final id = sr.device.id.id;
        final rssi = sr.rssi;
        final device = BLEDevice(rssi, BLEConnectableDevice(sr.device));
        if (_devices.containsKey(id)) {
          _devices.update(id, (value) => device);
        } else {
          _devices[id] = device;
        }
      }
    });
  }

  FlutterBlue get _flutterBlue => FlutterBlue.instance;
  
  late Map<String, BLEDevice> _devices = {};
  Map<String, BLEDevice> get devices => _devices;

  late bool _isScanning = false;
  bool get isScanning => _isScanning;

  void askForLocationPermission() async {
    await Permission.location.request();
  }

  void startScan() async {
    if(isScanning) {
      return;
    }

    if (!(await _flutterBlue.isAvailable)) {
      throw BLEManagerNotSupportedException();
    }

    if (!(await _flutterBlue.isOn)) {
      throw BLEManagerDisabledException();
    }

    if(!(await Permission.location.isGranted)) {
      throw BLEManagerLocationPermissionException();
    }

    await _flutterBlue.startScan();
    _isScanning = true;
  }

  void stopScan() async {
    if (!isScanning) {
      return;
    }
    await _flutterBlue.stopScan();
    _isScanning = false;
  }
}