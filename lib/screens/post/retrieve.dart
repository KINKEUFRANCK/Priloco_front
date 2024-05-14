import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:map_launcher/map_launcher.dart' as launcher;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:bonsplans/configs/routes.dart';
import 'package:bonsplans/utils/colors.dart';
import 'package:bonsplans/utils/dialog.dart';
import 'package:bonsplans/utils/api.dart';
import 'package:bonsplans/providers/auth.dart';
import 'package:bonsplans/providers/post.dart';
import 'package:bonsplans/providers/favorite.dart';
import 'package:bonsplans/configs/constants.dart';
import 'package:bonsplans/controllers/login.dart';
import 'package:bonsplans/controllers/location.dart';
import 'package:bonsplans/utils/url.dart';
import 'package:bonsplans/utils/google_map.dart';

import 'package:bonsplans/components/post.dart';
import 'package:bonsplans/components/map.dart';
import 'package:bonsplans/components/overlay.dart';

class PostRetrieveScreen extends StatefulWidget {
  static String id = Routes.post_retrieve;
  final String title;

  const PostRetrieveScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<PostRetrieveScreen> createState() => _PostRetrieveScreenState();
}

class _PostRetrieveScreenState extends State<PostRetrieveScreen> {
  final Completer<GoogleMapController> controllerGoogleMap = Completer<GoogleMapController>();
  ScrollController scrollController = new ScrollController();
  bool _isFilter = false;
  bool _isFavorite = false;
  final Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  int? _isPost = null;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final token = (authProvider.token != null && !authProvider.token.isEmpty) ? authProvider.token : Constants.token;
    final tokenRefresh = (authProvider.tokenRefresh != null && !authProvider.tokenRefresh.isEmpty) ? authProvider.tokenRefresh : Constants.tokenRefresh;
    final postProvider = Provider.of<PostProvider>(context);
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final loginControl = Get.put(LoginController());
    final post = _isPost != null ? _isPost : Get.arguments?['post'];
    final locationControl = Get.put(LocationController());
    final size = MediaQuery.of(context).size;
    final topHeight = MediaQuery.of(context).viewPadding.top;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_isFilter) {
        try {
          if (!_isFavorite) {
            Loader.appLoader.showLoader();
          }

          http.Response responsePost = await retrievePost(token, tokenRefresh, id: post);
          var bodyPost = json.decode(utf8.decode(responsePost.bodyBytes));

          http.Response responsePosts = await listPosts(token, tokenRefresh, distance: locationControl.distance, unit: locationControl.unit, latitude: locationControl.latitude, longitude: locationControl.longitude, category: bodyPost['categories'][0], authenticated: loginControl.authenticated);
          var bodyPosts = json.decode(utf8.decode(responsePosts.bodyBytes));

          if (loginControl.authenticated) {
            http.Response responseFavorites = await listFavorites(token, tokenRefresh);
            var bodyFavorites = json.decode(utf8.decode(responseFavorites.bodyBytes));

            if (Platform.isAndroid) {
              try {
                CameraPosition cameraPosition = CameraPosition(
                  target: LatLng(postProvider.post['latitude'], postProvider.post['longitude']),
                  zoom: 14,
                );
                await goToTheCameraPosition(controllerGoogleMap, cameraPosition);

                PolylineResult result = await createPolylineResult(locationControl.latitude, locationControl.longitude, postProvider.post['latitude']!, postProvider.post['longitude']!);

                if (result.points.isNotEmpty) {
                  result.points.forEach((PointLatLng point) {
                    polylineCoordinates.add(LatLng(point.latitude, point.longitude));
                  });
                }

                Polyline polyline = Polyline(
                  polylineId: PolylineId('polyline (lat_1!, lon_1!)'),
                  points: polylineCoordinates,
                  color: ColorExtension.toColor('#d82e2f'),
                  width: 3,
                );

                postProvider.post = bodyPost;
                postProvider.similar_posts = bodyPosts['results'];
                favoriteProvider.favorites = bodyFavorites;
                polylines.add(polyline);
              } on Exception catch (e, s) {
                print('totototototo exception: ${e.toString()}');

                postProvider.post = bodyPost;
                postProvider.similar_posts = bodyPosts['results'];
                favoriteProvider.favorites = bodyFavorites;
              }
            } else if (Platform.isIOS) {
            }
          } else {
            if (Platform.isAndroid) {
              try {
                CameraPosition cameraPosition = CameraPosition(
                  target: LatLng(postProvider.post['latitude'], postProvider.post['longitude']),
                  zoom: 14,
                );

                await goToTheCameraPosition(controllerGoogleMap, cameraPosition);

                PolylineResult result = await createPolylineResult(locationControl.latitude, locationControl.longitude, postProvider.post['latitude']!, postProvider.post['longitude']!);

                if (result.points.isNotEmpty) {
                  result.points.forEach((PointLatLng point) {
                    polylineCoordinates.add(LatLng(point.latitude, point.longitude));
                  });
                }

                Polyline polyline = Polyline(
                  polylineId: PolylineId('polyline (lat_1!, lon_1!)'),
                  points: polylineCoordinates,
                  color: ColorExtension.toColor('#d82e2f'),
                  width: 3,
                );

                postProvider.post = bodyPost;
                postProvider.similar_posts = bodyPosts['results'];
                polylines.add(polyline);
              } on Exception catch (e, s) {
                print('totototototo exception: ${e.toString()}');

                postProvider.post = bodyPost;
                postProvider.similar_posts = bodyPosts['results'];
              }
            } else if (Platform.isIOS) {
            }
          }

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
                        child: Align(
                          alignment: Alignment.center,
                          child: IconButton(
                            iconSize: 24.0,
                            color: ColorExtension.toColor('#FF914D'),
                            onPressed: () async {
                              var showOption = '';
                              await showPostOptions(context, (loginControl.authenticated && loginControl.role < 3), (opt) {
                                showOption = opt;
                              });

                              if (showOption == 'update') {
                                Get.toNamed(Routes.post_update_step_1, arguments: {'post': postProvider.post['id']},);
                              } else if (showOption == 'share') {
                                PackageInfo packageInfo = await PackageInfo.fromPlatform();
                                var packageName = packageInfo.packageName;

                                launcherUrl(packageName, type: 'app');
                              } else if (showOption == 'destroy') {
                                var confirmDestroy = false;
                                await confirmDestroyPost(context, (opt) {
                                  confirmDestroy = opt;
                                });

                                if (confirmDestroy == true) {
                                  http.Response responsePost = await destroyPost(token, tokenRefresh, id: post);
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
                                        title: 'Supprimer une offre'.tr,
                                        message: "La suppression de l'offre a été effectué",
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
                                        title: 'Supprimer une offre'.tr,
                                        message: "Une erreur a été rencontrée lors de la suppression de l'offre",
                                      )..show(context);
                                      break;
                                  }
                                }
                              }
                            },
                            icon: Icon(
                              FontAwesomeIcons.gear,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: size.width,
                            padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                            margin: EdgeInsets.only(top: 10),
                            child: Text("A propos de ce deal".tr,
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
                                PostRetrieve(item: new Post(postProvider.post['id'], postProvider.post['title'], postProvider.post['content'], postProvider.post['phone'], postProvider.post['service'], postProvider.post['condition'], postProvider.post['location'], num.tryParse(postProvider.post['price'].toString())?.toDouble(), postProvider.post['currency'], postProvider.post['promotion'], postProvider.post['photos'], postProvider.post['view'], postProvider.post['reviews']), functionCallback: (favorite) {
                                  if (favorite != null) {
                                    if (favorite['action'] == 1) {
                                      favoriteProvider.favorites.add(favorite);
                                    } else {
                                      favoriteProvider.favorites.removeWhere((item) => item['post'] == favorite['post']);
                                    }
                                  }
                                  setState(() {
                                    _isFilter = false;
                                    _isFavorite = true;
                                  });
                                }),
                                if (kIsWeb) ...[
                                ] else ...[
                                  if (Platform.isIOS || Platform.isAndroid) ...[
                                    SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                                    SizedBox(
                                      height: size.height * 0.25,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 15, right: 15),
                                        child: MapLocation(item: new MapPosition(locationControl.latitude, locationControl.longitude, postProvider.post['latitude'], postProvider.post['longitude'], controllerGoogleMap), polylines: polylines),
                                      ),
                                    ),
                                  ] else ...[
                                  ]
                                ],
                                SizedBox(height: size.height * 0.03, width: size.width * 0.08),
                                Container(
                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          icon: Icon(
                                            FontAwesomeIcons.car,
                                            size: 24.0,
                                            color: ColorExtension.toColor('#FFFFFF'),
                                          ),
                                          onPressed: () async {
                                            if (Platform.isAndroid) {
                                              double miny = (locationControl.latitude <= postProvider.post['latitude']) ? locationControl.latitude : postProvider.post['latitude'];
                                              double minx = (locationControl.longitude <= postProvider.post['longitude']) ? locationControl.longitude : postProvider.post['longitude'];
                                              double maxy = (locationControl.latitude <= postProvider.post['latitude']) ? postProvider.post['latitude'] : locationControl.latitude;
                                              double maxx = (locationControl.longitude <= postProvider.post['longitude']) ? postProvider.post['longitude'] : locationControl.longitude;

                                              double southWestLatitude = miny;
                                              double southWestLongitude = minx;
                                              double northEastLatitude = maxy;
                                              double northEastLongitude = maxx;
                                              LatLngBounds latLngBounds = LatLngBounds(
                                                northeast: LatLng(northEastLatitude, northEastLongitude),
                                                southwest: LatLng(southWestLatitude, southWestLongitude),
                                              );

                                              await scrollController.animateTo(
                                                scrollController.position.maxScrollExtent,
                                                duration: Duration(seconds: 1),
                                                curve: Curves.fastOutSlowIn,
                                              );

                                              // await goToTheLatLngBounds(controllerGoogleMap, latLngBounds);

                                              launcher.Coords coords = launcher.Coords(postProvider.post['latitude'], postProvider.post['longitude']);
                                              await launcherGoogleMapShowDirections(coords, postProvider.post['title']);
                                            } else if (Platform.isIOS) {
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            elevation: 1.0,
                                            backgroundColor: ColorExtension.toColor('#FF914D'),
                                            shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20)),
                                            padding: const EdgeInsets.only(left: 14, right: 14, top: 14, bottom: 14)
                                          ),
                                          label: Text(
                                            "Aller".tr,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: ColorExtension.toColor('#FFFFFF'),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: size.width * 0.03),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          icon: Icon(
                                            FontAwesomeIcons.externalLink,
                                            size: 24.0,
                                            color: ColorExtension.toColor('#FFFFFF'),
                                          ),
                                          onPressed: () async { launcherUrl(postProvider.post['url']); },
                                          style: ElevatedButton.styleFrom(
                                            elevation: 1.0,
                                            backgroundColor: ColorExtension.toColor('#FF914D'),
                                            shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20)),
                                            padding: const EdgeInsets.only(left: 14, right: 14, top: 14, bottom: 14)
                                          ),
                                          label: Text(
                                            "Voir".tr,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: ColorExtension.toColor('#FFFFFF'),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (postProvider.post['phone'] != null && !postProvider.post['phone'].trim().isEmpty) ...[
                                        SizedBox(width: size.width * 0.03),
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            icon: Icon(
                                              FontAwesomeIcons.phone,
                                              size: 24.0,
                                              color: ColorExtension.toColor('#FFFFFF'),
                                            ),
                                            onPressed: () async { launcherUrl(postProvider.post['phone'], type: 'tel'); },
                                            style: ElevatedButton.styleFrom(
                                              elevation: 1.0,
                                              backgroundColor: ColorExtension.toColor('#FF914D'),
                                              shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20)),
                                              padding: const EdgeInsets.only(left: 14, right: 14, top: 14, bottom: 14)
                                            ),
                                            label: Text(
                                              "Appeler".tr,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: ColorExtension.toColor('#FFFFFF'),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
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
                                Container(
                                  width: size.width,
                                  padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                  ),
                                  child: Text(
                                    "Offres similaires".tr,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: ColorExtension.toColor('#000000'),
                                    ),
                                  ),
                                ),
                                if (postProvider.similar_posts.where((post) => post['id'] != postProvider.post['id']).toList().length > 0) ...[
                                  Container( 
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                      child: CarouselSlider(
                                        options: CarouselOptions(
                                            height: 120.0,
                                            aspectRatio: 2.0,
                                            viewportFraction: 0.4,
                                            initialPage: 0,
                                            enableInfiniteScroll: true,
                                            reverse: false,
                                            autoPlay: false,
                                            autoPlayInterval: Duration(seconds: 2),
                                            autoPlayAnimationDuration: Duration(milliseconds: 800),
                                            autoPlayCurve: Curves.fastOutSlowIn,
                                            enlargeCenterPage: false,
                                            enlargeFactor: 0.3,
                                            scrollDirection: Axis.horizontal,
                                        ),
                                        items: postProvider.similar_posts.where((post) => post['id'] != postProvider.post['id']).toList().map((post) {
                                          return Builder(
                                            builder: (BuildContext context) {
                                              return PostSimilarList(item: new Post(post['id'], post['title'], post['content'], post['phone'], post['service'], post['condition'], post['location'], num.tryParse(post['price'].toString())?.toDouble(), post['currency'], post['promotion'], post['photos'], post['view'], post['reviews']), functionCallback: (post) {
                                                _isPost = post;
                                                setState(() {
                                                  _isFilter = false;
                                                });
                                              });
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ] else ...[
                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 15, right: 15),
                                            child: Text(
                                              "Pas d'offres similaires disponibles...".tr,
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
                            item_2: (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) ? MapLocation(item: new MapPosition(locationControl.latitude, locationControl.longitude, postProvider.post['latitude'], postProvider.post['longitude'], controllerGoogleMap), polylines: polylines) : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      /* floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (Platform.isAndroid) {
            double miny = (locationControl.latitude <= postProvider.post['latitude']) ? locationControl.latitude : postProvider.post['latitude'];
            double minx = (locationControl.longitude <= postProvider.post['longitude']) ? locationControl.longitude : postProvider.post['longitude'];
            double maxy = (locationControl.latitude <= postProvider.post['latitude']) ? postProvider.post['latitude'] : locationControl.latitude;
            double maxx = (locationControl.longitude <= postProvider.post['longitude']) ? postProvider.post['longitude'] : locationControl.longitude;

            double southWestLatitude = miny;
            double southWestLongitude = minx;
            double northEastLatitude = maxy;
            double northEastLongitude = maxx;
            LatLngBounds latLngBounds = LatLngBounds(
              northeast: LatLng(northEastLatitude, northEastLongitude),
              southwest: LatLng(southWestLatitude, southWestLongitude),
            );

            await scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
            );

            await goToTheLatLngBounds(controllerGoogleMap, latLngBounds);

            launcher.Coords coords = launcher.Coords(postProvider.post['latitude'], postProvider.post['longitude']);
            await launcherGoogleMapShowDirections(coords, postProvider.post['title']);
          } else if (Platform.isIOS) {
          }
        },
        label: const Text('Aller'),
        extendedTextStyle: TextStyle(
          fontSize: 14,
        ),
        icon: const Icon(
          FontAwesomeIcons.car,
          size: 24.0,
          color: Colors.grey,
        ),
        foregroundColor: ColorExtension.toColor('#9E9E9E'),
        backgroundColor: ColorExtension.toColor('#FFFFFF'),
      ), */
    );
  }
}
