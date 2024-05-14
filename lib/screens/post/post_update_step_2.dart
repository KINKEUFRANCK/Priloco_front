import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:another_flushbar/flushbar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import 'package:bonsplans/configs/routes.dart';
import 'package:bonsplans/utils/colors.dart';
import 'package:bonsplans/utils/formatter.dart';
import 'package:bonsplans/utils/api.dart';
import 'package:bonsplans/providers/auth.dart';
import 'package:bonsplans/providers/post.dart';
import 'package:bonsplans/configs/constants.dart';
import 'package:bonsplans/controllers/post.dart';

class PostUpdateStep2Screen extends StatefulWidget {
  static String id = Routes.post_update_step_2;
  final String title;

  const PostUpdateStep2Screen({Key? key, required this.title}) : super(key: key);

  @override
  State<PostUpdateStep2Screen> createState() => _PostUpdateStep2ScreenState();
}

class _PostUpdateStep2ScreenState extends State<PostUpdateStep2Screen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController serviceController = TextEditingController();
  TextEditingController conditionController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  bool _isFilter = false;
  bool _isSubmit = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final token = (authProvider.token != null && !authProvider.token.isEmpty) ? authProvider.token : Constants.token;
    final tokenRefresh = (authProvider.tokenRefresh != null && !authProvider.tokenRefresh.isEmpty) ? authProvider.tokenRefresh : Constants.tokenRefresh;
    final postProvider = Provider.of<PostProvider>(context);
    final postController = Get.put(PostController());
    final post = Get.arguments?['post'];
    final size = MediaQuery.of(context).size;
    final topHeight = MediaQuery.of(context).viewPadding.top;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_isFilter) {
        try {
          http.Response responsePost = await retrievePost(token, tokenRefresh, id: post);
          var bodyPost = json.decode(utf8.decode(responsePost.bodyBytes));

          postProvider.post = bodyPost;
          phoneController.text = bodyPost['phone'] != null ? bodyPost['phone'] : '';
          serviceController.text = bodyPost['service'] != null ? bodyPost['service'] : '';
          conditionController.text = bodyPost['condition'] != null ? bodyPost['condition'] : '';
          urlController.text = bodyPost['url'] != null ? bodyPost['url'] : '';
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
                          child: Text("Modifier une offre".tr,
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
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                  margin: EdgeInsets.only(top: 10),
                  child: Text("Renseignez les informations".tr,
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
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: phoneController,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                                hintText: "Numéro de téléphone".tr,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(top: 0, left: 5, right: 0, bottom: 1),
                                  child: Icon(FontAwesomeIcons.phone,),
                                ),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: serviceController,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                                hintText: "Services".tr,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(top: 0, left: 5, right: 0, bottom: 1),
                                  child: Icon(FontAwesomeIcons.infoCircle,),
                                ),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: conditionController,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                                hintText: "Conditions".tr,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(top: 0, left: 5, right: 0, bottom: 1),
                                  child: Icon(FontAwesomeIcons.infoCircle,),
                                ),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            TextFormField(
                              keyboardType: TextInputType.url,
                              controller: urlController,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Veuillez entrer l'URL".tr;
                                } else if (!Uri.parse(value).isAbsolute) {
                                  return 'Veuillez entrer un URL valide'.tr;
                                }
                                return null;
                              },
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                                hintText: "URL *".tr,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(top: 0, left: 5, right: 0, bottom: 1),
                                  child: Icon(FontAwesomeIcons.link,),
                                ),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        if (!_isSubmit) {
                                          setState(() {
                                            _isSubmit = true;
                                          });
                                          try {
                                            http.Response responsePost = await updatePost(token, tokenRefresh, id: post, title: postController.post['title'], price: num.tryParse(postController.post['price'].toString())!.toDouble(), promotion: num.tryParse(postController.post['promotion'].toString())!.toInt(), content: postController.post['content'], phone: phoneController.text, service: serviceController.text, condition: conditionController.text, url: urlController.text);
                                            var bodyPost = json.decode(utf8.decode(responsePost.bodyBytes));
                                            switch (responsePost.statusCode) {
                                              case 200:
                                                Flushbar(
                                                  icon: Icon(
                                                    Icons.info_outline,
                                                    size: 28.0,
                                                    color: Colors.blue,
                                                  ),
                                                  duration: Duration(seconds: 3),
                                                  leftBarIndicatorColor: Colors.blue,
                                                  flushbarPosition: FlushbarPosition.TOP,
                                                  title: 'Modifier une offre'.tr,
                                                  message: "La modification de l'offre a été effectué",
                                                )..show(context);
                                                await Future.delayed(const Duration(seconds: 3));
                                                Get.toNamed(Routes.menu);
                                                break;
                                              default:
                                                Flushbar(
                                                  icon: Icon(
                                                    Icons.info_outline,
                                                    size: 28.0,
                                                    color: Colors.blue,
                                                  ),
                                                  duration: Duration(seconds: 3),
                                                  leftBarIndicatorColor: Colors.blue,
                                                  flushbarPosition: FlushbarPosition.TOP,
                                                  title: 'Modifier une offre'.tr,
                                                  message: "Une erreur a été rencontrée lors de la modification de l'offre",
                                                )..show(context);
                                                break;
                                            }
                                          } on Exception catch (e, s) {
                                            print('totototototo exception: ${e.toString()}');

                                            Flushbar(
                                              icon: Icon(
                                                Icons.info_outline,
                                                size: 28.0,
                                                color: Colors.blue,
                                              ),
                                              duration: Duration(seconds: 3),
                                              leftBarIndicatorColor: Colors.blue,
                                              flushbarPosition: FlushbarPosition.TOP,
                                              title: 'Modifier une offre'.tr,
                                              message:  e.toString(),
                                            )..show(context);
                                          }
                                          setState(() {
                                            _isSubmit = false;
                                          });
                                        }
                                      } else {
                                        Flushbar(
                                          icon: Icon(
                                            Icons.info_outline,
                                            size: 28.0,
                                            color: Colors.blue,
                                          ),
                                          duration: Duration(seconds: 3),
                                          leftBarIndicatorColor: Colors.blue,
                                          flushbarPosition: FlushbarPosition.TOP,
                                          title: 'Modifier une offre'.tr,
                                          message: 'Veuillez remplir les champs'.tr,
                                        )..show(context);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 1.0,
                                      backgroundColor: ColorExtension.toColor('#FF914D'),
                                      shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                      padding: const EdgeInsets.only(left: 20, right: 20, top: 18, bottom: 18)
                                    ),
                                    child: Text(
                                      _isSubmit ? "Modifier...".tr : "Modifier".tr,
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
