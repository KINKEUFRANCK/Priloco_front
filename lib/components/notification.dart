import 'package:flutter/material.dart';

import 'package:bonsplans/utils/colors.dart';

class NotificationItem { 
   const NotificationItem(this.id, this.title, this.description, this.type, this.item); 
   final int id; 
   final String title; 
   final String description; 
   final int type; 
   final int item; 
}

class NotificationList extends StatelessWidget {
  final NotificationItem item;
  NotificationList({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: ColorExtension.toColor('#EEEEEE'),
            width: 0,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container( 
          padding: const EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container( 
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: Image.asset('assets/images/logo.png').image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                this.item.title,
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
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
                    child: Align(
                    alignment: Alignment.centerRight,
                      child: Icon(
                        size: 30.0,
                        color: ColorExtension.toColor('#95989A'),
                        Icons.close,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ); 
  } 
}
