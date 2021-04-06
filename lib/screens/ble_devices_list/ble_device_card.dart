
import 'package:flutter/widgets.dart';

class BLEDeviceCard extends StatelessWidget {
  const BLEDeviceCard(
    {Key? key, 
    required this.id, 
    required this.name, 
    required this.rssi
  }) : super(key: key);

  final String id;
  final String name;
  final int rssi;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Color(0xffff0000),
      child: Text(
        'id $id name: $name rssi $rssi'
      ),
    );
  }
  
} 