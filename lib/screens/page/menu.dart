import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:location/location.dart' as locat;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:bonsplans/configs/routes.dart';
import 'package:bonsplans/utils/colors.dart';
import 'package:bonsplans/controllers/login.dart';
import 'package:bonsplans/controllers/location.dart';
import 'package:bonsplans/utils/gps.dart';
import 'package:bonsplans/utils/dialog.dart';
import 'package:bonsplans/utils/api.dart';
import 'package:bonsplans/utils/notification.dart';
import 'package:bonsplans/providers/auth.dart';
import 'package:bonsplans/configs/constants.dart';

import 'package:bonsplans/screens/page/home.dart';
import 'package:bonsplans/screens/category/list.dart';
import 'package:bonsplans/screens/favorite/list.dart';
import 'package:bonsplans/screens/page/account.dart';
import 'package:bonsplans/screens/notification/list.dart';
import 'package:bonsplans/utils/locales.dart';

class MenuScreen extends StatefulWidget {
  static String id = Routes.menu;
  final String title;

  const MenuScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class MenuItem {
  const MenuItem(this.iconData, this.text);
  final IconData iconData;
  final String text;
}

class _MenuScreenState extends State<MenuScreen> {
  final storage = new FlutterSecureStorage();
  // final locat.Location location = new locat.Location();
  final firebaseMessaging = FCM();
  bool _isFilter = false;
  String tokenFirebase = '';
  bool _isPermission = false;
  int _selectedIndex = 0;
  /* Map<String, dynamic> _isEnabled = {
    'isNotificationEnabled': null,
    'isLocationEnabled': null,
  }; */
  Map<String, dynamic> _isEnabled = {
    'isNotificationEnabled': null,
    'isLocationEnabled': true,
  };

  NotificationService notificationService = NotificationService();

  _changeMessage(RemoteMessage message) {
    print('totototototo message: ${message}');
    notificationService.showLocalNotification(message);
  }

  _changeData(dynamic data) {
    print('totototototo data: ${data}');
  }

