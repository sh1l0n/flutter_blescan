//
// Created by @sh1l0n
//
// Licensed by GPLv3
//

import 'dart:async';
import 'dart:io';

import 'package:flutter_blue/flutter_blue.dart';

enum BLEDeviceConnectionStatus {
  connected,
  connecting,
  disconnected,
  disconnecting,
  unknown
}

BLEDeviceConnectionStatus parseLibraryStatus(final BluetoothDeviceState state) {
  switch (state) {
    case BluetoothDeviceState.connected:
      return BLEDeviceConnectionStatus.connected;
    case BluetoothDeviceState.connecting:
      return BLEDeviceConnectionStatus.connecting;
    case BluetoothDeviceState.disconnected:
      return BLEDeviceConnectionStatus.disconnected;
    case BluetoothDeviceState.disconnecting:
      return BLEDeviceConnectionStatus.disconnecting;
    default:
      return BLEDeviceConnectionStatus.unknown;
  }
}

class BLECharacteristic {
  const BLECharacteristic(this.uuid, this.write, this.read, this.broadcast);
  final bool write;
  final bool read;
  final bool broadcast;
  final String uuid;

  Map<String, dynamic> toJson() {
    return {
      "uuid": uuid,
      "write": write,
      "read": read,
      "broadcast": broadcast,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

class BLEService {
  const BLEService(this.uuid, this.characteristics);
  final String uuid;
  final List<BLECharacteristic> characteristics;

  Map<String, dynamic> toJson() {
    return {
      "uuid": uuid,
      "characteristics": characteristics,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

class BLEConnectableDevice {
  BLEConnectableDevice(this.device);

  final BluetoothDevice device;
  late List<BLEService> _services;
  List<BLEService> get services => _services;

  String get name => device.name;
  String get id => device.id.id;

  final StreamController<List<BLEService>> _servicesStreamController = StreamController<List<BLEService>>.broadcast();
  Stream<List<BLEService>> get servicesStream => _servicesStreamController.stream;
  Sink<List<BLEService>> get _servicesSink => _servicesStreamController.sink;

  void dispose() {
    _servicesStreamController.close();
  }

  Future<BLEDeviceConnectionStatus> get status async => parseLibraryStatus(await device.state.first);

  Future<bool> connect({Duration? timeout}) async {
    BLEDeviceConnectionStatus status = await this.status;
    if (status == BLEDeviceConnectionStatus.connected ||
        status == BLEDeviceConnectionStatus.connecting) {
      return false;
    }
    await device
      .connect(autoConnect: false)
      .timeout(timeout ?? Duration(seconds: 3), onTimeout: () {});

    sleep(Duration(milliseconds: 100));
    final bool isConnected = (await this.status) == BLEDeviceConnectionStatus.connected;
    if (isConnected) {
      device.services.listen((final List<BluetoothService> services) {
        _services = [];
        for(final BluetoothService service in services) {
          List<BLECharacteristic> cs = [];
          for(final BluetoothCharacteristic characteristic in service.characteristics) {
            cs += [BLECharacteristic(
              characteristic.uuid.toString(), 
              characteristic.properties.read, 
              characteristic.properties.write, 
              characteristic.properties.broadcast
            )];
          }
          _services += [BLEService(service.uuid.toString(), cs)];
        } 
        if(_servicesStreamController.hasListener) {
          _servicesSink.add(_services);
        }
      });

     final x = await device.discoverServices();
     print('x :$x');
    }

    return isConnected;
  }

  Future<bool> disconnect() async {
    BLEDeviceConnectionStatus status = await this.status;
    if (status == BLEDeviceConnectionStatus.disconnected ||
        status == BLEDeviceConnectionStatus.disconnecting) {
      return false;
    }
    try {
      await this.device.disconnect();
    }
    catch (e) {
      return false;
    }
    sleep(Duration(milliseconds: 100));
    status = await this.status;
    return status == BLEDeviceConnectionStatus.disconnected;
  }
}

class BLEDevice {
  const BLEDevice(this.rssi, this.peripheral);
  final int rssi;
  final BLEConnectableDevice peripheral;

  Map<String, dynamic> toJson() {
    return {
      "rssi": rssi,
      "name": peripheral.name,
      "id": peripheral.id,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
