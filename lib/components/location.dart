import 'package:flutter/material.dart';

import 'package:bonsplans/utils/colors.dart';

class Location { 
  const Location(this.place_id, this.display_name, this.lat, this.lon);
  final int place_id;
  final String display_name;
  final double lat;
  final double lon;
}

class LocationList extends StatelessWidget {
  final Location item;
  LocationList({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ColorExtension.toColor('#EEEEEE'), width: 1),
        ),
      ),
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${this.item.display_name}",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ColorExtension.toColor('#000000'),
                ),
              ),
            ),
          ),
        ],
      ),
    ); 
  } 
}
