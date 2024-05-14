import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import 'package:bonsplans/configs/routes.dart';
import 'package:bonsplans/utils/colors.dart';
import 'package:bonsplans/utils/api.dart';
import 'package:bonsplans/providers/auth.dart';
import 'package:bonsplans/providers/category.dart';
import 'package:bonsplans/configs/constants.dart';
import 'package:bonsplans/controllers/login.dart';

import 'package:bonsplans/components/category.dart';
import 'package:bonsplans/components/overlay.dart';

class CategoryListScreen extends StatefulWidget {
  static String id = Routes.category_list;
  final String title;

  const CategoryListScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  bool _isFilter = false;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final token = (authProvider.token != null && !authProvider.token.isEmpty) ? authProvider.token : Constants.token;
    final tokenRefresh = (authProvider.tokenRefresh != null && !authProvider.tokenRefresh.isEmpty) ? authProvider.tokenRefresh : Constants.tokenRefresh;
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final loginControl = Get.put(LoginController());
    final size = MediaQuery.of(context).size;
    final topHeight = MediaQuery.of(context).viewPadding.top;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_isFilter) {
        try {
          if (!_isFavorite) {
            Loader.appLoader.showLoader();
          }

          http.Response responseCategories = await listCategories(token, tokenRefresh, authenticated: loginControl.authenticated);
          var bodyCategories = json.decode(utf8.decode(responseCategories.bodyBytes));

          http.Response responseAllCategories = await listAllCategories(token, tokenRefresh, authenticated: loginControl.authenticated);
          var bodyAllCategories = json.decode(utf8.decode(responseAllCategories.bodyBytes));

          categoryProvider.categories = bodyCategories;
          categoryProvider.all_categories = bodyAllCategories;

          if (!_isFavorite) {
            Loader.appLoader.hideLoader();
          }
        } on Exception catch (e, s) {
          print('totototototo exception: ${e.toString()}');
        }
        setState(() {
          _isFilter = true;
          _isFavorite = false;
        });
      }
    });

    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(top: topHeight + 10),
            child: Column(
              children: <Widget>[
                Container(
                  width: size.width,
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                  child: Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Catégories".tr,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: size.width,
                            padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                            ),
                            child: Text(
                              "Catégories populaires".tr,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: ColorExtension.toColor('#FF914D'),
                              ),
                            ),
                          ),
                          OverlayView(
                            item_1: Wrap(
                              direction: Axis.horizontal,
                              children: <Widget>[
                                if (categoryProvider.categories.length > 0) ...[
                                  for (int index = 0; index < categoryProvider.categories.length; index++) GestureDetector(
                                    onTap: () { Get.toNamed(Routes.post_list, arguments: {'category': categoryProvider.categories[index]['id']},); },
                                    child: CategoryList(item: new Category(categoryProvider.categories[index]['id'], categoryProvider.categories[index]['title'], categoryProvider.categories[index]['subtitle'], categoryProvider.categories[index]['thumbnail'], categoryProvider.categories[index]['posts'])),
                                  ),
                                ] else ...[
                                  Container(
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
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10),
                                                    child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                        "Pas de catégories populaires disponibles...".tr,
                                                        overflow: TextOverflow.ellipsis,
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: ColorExtension.toColor('#95989A'),
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
                                                      color: ColorExtension.toColor('#95989A'),
                                                      Icons.error,
                                                    ),
                                                  ),
                                                ),
                                              ], 
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                width: size.width * 0.95,
                                padding: const EdgeInsets.only(top: 10, bottom: 5),
                                child: Divider(
                                  thickness: 0.5,
                                  color: ColorExtension.toColor('#DDDDDD'),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: size.width,
                            padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                            ),
                            child: Text(
                              "Toutes les catégories".tr,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: ColorExtension.toColor('#FF914D'),
                              ),
                            ),
                          ),
                          OverlayView(
                            item_1: Column(
                              children: <Widget>[
                                if (categoryProvider.all_categories.length > 0) ...[
                                  for (int index = 0; index < categoryProvider.all_categories.length; index++) GestureDetector(
                                    onTap: () { Get.toNamed(Routes.post_list, arguments: {'category': categoryProvider.all_categories[index]['id']},); },
                                    child: CategoryAllList(item: new Category(categoryProvider.all_categories[index]['id'], categoryProvider.all_categories[index]['title'], categoryProvider.all_categories[index]['subtitle'], categoryProvider.all_categories[index]['thumbnail'], categoryProvider.all_categories[index]['posts'])),
                                  ),
                                ] else ...[
                                  Container(
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
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10),
                                                    child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                        "Pas de catégories disponibles...".tr,
                                                        overflow: TextOverflow.ellipsis,
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: ColorExtension.toColor('#95989A'),
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
                                                      color: ColorExtension.toColor('#95989A'),
                                                      Icons.error,
                                                    ),
                                                  ),
                                                ),
                                              ], 
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 2.0,
                    width: size.width * 0.95,
                    child: CustomPaint(painter: DashedLinePainter(),)
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 10, dashSpace = 5, startX = 0;
    final paint = Paint()
      ..color = ColorExtension.toColor('#DDDDDD')
      ..strokeWidth = 1;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
} */

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorExtension.toColor('#DDDDDD')
      ..strokeWidth = 1;

    Offset startX = Offset(0, size.height / 2);
    Offset endX = Offset(size.width, size.height / 2);

    canvas.drawLine(startX, endX, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
