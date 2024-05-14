import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
// import 'package:location/location.dart' as locat;
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:bonsplans/configs/routes.dart';
import 'package:bonsplans/utils/colors.dart';
import 'package:bonsplans/utils/api.dart';
import 'package:bonsplans/utils/gps.dart';
import 'package:bonsplans/utils/dialog.dart';
import 'package:bonsplans/providers/auth.dart';
import 'package:bonsplans/configs/constants.dart';
import 'package:bonsplans/controllers/login.dart';
import 'package:bonsplans/controllers/location.dart';

import 'package:bonsplans/components/map.dart';

class LocationScreen extends StatefulWidget {
  static String id = Routes.location;
  final String title;

  const LocationScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final storage = new FlutterSecureStorage();
  // final locat.Location location = new locat.Location();
  final Completer<GoogleMapController> controllerGoogleMap = Completer<GoogleMapController>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController locationController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  bool _isFilter = false;
  bool _isSubmit = false;
  final units = [1, 2];
  var _currentTime = Constants.time;
  var _currentUnit = Constants.defaultUnit;
  bool _isPermission = false;
  Map<String, dynamic> _isEnabled = {
    'isNotificationEnabled': null,
    'isLocationEnabled': null,
  };

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final token = (authProvider.token != null && !authProvider.token.isEmpty) ? authProvider.token : Constants.token;
    final tokenRefresh = (authProvider.tokenRefresh != null && !authProvider.tokenRefresh.isEmpty) ? authProvider.tokenRefresh : Constants.tokenRefresh;
    final loginControl = Get.put(LoginController());
    final locationControl = Get.put(LocationController());
    final size = MediaQuery.of(context).size;
    final topHeight = MediaQuery.of(context).viewPadding.top;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_isFilter) {
        try {
          locationController = TextEditingController(text: locationControl.location.toString());
          distanceController = TextEditingController(text: locationControl.distance.toString());
          _currentTime = locationControl.time;
          _currentUnit = locationControl.unit;
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
                          child: Text("Ma localisation",
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            TextFormField(
                              readOnly: true,
                              keyboardType: TextInputType.text,
                              controller: locationController,
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
                                  return units.map((dynamic value) {
                                    return Container(
                                      width: size.width*0.62,
                                      height: 50,
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          Constants.unit[value-1],
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
                                items: units.map<DropdownMenuItem<dynamic>>((dynamic value) {
                                  return DropdownMenuItem<dynamic>(
                                    value: value,
                                    child: Container(
                                      width: size.width*0.62,
                                      height: 50,
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          Constants.unit[value-1],
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
                                  if (authProvider.data['configuser'] != null) {
                                    authProvider.data['configuser']['unit'] = value;
                                    locationControl.unit = authProvider.data['configuser']['unit'];
                                  } else {
                                    locationControl.unit = value;
                                  }
                                  setState(() {
                                    _currentUnit = locationControl.unit;
                                  });
                                },
                                value: _currentUnit,
                              ),
                            ),
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: distanceController,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Veuillez entrer la distance'.tr;
                                }
                                return null;
                              },
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                                hintText: "Distance *",
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(top: 0, left: 5, right: 0, bottom: 1),
                                  child: Icon(FontAwesomeIcons.car,),
                                ),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                            if (kIsWeb) ...[
                            ] else ...[
                              if (Platform.isIOS || Platform.isAndroid) ...[
                                SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                                SizedBox(
                                  height: size.height * 0.25,
                                  child: MapLocation(item: new MapPosition(locationControl.latitude, locationControl.longitude, null, null, controllerGoogleMap), polylines: {}),
                                ),
                              ] else ...[
                              ]
                            ],
                            SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      String? storageEnabled = await storage.read(key: 'enabled');

                                      if (storageEnabled != null) {
                                        _isEnabled = jsonDecode(storageEnabled!) as Map<String, dynamic>;
                                      }

                                      if (_formKey.currentState!.validate()) {
                                        if (!_isSubmit) {
                                          setState(() {
                                            _isSubmit = true;
                                          });
                                          if (_isEnabled['isLocationEnabled'] == null || _isEnabled['isLocationEnabled'] == false) {
                                            await showPermissionLocation(context, (permission) {
                                              _isEnabled['isLocationEnabled'] = permission;
                                            });
                                          }

                                          if (_isEnabled['isLocationEnabled'] != null && _isEnabled['isLocationEnabled'] == true) {
                                            _isPermission = await checkPermission();
                                          }

                                          if (_isEnabled['isLocationEnabled'] != null) {
                                            await storage.write(key: 'enabled', value: jsonEncode(_isEnabled));
                                          }

                                          if (_isPermission) {
                                            Position? currentPosition = await getCurrentPosition();
                                            http.Response responseConfigUser = await retrieveConfigUser(token, tokenRefresh, latitude:currentPosition.latitude!, longitude:currentPosition.longitude!);
                                            if (responseConfigUser.statusCode == 200) {
                                              var bodyConfigUser = json.decode(utf8.decode(responseConfigUser.bodyBytes));

                                              if (loginControl.authenticated) {
                                                try {
                                                  http.Response responseCreateConfigUser = await createConfigUser(token, tokenRefresh, time: _currentTime, distance: num.tryParse(distanceController.text)!.toInt(), unit: _currentUnit);
                                                  var bodyCreateConfigUser = json.decode(utf8.decode(responseCreateConfigUser.bodyBytes));

                                                  http.Response responseUser = await retrieveUser(token, tokenRefresh);
                                                  var bodyUser = json.decode(utf8.decode(responseUser.bodyBytes));

                                                  if (num.tryParse(bodyConfigUser['latitude'].toString())!.toDouble() != 0.0 && num.tryParse(bodyConfigUser['longitude'].toString())!.toDouble() != 0.0) {
                                                    locationControl.location = bodyConfigUser['location'];
                                                    locationControl.latitude = num.tryParse(bodyConfigUser['latitude'].toString())!.toDouble();
                                                    locationControl.longitude = num.tryParse(bodyConfigUser['longitude'].toString())!.toDouble();
                                                  }
                                                  if (bodyUser['configuser'] != null) {
                                                    authProvider.data = bodyUser;
                                                    locationControl.time = num.tryParse(authProvider.data['configuser']['time'].toString())!.toInt();
                                                    locationControl.distance = num.tryParse(authProvider.data['configuser']['distance'].toString())!.toInt();
                                                    locationControl.unit = num.tryParse(authProvider.data['configuser']['unit'].toString())!.toInt();
                                                  } else {
                                                    locationControl.time = _currentTime;
                                                    locationControl.distance = num.tryParse(distanceController.text)!.toInt();
                                                    locationControl.unit = _currentUnit;
                                                  }

                                                  switch (responseCreateConfigUser.statusCode) {
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
                                                        title: 'Localisation',
                                                        message: "L'actualisation de la localisation a été effectué",
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
                                                        title: 'Localisation',
                                                        message: "Une erreur a été rencontrée lors de la localisation",
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
                                                    title: 'Localisation',
                                                    message:  e.toString(),
                                                  )..show(context);
                                                }
                                              } else {
                                                if (num.tryParse(bodyConfigUser['latitude'].toString())!.toDouble() != 0.0 && num.tryParse(bodyConfigUser['longitude'].toString())!.toDouble() != 0.0) {
                                                  locationControl.location = bodyConfigUser['location'];
                                                  locationControl.latitude = num.tryParse(bodyConfigUser['latitude'].toString())!.toDouble();
                                                  locationControl.longitude = num.tryParse(bodyConfigUser['longitude'].toString())!.toDouble();
                                                }
                                                locationControl.time = _currentTime;
                                                locationControl.distance = num.tryParse(distanceController.text)!.toInt();
                                                locationControl.unit = _currentUnit;

                                                Flushbar(
                                                  icon: Icon(
                                                    Icons.info_outline,
                                                    size: 28.0,
                                                    color: Colors.blue,
                                                  ),
                                                  duration: Duration(seconds: 3),
                                                  leftBarIndicatorColor: Colors.blue,
                                                  flushbarPosition: FlushbarPosition.TOP,
                                                  title: 'Localisation',
                                                  message: "L'actualisation de la localisation a été effectué",
                                                )..show(context);
                                              }
                                            }
                                          }
                                          setState(() {
                                            _isFilter = false;
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
                                          title: 'Ma localisation',
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
                                      _isSubmit ? "Actualiser...".tr : "Actualiser",
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
