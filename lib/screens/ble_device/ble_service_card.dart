//
// Created by @sh1l0n
//
// Licensed by GPLv3
//

import 'package:flutter/material.dart';
import 'package:flutter_ble/ble/ble_device.dart';

class BLEServiceCard extends StatelessWidget {
  const BLEServiceCard({Key? key, required this.service}) : super(key: key);


  final BLEService service;


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      color: Color(0xff727272),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
            child: Text(service.uuid, maxLines: 1, style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          Container(height: 5),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            width: size.width,
            height: service.characteristics.length*25.0 + service.characteristics.length,
            child: ListView.separated(
              itemBuilder: (final BuildContext context, final int index) {
                return Container(
                  width: size.width,
                  height: 25,
                  color: Color(0xffaeaeae),
                  child: Align( 
                    alignment: Alignment.centerLeft,
                    child: Text(service.characteristics[index].uuid),
                  ),
                );
              }, 
              separatorBuilder: (final BuildContext context, final int index) {
                return Container(
                  width: size.width,
                  height: 1,
                  color: Color(0xff121212),
                ); 
              }, 
              itemCount: service.characteristics.length
            ),
          )
        ],
      ),
    );
  }
}