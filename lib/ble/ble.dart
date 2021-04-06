//
// Created by @sh1l0n
//
// Licensed by GPLv3
//


import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart' show FlutterBlue, ScanResult;
import 'ble_device.dart';

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
      _scanDevicesSink.add(devices.values.toList());
    });
  }

  FlutterBlue get _flutterBlue => FlutterBlue.instance;
  
  late Map<String, BLEDevice> _devices = {};
  Map<String, BLEDevice> get devices => _devices;

  late bool _isScanning = false;
  bool get isScanning => _isScanning;

  StreamController<List<BLEDevice>> _scanDevicesController = StreamController<List<BLEDevice>>.broadcast();
  Sink<List<BLEDevice>> get _scanDevicesSink => _scanDevicesController.sink;
  Stream<List<BLEDevice>> get scanDevicesStream => _scanDevicesController.stream;

  void dispose() async {
    await stopScan();
    _scanDevicesController.close();
  }


  Future<void> startScan() async {
    if(isScanning) {
      return;
    }

    if (!(await _flutterBlue.isAvailable)) {
      throw BLEManagerNotSupportedException();
    }

    if (!(await _flutterBlue.isOn)) {
      throw BLEManagerDisabledException();
    }

    _isScanning = true;
    await _flutterBlue.startScan(allowDuplicates: true);
  }

  Future<void> stopScan() async {
    if (!isScanning) {
      return;
    }
    await _flutterBlue.stopScan();
    _isScanning = false;
  }
}