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
import 'package:bonsplans/providers/post.dart';
import 'package:bonsplans/providers/notification.dart';
import 'package:bonsplans/configs/constants.dart';
import 'package:bonsplans/controllers/login.dart';
import 'package:bonsplans/controllers/location.dart';

import 'package:bonsplans/components/notification.dart';
import 'package:bonsplans/components/overlay.dart';

class NotificationListScreen extends StatefulWidget {
  static String id = Routes.notification_list;
  final String title;

  const NotificationListScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  bool _isFilter = false;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final token = (authProvider.token != null && !authProvider.token.isEmpty) ? authProvider.token : Constants.token;
    final tokenRefresh = (authProvider.tokenRefresh != null && !authProvider.tokenRefresh.isEmpty) ? authProvider.tokenRefresh : Constants.tokenRefresh;
    final postProvider = Provider.of<PostProvider>(context);
    final locationControl = Get.put(LocationController());
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final loginControl = Get.put(LoginController());
    final size = MediaQuery.of(context).size;
    final topHeight = MediaQuery.of(context).viewPadding.top;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_isFilter) {
        try {
          if (!_isFavorite) {
            Loader.appLoader.showLoader();
          }

          http.Response responsePosts = await listPosts(token, tokenRefresh, distance: locationControl.distance, unit: locationControl.unit, latitude: locationControl.latitude, longitude: locationControl.longitude, authenticated: loginControl.authenticated);
          var bodyPosts = json.decode(utf8.decode(responsePosts.bodyBytes));

          http.Response responseNotifications = await listNotifications(token, tokenRefresh);
          var bodyNotifications = json.decode(utf8.decode(responseNotifications.bodyBytes));

          postProvider.posts = bodyPosts['results'];
          notificationProvider.notifications = bodyNotifications;

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
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            iconSize: 24.0,
                            color: Colors.transparent,
                            onPressed: () {},
                            icon: Icon(
                              FontAwesomeIcons.arrowLeft,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Notifications".tr,
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
                        child: Align(
                          alignment: Alignment.center,
                          child: IconButton(
                            iconSize: 24.0,
                            color: ColorExtension.toColor('#FF914D'),
                            onPressed: () {},
                            icon: Icon(
                              FontAwesomeIcons.filter,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: size.width,
                    margin: EdgeInsets.only(top: 20),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: OverlayView(
                          item_1: Column(
                            children: <Widget>[
                              if (postProvider.posts.length > 0 && notificationProvider.notifications.length > 0) ...[
                                for (int index = 0; index < notificationProvider.notifications.length; index++) GestureDetector(
                                  child: NotificationList(item: new NotificationItem(notificationProvider.notifications[index]['id'], notificationProvider.notifications[index]['title'], notificationProvider.notifications[index]['description'], notificationProvider.notifications[index]['type'], notificationProvider.notifications[index]['item'])),
                                  onTap: () {
                                    postProvider.post = postProvider.posts.where((post) => post['id'] == notificationProvider.notifications[index]['item']).toList()[0];
                                    Get.toNamed(Routes.post_retrieve, arguments: {'post': postProvider.post['id']},);
                                  },
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
                                                      "Pas de notifications disponibles...".tr,
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
