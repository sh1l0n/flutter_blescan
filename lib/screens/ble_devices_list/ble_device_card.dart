//
// Created by @sh1l0n
//
// Licensed by GPLv3
//

import 'package:flutter/widgets.dart';

class BLEDeviceCard extends StatefulWidget {
  const BLEDeviceCard(
    {Key? key, 
    required this.id, 
    required this.name, 
    required this.rssi,
    required this.onTap,
  }) : super(key: key);

  final String id;
  final String name;
  final int rssi;
  final Function onTap;

  @override
  State<StatefulWidget> createState() => _BLEDeviceCardState();
}

class _BLEDeviceCardState extends State<BLEDeviceCard> {

  String get id => widget.id;
  String get name => widget.name;
  int get rssi => widget.rssi;
  Function get onTap => widget.onTap;

  late bool isPressed;

  @override
  void initState() {
    super.initState();
    isPressed = false;
  }

  void _changePressedValue(final bool v) {
    setState(() {
      isPressed = v; 
    });
  }

  Color _rssiColor() {
    final abs = rssi.abs();
    if (abs<60) {
      return Color(0xff00ee00);
    } else if (abs<90) {
      return Color(0xffeeee00);
    } else {
      return Color(0xffee0000);
    }
  }

  Color _rssiTextColor() {
    final abs = rssi.abs();
    if (abs<60) {
      return Color(0xff121212);
    } else if (abs<90) {
      return Color(0xff121212);
    } else {
      return Color(0xffefefef);
    }
  }

  Widget _buildHeader(final BuildContext context) {
    return Container(
      width: 62,
      height: 75,
      child: Center(
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: _rssiColor(),
          ),
          child: Center(
            child: Text(rssi.toString(), style: TextStyle(color: _rssiTextColor())),
          ),
        ),
      ),
    );
  }

  Widget _buildSeparator(final BuildContext context) {
     return Container(
        width: 6,
        height: 75,
        child: Center(
          child: Container(
            width: 1,
            height: 60,
            color: Color(0xff000000),
          ),
        ),
      );
  }

  Widget _buildText(final BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 75 - 6,
      height: 75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              name.isEmpty ? 'N/A' : name,
              textAlign: TextAlign.left,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              id.isEmpty ? 'N/A' : id,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _build(BuildContext context) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: isPressed ? Color(0xffa3a3a3) : Color(0xffefefef),
        boxShadow: [ 
          BoxShadow(
            color: isPressed ? Color(0xff242424) : Color(0xff747474), //color of shadow
            spreadRadius: 2, //spread radius
            blurRadius: 3, // blur radius
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          _buildHeader(context),
          _buildSeparator(context),
          //separator margin (the same as circle)
          Container(width: 6),
          _buildText(context),
        ],
      )
    );
  } 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (final TapDownDetails details) {
        _changePressedValue(true);
      },
      onTapUp: (final TapUpDetails details) {
        _changePressedValue(false);
        onTap();
      },
      onTapCancel: () {
        _changePressedValue(false);
      },
      child: _build(context),
    );
  }
} 