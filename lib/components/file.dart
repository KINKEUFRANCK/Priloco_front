import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';

import 'package:bonsplans/utils/colors.dart';

class Fil { 
   const Fil(this.index, this.name, this.path, this.bytes, this.size, this.extension); 
   final int index; 
   final String name; 
   final String? path; 
   final Uint8List? bytes; 
   final int size; 
   final String? extension; 
}

class FileList extends StatelessWidget {
  final Fil item;
  final Function(int) functionCallback;
  FileList({Key? key, required this.item, required this.functionCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container( 
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      child: Column( 
        children: <Widget>[ 
          if (kIsWeb) ...[
            Container( 
              height: 70.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: MemoryImage(this.item.bytes!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ] else ...[
            if (Platform.isIOS || Platform.isAndroid) ...[
              Container( 
                height: 70.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: Image.file(File(this.item.path!)).image,
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            this.functionCallback(this.item.index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Icon(
                              size: 20.0,
                              color: ColorExtension.toColor('#9E9E9E'),
                              FontAwesomeIcons.close,
                            ),
                          ),
                        ),
                      ], 
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container( 
                height: 90.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: MemoryImage(this.item.bytes!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            this.functionCallback(this.item.index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Icon(
                              size: 20.0,
                              color: ColorExtension.toColor('#9E9E9E'),
                              FontAwesomeIcons.close,
                            ),
                          ),
                        ),
                      ], 
                    ),
                  ],
                ),
              ),
            ]
          ]
        ], 
      ),
    ); 
  } 
}
