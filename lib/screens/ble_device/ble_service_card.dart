
import 'package:flutter/material.dart';
import 'package:flutter_ble/ble/ble_device.dart';

class BLEServiceCard extends StatelessWidget {
  const BLEServiceCard({Key? key, required this.service}) : super(key: key);


  final BLEService service;


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double height = service.characteristics.length*25  + (service.characteristics.length-1)*1 + 30;
    return Container(
      width: size.width,
      height: height,
      color: Color(0xffff0000),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
            child: Text(service.uuid, style: TextStyle(fontSize: 25)),
          ),
          Container(width: 5),
          ListView.separated(
            itemBuilder: (final BuildContext context, final int index) {
              return Container(
                height: 25,
                color: Color(0xff000000),
                child: Text(service.characteristics[index].uuid),
              );
            }, 
            separatorBuilder: (final BuildContext context, final int index) {
              return Container(
                height: 1,
                color: Color(0xff121212),
              ); 
            }, 
            itemCount: service.characteristics.length
          ),
        ],
      ),
      
    );
  }
}