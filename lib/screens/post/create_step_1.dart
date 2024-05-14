import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
import 'package:bonsplans/controllers/post.dart';

class PostCreateStep1Screen extends StatefulWidget {
  static String id = Routes.post_create_step_1;
  final String title;

  const PostCreateStep1Screen({Key? key, required this.title}) : super(key: key);

  @override
  State<PostCreateStep1Screen> createState() => _PostCreateStep1ScreenState();
}

class _PostCreateStep1ScreenState extends State<PostCreateStep1Screen> {
  final _formKey = GlobalKey<FormState>();
  bool _isFilter = false;
  var _currentCategory = null;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final token = (authProvider.token != null && !authProvider.token.isEmpty) ? authProvider.token : Constants.token;
    final tokenRefresh = (authProvider.tokenRefresh != null && !authProvider.tokenRefresh.isEmpty) ? authProvider.tokenRefresh : Constants.tokenRefresh;
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final postController = Get.put(PostController());
    final category = Get.arguments?['category'];
    final size = MediaQuery.of(context).size;
    final topHeight = MediaQuery.of(context).viewPadding.top;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_isFilter) {
        try {
          http.Response responseCategories = await listAllCategories(token, tokenRefresh);
          var bodyCategories = json.decode(utf8.decode(responseCategories.bodyBytes));
          categoryProvider.categories = bodyCategories;
          if (categoryProvider.categories.length > 0 && _currentCategory == null) {
            _currentCategory = category != null ? category : categoryProvider.categories[0]['id'];
          }
        } on Exception catch (e, s) {
          print('totototototo exception: ${e.toString()}');
        }
        setState(() {
          _isFilter = true;
        });
      }
    });

    return Scaffold(
      // appBar: AppBar(
        // title: Text(widget.title),
      // ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(top: topHeight + 10, bottom: topHeight + 10),
            child: Column(
              children: <Widget>[
                Container(
                  width: size.width,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            iconSize: 24.0,
                            color: ColorExtension.toColor('#9E9E9E'),
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(
                              FontAwesomeIcons.arrowLeft,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Publier une offre".tr,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 10),
                        child: Align(
                          alignment: Alignment.center,
                          child: Icon(
                            size: 24.0,
                            color: ColorExtension.toColor('#FFFFFF'),
                            Icons.share,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: size.width,
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 2),
                  margin: EdgeInsets.only(top: 10),
                  child: Text("Sélectionnez la catégorie".tr,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ColorExtension.toColor('#FF914D'),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: size.height * 0.04, width: size.width * 0.08),
                            Container(
                              width: size.width,
                              height: 50,
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                color: ColorExtension.toColor('#FFFFFF'),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  width: 1,
                                  color: ColorExtension.toColor('#9E9E9E'),
                                ),
                              ),
                              child: DropdownButton<dynamic>(
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorExtension.toColor('#000000'),
                                ),
                                icon: Icon(
                                  FontAwesomeIcons.chevronDown, 
                                  size: 16,
                                ),
                                underline: Container(
                                  height: 0,
                                ),
                                selectedItemBuilder: (BuildContext context) {
                                  return categoryProvider.categories.map((dynamic value) {
                                    return Container(
                                      width: size.width*0.62,
                                      height: 50,
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "${value['title']}".tr,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList();
                                },
                                items: categoryProvider.categories.map<DropdownMenuItem<dynamic>>((dynamic value) {
                                  return DropdownMenuItem<dynamic>(
                                    value: value['id'],
                                    child: Container(
                                      width: size.width*0.62,
                                      height: 50,
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "${value['title']}".tr,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: ColorExtension.toColor('#000000'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (dynamic? value) {
                                  _currentCategory = value;
                                  setState(() {
                                    _isFilter = true;
                                  });
                                },
                                value: _currentCategory,
                              ),
                            ),
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      postController.post = {...postController.post, 'category': _currentCategory,};
                                      Get.toNamed(Routes.post_create_step_2);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 1.0,
                                      backgroundColor: ColorExtension.toColor('#FF914D'),
                                      shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                      padding: const EdgeInsets.only(left: 20, right: 20, top: 18, bottom: 18)
                                    ),
                                    child: Text(
                                      "Suivant".tr,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: ColorExtension.toColor('#FFFFFF'),
                                      ),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
