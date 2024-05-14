import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:bonsplans/utils/colors.dart';

class Account { 
  const Account(this.iconData, this.text);
  final IconData iconData;
  final String text;
}

class AccountList extends StatelessWidget {
  final Account item;
  AccountList({Key? key, required this.item}) : super(key: key);

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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        size: 30.0,
                        color: ColorExtension.toColor('#FF914D'),
                        this.item.iconData,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        this.item.text,
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
              Padding(
                padding: const EdgeInsets.only(right: 5, top: 10, bottom: 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    size: 24.0,
                    color: ColorExtension.toColor('#9E9E9E'),
                    FontAwesomeIcons.chevronRight,
                  ),
                ),
              ),
            ], 
          ),
        ],
      ),
    ); 
  } 
}
