import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:another_flushbar/flushbar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:get/get.dart';
// import 'package:address_search_field/address_search_field.dart';

import 'package:bonsplans/configs/routes.dart';
import 'package:bonsplans/utils/colors.dart';
import 'package:bonsplans/utils/api.dart';
import 'package:bonsplans/providers/auth.dart';
import 'package:bonsplans/configs/constants.dart';
import 'package:bonsplans/controllers/post.dart';

import 'package:bonsplans/components/location.dart';

class PostCreateStep5Screen extends StatefulWidget {
  static String id = Routes.post_create_step_5;
  final String title;

  const PostCreateStep5Screen({Key? key, required this.title}) : super(key: key);

  @override
  State<PostCreateStep5Screen> createState() => _PostCreateStep5ScreenState();
}

class _PostCreateStep5ScreenState extends State<PostCreateStep5Screen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController locationController = TextEditingController();
  bool _isFilter = false;
  bool _isSubmit = false;
  List<dynamic> configUsers = [];
  /* final geoMethods = GeoMethods(
    googleApiKey: Constants.googleAPiKey,
    language: 'fr',
  ); */

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final token = (authProvider.token != null && !authProvider.token.isEmpty) ? authProvider.token : Constants.token;
    final tokenRefresh = (authProvider.tokenRefresh != null && !authProvider.tokenRefresh.isEmpty) ? authProvider.tokenRefresh : Constants.tokenRefresh;
    final postController = Get.put(PostController());
    final size = MediaQuery.of(context).size;
    final topHeight = MediaQuery.of(context).viewPadding.top;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_isFilter) {
        try {
          postController.post = {...postController.post, 'price': postController.post['price'] != '' ? postController.post['price'] : 0.0, 'promotion': postController.post['promotion'] != '' ? postController.post['promotion'] : 0, 'location': '', 'latitude': 0.0, 'longitude': 0.0,};
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
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                  margin: EdgeInsets.only(top: 10),
                  child: Text("Identifiez la localisation".tr,
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
                              controller: locationController,
                              /* onTap: () => showDialog(
                                context: context,
                                builder: (BuildContext context) => AddressSearchDialog(
                                  geoMethods: geoMethods,
                                  controller: locationController,
                                  onDone: (Address address) {
                                    print('tototototototo latitude ${address.coords!.latitude}');
                                    print('tototototototo longitude ${address.coords!.longitude}');
                                  },
                                ),
                              ), */
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Veuillez entrer la localisation'.tr;
                                }
                                return null;
                              },
                              onChanged: (value) async {
                                if (value.length >= 3 || value.length == 0) {
                                  http.Response responseConfigUsers = await listConfigUsers(token, tokenRefresh, search: value);
                                  var bodyConfigUsers = json.decode(utf8.decode(responseConfigUsers.bodyBytes));
                                  setState(() {
                                    configUsers = bodyConfigUsers;
                                  });
                                }
                              },
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                                hintText: "Localisation".tr,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(top: 0, left: 5, right: 0, bottom: 1),
                                  child: Icon(FontAwesomeIcons.mapMarker,),
                                ),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            for (int index = 0; index < configUsers.length; index++) GestureDetector(
                              onTap: () {
                                setState(() {
                                  locationController.text = configUsers[index]['display_name'];
                                  postController.post = {...postController.post, 'location': configUsers[index]['display_name'], 'latitude': configUsers[index]['lat'], 'longitude': configUsers[index]['lon'],};
                                });
                              },
                              child: LocationList(item: new Location(num.tryParse(configUsers[index]['place_id'].toString())!.toInt(), configUsers[index]['display_name'], num.tryParse(configUsers[index]['lat'].toString())!.toDouble(), num.tryParse(configUsers[index]['lon'].toString())!.toDouble()))),
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (!_isSubmit) {
                                        setState(() {
                                          _isSubmit = true;
                                        });
                                        if (locationController.text == null || locationController.text.trim().isEmpty) {
                                          postController.post['location'] = '';
                                          postController.post['latitude'] = 0.0;
                                          postController.post['longitude'] = 0.0;
                                        }

                                        try {
                                          http.Response responsePost = await createPost(token, tokenRefresh, category: postController.post['category'], title: postController.post['title'], price: num.tryParse(postController.post['price'].toString())!.toDouble(), promotion: num.tryParse(postController.post['promotion'].toString())!.toInt(), content: postController.post['content'], url: postController.post['url'], phone: postController.post['phone'], service: postController.post['service'], condition: postController.post['condition'], location: postController.post['location'], latitude: num.tryParse(postController.post['latitude'].toString())!.toDouble(), longitude: num.tryParse(postController.post['longitude'].toString())!.toDouble());
                                          var bodyPost = json.decode(utf8.decode(responsePost.bodyBytes));
                                          if (responsePost.statusCode == 201) {
                                            for (int index = 0; index < postController.post['files'].length; index++) {
                                              http.Response responsePhoto = await createPhoto(token, tokenRefresh, postController.post['files'][index], post: bodyPost['id']);
                                              var bodyPhoto = json.decode(utf8.decode(responsePhoto.bodyBytes));
                                            }
                                          }
                                          switch (responsePost.statusCode) {
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
                                                title: 'Publier une offre'.tr,
                                                message: "La création de l'offre a été effectué",
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
                                                title: 'Publier une offre'.tr,
                                                message: "Une erreur a été rencontrée lors de la création de l'offre",
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
                                            title: 'Publier une offre'.tr,
                                            message:  e.toString(),
                                          )..show(context);
                                        }
                                        setState(() {
                                          _isSubmit = false;
                                        });
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
                                      _isSubmit ? "Publier...".tr : "Publier".tr,
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
