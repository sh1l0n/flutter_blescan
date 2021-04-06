//
// Created by @sh1l0n
//
// Licensed by GPLv3
//

import 'package:flutter_blue/flutter_blue.dart' show BluetoothDeviceState, BluetoothDevice;

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

class BLEConnectableDevice {
  BLEConnectableDevice(this.device);
  final BluetoothDevice device;

  String get name => device.name;
  String get id => device.id.id;

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

    status = await this.status;
    return status == BLEDeviceConnectionStatus.connected;
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