  _changeNotification(dynamic notification) {
    print('totototototo notification: ${notification}');
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final token = (authProvider.token != null && !authProvider.token.isEmpty) ? authProvider.token : Constants.token;
    final tokenRefresh = (authProvider.tokenRefresh != null && !authProvider.tokenRefresh.isEmpty) ? authProvider.tokenRefresh : Constants.tokenRefresh;
    final loginControl = Get.put(LoginController());
    final locationControl = Get.put(LocationController());
    final item = Get.arguments?['index'];

    final menuItemList = <MenuItem>[
      MenuItem(FontAwesomeIcons.house, 'Accueil'.tr),
      MenuItem(FontAwesomeIcons.list, 'Catégories'.tr),
      MenuItem(FontAwesomeIcons.bell, 'Notifications'.tr),
      MenuItem(FontAwesomeIcons.heart, 'Favoris'.tr),
      MenuItem(FontAwesomeIcons.user, 'Mon compte'.tr),
    ];

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    final _buildBody = <Widget>[
      HomeScreen(title: 'Accueil | Priloco'),
      CategoryListScreen(title: 'Catégories | Priloco'),
      NotificationListScreen(title: 'Notifications | Priloco'),
      FavoriteListScreen(title: 'Favoris | Priloco'),
      AccountScreen(title: 'Mon compte | Priloco', functionCallback: (index) {
        _onItemTapped(index);
      }),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String? storageLocale = await storage.read(key: 'locale');
      String? storageEnabled = await storage.read(key: 'enabled');
      String? storageAccess = await storage.read(key: 'access');
      String? storageRefresh = await storage.read(key: 'refresh');
      String? storageIntro = await storage.read(key: 'intro');

      if (storageIntro == null) {
        Get.offAndToNamed(Routes.intro);
      } else {
        if (!_isFilter) {
          try {
            if (token.isEmpty) {
              if (storageAccess != null) {
                http.Response responseVerifyUser = await verifyUser(storageAccess!, storageRefresh!);
                var bodyVerifyUser = json.decode(utf8.decode(responseVerifyUser.bodyBytes));

                if (responseVerifyUser.statusCode == 200) {
                  http.Response responseUser = await retrieveUser(storageAccess!, storageRefresh!);
                  var bodyUser = json.decode(utf8.decode(responseUser.bodyBytes));

                  authProvider.data = bodyUser;
                  authProvider.token = storageAccess!;
                  authProvider.tokenRefresh = storageRefresh!;
                  loginControl.authenticated = true;
                  loginControl.role = bodyUser['role'];
                  if (authProvider.data['configuser'] != null) {
                    locationControl.time = num.tryParse(authProvider.data['configuser']['time'].toString())!.toInt();
                    locationControl.distance = num.tryParse(authProvider.data['configuser']['distance'].toString())!.toInt();
                    locationControl.unit = num.tryParse(authProvider.data['configuser']['unit'].toString())!.toInt();
                  }
                } else if (responseVerifyUser.statusCode == 401) {
                  if (bodyVerifyUser.containsKey('code') && bodyVerifyUser['code'] == 'token_not_valid') {
                    http.Response responseRefreshUser = await refreshUser(storageAccess!, storageRefresh!);
                    var bodyRefreshUser = json.decode(utf8.decode(responseRefreshUser.bodyBytes));

                    if (responseRefreshUser.statusCode == 200) {
                      http.Response responseUser = await retrieveUser(bodyRefreshUser['access'], storageRefresh!);
                      var bodyUser = json.decode(utf8.decode(responseUser.bodyBytes));

                      await storage.write(key: 'access', value: bodyRefreshUser['access']);
                      await storage.write(key: 'refresh', value: storageRefresh!);

                      authProvider.data = bodyUser;
                      authProvider.token = bodyRefreshUser['access'];
                      authProvider.tokenRefresh = storageRefresh!;
                      loginControl.authenticated = true;
                      loginControl.role = bodyUser['role'];
                      if (authProvider.data['configuser'] != null) {
                        locationControl.time = num.tryParse(authProvider.data['configuser']['time'].toString())!.toInt();
                        locationControl.distance = num.tryParse(authProvider.data['configuser']['distance'].toString())!.toInt();
                        locationControl.unit = num.tryParse(authProvider.data['configuser']['unit'].toString())!.toInt();
                      }
                    }
                  }
                }
              }
            } else {
              if (storageAccess == null) {
                authProvider.data = {};
                authProvider.token = '';
                authProvider.tokenRefresh = '';
                loginControl.authenticated = false;
                loginControl.role = 3;
                /* locationControl.location = '';
                locationControl.latitude = 0;
                locationControl.longitude = 0;
                locationControl.distance = Constants.distance;
                locationControl.unit = Constants.defaultUnit; */
              } else {
                http.Response responseVerifyUser = await verifyUser(token, tokenRefresh);
                var bodyVerifyUser = json.decode(utf8.decode(responseVerifyUser.bodyBytes));

                if (responseVerifyUser.statusCode == 200) {
                  http.Response responseUser = await retrieveUser(token, tokenRefresh);
                  var bodyUser = json.decode(utf8.decode(responseUser.bodyBytes));

                  authProvider.data = bodyUser;
                  authProvider.token = token;
                  authProvider.tokenRefresh = tokenRefresh;
                  loginControl.authenticated = true;
                  loginControl.role = bodyUser['role'];
                  if (authProvider.data['configuser'] != null) {
                    locationControl.time = num.tryParse(authProvider.data['configuser']['time'].toString())!.toInt();
                    locationControl.distance = num.tryParse(authProvider.data['configuser']['distance'].toString())!.toInt();
                    locationControl.unit = num.tryParse(authProvider.data['configuser']['unit'].toString())!.toInt();
                  }
                } else if (responseVerifyUser.statusCode == 401) {
                  if (bodyVerifyUser.containsKey('code') && bodyVerifyUser['code'] == 'token_not_valid') {
                    http.Response responseRefreshUser = await refreshUser(token, tokenRefresh);
                    var bodyRefreshUser = json.decode(utf8.decode(responseRefreshUser.bodyBytes));

                    if (responseRefreshUser.statusCode == 200) {
                      http.Response responseUser = await retrieveUser(bodyRefreshUser['access'], tokenRefresh);
                      var bodyUser = json.decode(utf8.decode(responseUser.bodyBytes));

                      await storage.write(key: 'access', value: bodyRefreshUser['access']);
                      await storage.write(key: 'refresh', value: tokenRefresh);

                      authProvider.data = bodyUser;
                      authProvider.token = bodyRefreshUser['access'];
                      authProvider.tokenRefresh = tokenRefresh;
                      loginControl.authenticated = true;
                      loginControl.role = bodyUser['role'];
                      if (authProvider.data['configuser'] != null) {
                        locationControl.time = num.tryParse(authProvider.data['configuser']['time'].toString())!.toInt();
                        locationControl.distance = num.tryParse(authProvider.data['configuser']['distance'].toString())!.toInt();
                        locationControl.unit = num.tryParse(authProvider.data['configuser']['unit'].toString())!.toInt();
                      }
                    }
                  }
                }
              }
            }

            if (storageLocale != null) {
              await updateLocale(storageLocale);
            } else {
              await storage.write(key: 'locale', value: Constants.locales[0]);
              await updateLocale(Constants.locales[0]);
            }

            if (item != null) {
              _selectedIndex = item;
            }

            if (storageEnabled != null) {
              _isEnabled = jsonDecode(storageEnabled!) as Map<String, dynamic>;
            }

            _isFilter = true;

            if (_isEnabled['isNotificationEnabled'] == null || _isEnabled['isLocationEnabled'] == null) {
              if (_isEnabled['isNotificationEnabled'] == null) {
                // PermissionStatus status = await Permission.notification.request();
                // _isEnabled['isNotificationEnabled'] = status.isGranted;
                await showPermissionNotification(context, (permission) {
                  _isEnabled['isNotificationEnabled'] = permission;
                });
              }

              if (_isEnabled['isLocationEnabled'] == null) {
                await showPermissionLocation(context, (permission) {
                  _isEnabled['isLocationEnabled'] = permission;
                });
              }

              await storage.write(key: 'enabled', value: jsonEncode(_isEnabled));
            }

            if (!Platform.isIOS) {
              await notificationService.initializePlatformNotifications();

              if (_isEnabled['isNotificationEnabled'] != null && _isEnabled['isLocationEnabled'] != null) {
                if (_isEnabled['isNotificationEnabled'] == true) {
                  await firebaseMessaging.subscribeToTopic('priloco-newpost');
                  firebaseMessaging.messageCtlr.stream.listen(_changeMessage);
                  firebaseMessaging.dataCtlr.stream.listen(_changeData);
                  firebaseMessaging.notificationCtlr.stream.listen(_changeNotification);
                  tokenFirebase = await firebaseMessaging.getToken();
                  print('totototototo tokenFirebase: ${tokenFirebase}');
                }

                /* location.changeSettings(
                  accuracy: locat.LocationAccuracy.high,
                  interval: locationControl.time * 1000,
                  distanceFilter: 5
                );

                // location.enableBackgroundMode(enable: true);

                location.onLocationChanged.listen((locat.LocationData currentPosition) async {
                  if (currentPosition != null) {
                  }
                }); */

                if (_isEnabled['isLocationEnabled'] == true) {
                  _isPermission = await checkPermission();
                  print('totototototo _isPermission: ${_isPermission}');
                }

                if (_isPermission) {
                  Position? currentPosition = await getCurrentPosition();
                  http.Response responseConfigUser = await retrieveConfigUser(token, tokenRefresh, latitude:currentPosition.latitude!, longitude:currentPosition.longitude!);
                  if (responseConfigUser.statusCode == 200) {
                    var bodyConfigUser = json.decode(utf8.decode(responseConfigUser.bodyBytes));

                    if (loginControl.authenticated) {
                      http.Response responseUser = await retrieveUser(token, tokenRefresh);
                      var bodyUser = json.decode(utf8.decode(responseUser.bodyBytes));
                      authProvider.data = bodyUser;

                      if (num.tryParse(bodyConfigUser['latitude'].toString())!.toDouble() != 0.0 && num.tryParse(bodyConfigUser['longitude'].toString())!.toDouble() != 0.0) {
                        locationControl.location = bodyConfigUser['location'];
                        locationControl.latitude = num.tryParse(bodyConfigUser['latitude'].toString())!.toDouble();
                        locationControl.longitude = num.tryParse(bodyConfigUser['longitude'].toString())!.toDouble();
                      }
                      if (authProvider.data['configuser'] != null) {
                        locationControl.time = num.tryParse(authProvider.data['configuser']['time'].toString())!.toInt();
                        locationControl.distance = num.tryParse(authProvider.data['configuser']['distance'].toString())!.toInt();
                        locationControl.unit = num.tryParse(authProvider.data['configuser']['unit'].toString())!.toInt();
                      }
                    } else {
                      if (num.tryParse(bodyConfigUser['latitude'].toString())!.toDouble() != 0.0 && num.tryParse(bodyConfigUser['longitude'].toString())!.toDouble() != 0.0) {
                        locationControl.location = bodyConfigUser['location'];
                        locationControl.latitude = num.tryParse(bodyConfigUser['latitude'].toString())!.toDouble();
                        locationControl.longitude = num.tryParse(bodyConfigUser['longitude'].toString())!.toDouble();
                      }
                    }
                  }
                }
              }
            }
          } on Exception catch (e, s) {
            print('totototototo exception: ${e.toString()}');
          }

          print('totototototo authenticated: ${loginControl.authenticated}');

          if (loginControl.authenticated && authProvider.data['email'] == null) {
            setState(() {
              _isFilter = false;
            });
          } else {
            setState(() {
              _isFilter = true;
            });
          }
        }
      }
    });

    return Scaffold(
      // appBar: AppBar(
        // title: Text(widget.title),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        items: menuItemList.map((MenuItem menuItem) => BottomNavigationBarItem(
          icon: Icon(menuItem.iconData),
          label: menuItem.text,
          backgroundColor: ColorExtension.toColor('#FFFFFF'),
        )).toList(),
        showUnselectedLabels: true,
        elevation: 0.0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: ColorExtension.toColor('#FF914D'),
        unselectedItemColor: ColorExtension.toColor('#95989A'),
        selectedFontSize: 11,
        unselectedFontSize: 11,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: _buildBody.elementAt(_selectedIndex),
    );
  }
}
