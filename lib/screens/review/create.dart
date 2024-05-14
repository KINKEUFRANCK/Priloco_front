import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:bonsplans/configs/routes.dart';
import 'package:bonsplans/utils/colors.dart';
import 'package:bonsplans/utils/api.dart';
import 'package:bonsplans/providers/auth.dart';
import 'package:bonsplans/providers/post.dart';
import 'package:bonsplans/configs/constants.dart';

class ReviewCreateScreen extends StatefulWidget {
  static String id = Routes.review_create;
  final String title;

  const ReviewCreateScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<ReviewCreateScreen> createState() => _ReviewCreateScreenState();
}

class _ReviewCreateScreenState extends State<ReviewCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController commentController = TextEditingController();
  bool _isFilter = false;
  var _currentRating = 0.0;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final token = (authProvider.token != null && !authProvider.token.isEmpty) ? authProvider.token : Constants.token;
    final tokenRefresh = (authProvider.tokenRefresh != null && !authProvider.tokenRefresh.isEmpty) ? authProvider.tokenRefresh : Constants.tokenRefresh;
    final postProvider = Provider.of<PostProvider>(context);
    final post = Get.arguments?['post'];
    final size = MediaQuery.of(context).size;
    final topHeight = MediaQuery.of(context).viewPadding.top;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_isFilter) {
        try {
          http.Response responsePost = await retrievePost(token, tokenRefresh, id: post);
          var bodyPost = json.decode(utf8.decode(responsePost.bodyBytes));

          postProvider.post = bodyPost;
          _currentRating = postProvider.post['reviews'].length > 0 ? (postProvider.post['reviews'].fold<dynamic>(0, (sum, item) => sum + num.tryParse(item['rating'].toString())?.toDouble()) / postProvider.post['reviews'].length).toDouble() : 0.0;
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
                          child: Text(postProvider.post['title'],
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
                  child: Text("Donnez votre avis".tr,
                    textAlign: TextAlign.justify,
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
                            RatingBar.builder(
                              initialRating: _currentRating,
                              minRating: 0,
                              maxRating: 5,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 38.0,
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                setState(() {
                                  _currentRating = rating;
                                });
                              },
                            ),
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: commentController,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Veuillez entrer votre commentaire'.tr;
                                }
                                return null;
                              },
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                                hintText: "Entrer le commentaire *".tr,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate() && _currentRating > 0.0) {
                                        try {
                                          http.Response responseReview = await createReview(token, tokenRefresh, post: postProvider.post['id'], rating: _currentRating, comment: commentController.text);
                                          var bodyReview = json.decode(utf8.decode(responseReview.bodyBytes));
                                          switch (responseReview.statusCode) {
                                            case 201:
                                              Flushbar(
                                                icon: Icon(
                                                  Icons.info_outline,
                                                  size: 28.0,
                                                  color: Colors.blue,
                                                ),
                                                duration: Duration(seconds: 3),
                                                leftBarIndicatorColor: Colors.blue,
                                                flushbarPosition: FlushbarPosition.TOP,
                                                title: 'Avis'.tr,
                                                message: "La soumission de l'avis a été effectué",
                                              )..show(context);
                                              await Future.delayed(const Duration(seconds: 3));
                                              Get.toNamed(Routes.menu);
                                              break;
                                            case 404:
                                              Flushbar(
                                                icon: Icon(
                                                  Icons.info_outline,
                                                  size: 28.0,
                                                  color: Colors.blue,
                                                ),
                                                duration: Duration(seconds: 3),
                                                leftBarIndicatorColor: Colors.blue,
                                                flushbarPosition: FlushbarPosition.TOP,
                                                title: 'Avis'.tr,
                                                message: "Un avis à déjà été donné pour cette offre",
                                              )..show(context);
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
                                                title: 'Avis'.tr,
                                                message: "Une erreur a été rencontrée lors de la soumission de l'avis",
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
                                            title: 'Avis'.tr,
                                            message:  e.toString(),
                                          )..show(context);
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
                                          title: 'Avis'.tr,
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
                                      "Soumettre".tr,
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
                                SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                                Container(
                                  width: size.width,
                                  padding: const EdgeInsets.only(left: 15, right: 15),
                                  decoration: BoxDecoration(
                                  ),
                                  child: Text(
                                    'Avis sur'.tr + ' ${postProvider.post['title']}',
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: ColorExtension.toColor('#000000'),
                                    ),
                                  ),
                                ),
                                Container( 
                                  padding: const EdgeInsets.only(top: 10, left: 15),
                                  child: Column( 
                                    children: <Widget>[
                                      if (postProvider.post['reviews'].length > 0) ...[
                                        for (int index = 0; index < postProvider.post['reviews'].length; index++) Container(
                                          padding: const EdgeInsets.only(bottom: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              RatingBarIndicator(
                                                rating: num.tryParse(postProvider.post['reviews'][index]['rating'].toString())!.toDouble(),
                                                direction: Axis.horizontal,
                                                itemCount: 5,
                                                itemSize: 16.0,
                                                itemBuilder: (context, index) => Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                              ),
                                              Text(
                                                " ${postProvider.post['reviews'][index]['comment']}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: ColorExtension.toColor('#000000'),
                                                ),
                                              ),
                                            ], 
                                          ),
                                        ),
                                      ] else ...[
                                        Container(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 0, right: 0),
                                                  child: Text(
                                                    "Pas d'avis disponibles...".tr,
                                                    overflow: TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: ColorExtension.toColor('#95989A'),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ], 
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
