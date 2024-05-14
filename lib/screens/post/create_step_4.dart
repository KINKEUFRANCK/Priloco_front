import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:bonsplans/configs/routes.dart';
import 'package:bonsplans/utils/colors.dart';
import 'package:bonsplans/utils/file.dart';
import 'package:bonsplans/controllers/post.dart';

import 'package:bonsplans/components/file.dart';

class PostCreateStep4Screen extends StatefulWidget {
  static String id = Routes.post_create_step_4;
  final String title;

  const PostCreateStep4Screen({Key? key, required this.title}) : super(key: key);

  @override
  State<PostCreateStep4Screen> createState() => _PostCreateStep4ScreenState();
}

class _PostCreateStep4ScreenState extends State<PostCreateStep4Screen> {
  final _formKey = GlobalKey<FormState>();
  List<PlatformFile> files = [];

  @override
  Widget build(BuildContext context) {
    final postController = Get.put(PostController());
    final size = MediaQuery.of(context).size;
    final topHeight = MediaQuery.of(context).viewPadding.top;

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
                  child: Text("Téléchargez les photos".tr,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: Icon(
                                      FontAwesomeIcons.image,
                                      size: 24.0,
                                      color: ColorExtension.toColor('#9E9E9E'),
                                    ),
                                    onPressed: () async {
                                      List<PlatformFile> _files = await getFiles();
                                      setState(() {
                                        files = _files;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 1.0,
                                      backgroundColor: ColorExtension.toColor('#FFFFFF'),
                                      shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                      padding: const EdgeInsets.only(left: 20, right: 20, top: 18, bottom: 18)
                                    ),
                                    label: Text(
                                      "Sélectionner les photos".tr,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: ColorExtension.toColor('#9E9E9E'),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            Column(
                              children: [
                                if (kIsWeb) ...[
                                    for (int index = 0; index < files.length; index++) FileList(item: new Fil(index, files[index].name, null, files[index].bytes!, files[index].size, files[index].extension), functionCallback: (file) {
                                      setState(() {
                                        files.removeAt(file);
                                      });
                                    }),
                                ] else ...[
                                  if (Platform.isIOS || Platform.isAndroid) ...[
                                    for (int index = 0; index < files.length; index++) FileList(item: new Fil(index, files[index].name, files[index].path!, null, files[index].size, files[index].extension), functionCallback: (file) {
                                      setState(() {
                                        files.removeAt(file);
                                      });
                                    }),
                                  ] else ...[
                                    for (int index = 0; index < files.length; index++) FileList(item: new Fil(index, files[index].name, null, files[index].bytes!, files[index].size, files[index].extension), functionCallback: (file) {
                                      setState(() {
                                        files.removeAt(file);
                                      });
                                    }),
                                  ]
                                ]
                              ],
                            ),
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      postController.post = {...postController.post, 'files': files,};
                                      Get.toNamed(Routes.post_create_step_5);
                                      /* if (files.length > 0) {
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
                                          title: 'Publier une offre'.tr,
                                          message: 'Veuillez sélectionner les photos'.tr,
                                        )..show(context);
                                      } */
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
