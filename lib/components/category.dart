import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:bonsplans/utils/colors.dart';
import 'package:bonsplans/configs/constants.dart';
import 'package:bonsplans/configs/routes.dart';
import 'package:bonsplans/controllers/login.dart';

class Category { 
   const Category(this.id, this.title, this.subtitle, this.thumbnail, this.posts); 
   final int id; 
   final String title; 
   final String? subtitle; 
   final String? thumbnail; 
   final List<dynamic> posts; 
}

class CategoryList extends StatelessWidget {
  final Category item;
  CategoryList({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.only(left: 2.5, right: 2.5, bottom: 5),
      width: (size.width/3)-5,
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: ColorExtension.toColor('#EEEEEE'),
            width: 0,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container( 
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
          child: Column( 
            children: <Widget>[ 
              if (this.item.thumbnail != null) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container( 
                    height: 90.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage('${Constants.baseUrl}${this.item.thumbnail}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    this.item.title.tr,
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
        ),
      ),
    ); 
  } 
}

class CategoryAllList extends StatelessWidget {
  final Category item;
  CategoryAllList({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginControl = Get.put(LoginController());

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
                  if (loginControl.authenticated && loginControl.role < 3) ...[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${this.item.title.tr} (${this.item.posts.length})',
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
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.post_create_step_1, arguments: {'category': this.item.id},);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            size: 30.0,
                            color: ColorExtension.toColor('#FF914D'),
                            Icons.add_circle,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${this.item.title.tr} (${this.item.posts.length})',
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
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          size: 30.0,
                          color: ColorExtension.toColor('#9E9E9E'),
                          Icons.view_list,
                        ),
                      ),
                    ),
                  ],
                ], 
              ),
            ],
          ),
        ),
      ),
    ); 
  } 
}
