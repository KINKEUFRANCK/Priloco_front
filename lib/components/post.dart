import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import 'package:bonsplans/utils/colors.dart';
import 'package:bonsplans/utils/api.dart';
import 'package:bonsplans/providers/auth.dart';
import 'package:bonsplans/providers/post.dart';
import 'package:bonsplans/configs/constants.dart';
import 'package:bonsplans/configs/routes.dart';
import 'package:bonsplans/providers/favorite.dart';
import 'package:bonsplans/controllers/login.dart';

class Post { 
   const Post(this.id, this.title, this.content, this.phone, this.service, this.condition, this.location, this.price, this.currency, this.promotion, this.photos, this.view, this.reviews); 
   final int id; 
   final String title; 
   final String content; 
   final String? phone; 
   final String? service; 
   final String? condition; 
   final String? location; 
   final double? price; 
   final int currency; 
   final int? promotion; 
   final List<dynamic> photos; 
   final int view;
   final List<dynamic> reviews; 
}

class PostList extends StatelessWidget {
  final Post item;
  final Function(Map?) functionCallback;
  PostList({Key? key, required this.item, required this.functionCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final token = (authProvider.token != null && !authProvider.token.isEmpty) ? authProvider.token : Constants.token;
    final tokenRefresh = (authProvider.tokenRefresh != null && !authProvider.tokenRefresh.isEmpty) ? authProvider.tokenRefresh : Constants.tokenRefresh;
    final postProvider = Provider.of<PostProvider>(context);
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final loginControl = Get.put(LoginController());

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: ColorExtension.toColor('#EEEEEE'),
            width: 0,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container( 
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
          child: Column( 
            children: <Widget>[ 
              if (this.item.photos.length > 0) ...[
                GestureDetector(
                  onTap: () {
                    postProvider.post = postProvider.posts.where((post) => post['id'] == this.item.id).toList()[0];
                    Get.toNamed(Routes.post_retrieve, arguments: {'post': postProvider.post['id']},);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: CarouselSlider(
                      options: CarouselOptions(
                          height: 160.0,
                          aspectRatio: 2.0,
                          viewportFraction: 0.8,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: false,
                          autoPlayInterval: Duration(seconds: 2),
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.3,
                          scrollDirection: Axis.horizontal,
                      ),
                      items: this.item.photos.map((photo) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container( 
                                height: 160.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage('${Constants.baseUrl}${photo['thumbnail']}'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10, top: 5),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      iconSize: 24.0,
                                      color: ColorExtension.toColor('#9E9E9E'),
                                      onPressed: () async {
                                        if (loginControl.authenticated) {
                                          if (favoriteProvider.favorites.map((favorite) => favorite['post']).toList().contains(this.item.id) == true) {
                                            http.Response responseFavorite = await createFavorite(token, tokenRefresh, post: this.item.id, action: 0);
                                          } else {
                                            http.Response responseFavorite = await createFavorite(token, tokenRefresh, post: this.item.id, action: 1);
                                          }

                                          this.functionCallback(null);
                                        } else {
                                          if (favoriteProvider.favorites.map((favorite) => favorite['post']).toList().contains(this.item.id) == true) {
                                            this.functionCallback({
                                                "post": this.item.id,
                                                "item": this.item,
                                                "action": 0,
                                            });
                                          } else {
                                            this.functionCallback({
                                                "post": this.item.id,
                                                "item": this.item,
                                                "action": 1,
                                            });
                                          }
                                        }
                                      },
                                      icon: favoriteProvider.favorites.map((favorite) => favorite['post']).toList().contains(this.item.id) == true ? Icon(
                                        size: 30.0,
                                        Icons.favorite,
                                        color: ColorExtension.toColor('#d82e2f'),
                                      ) : Icon(
                                        size: 30.0,
                                        Icons.favorite,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
              GestureDetector(
                onTap: () {
                  postProvider.post = postProvider.posts.where((post) => post['id'] == this.item.id).toList()[0];
                  Get.toNamed(Routes.post_retrieve, arguments: {'post': postProvider.post['id']},);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      this.item.title,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ColorExtension.toColor('#000000'),
                      ),
                    ),
                  ),
                ),
              ),
              if (this.item.location != null && this.item.location != '') ...[
                GestureDetector(
                  onTap: () {
                    postProvider.post = postProvider.posts.where((post) => post['id'] == this.item.id).toList()[0];
                    Get.toNamed(Routes.post_retrieve, arguments: {'post': postProvider.post['id']},);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        this.item.location.toString(),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorExtension.toColor('#000000'),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  if (this.item.reviews.length > 0) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 3),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${(this.item.reviews.fold<dynamic>(0, (sum, item) => sum + num.tryParse(item['rating'].toString())?.toDouble()) / this.item.reviews.length).toDouble()}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ColorExtension.toColor('#000000'),
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ColorExtension.toColor('#000000'),
                          ),
                        ),
                      ),
                    ),
                  ],
                  GestureDetector(
                    onTap: () {
                      postProvider.post = postProvider.posts.where((post) => post['id'] == this.item.id).toList()[0];
                      Get.toNamed(Routes.review_create, arguments: {'post': postProvider.post['id']},);
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RatingBarIndicator(
                        rating: this.item.reviews.length > 0 ? (this.item.reviews.fold<dynamic>(0, (sum, item) => sum + num.tryParse(item['rating'].toString())?.toDouble()) / this.item.reviews.length).toDouble() : 0.0,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemSize: 16.0,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ),
                  if (this.item.reviews.length > 0) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${this.item.reviews.length} avis',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ColorExtension.toColor('#000000'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (this.item.promotion != null) ...[
                if (this.item.price != null) ...[
                  GestureDetector(
                    onTap: () {
                      postProvider.post = postProvider.posts.where((post) => post['id'] == this.item.id).toList()[0];
                      Get.toNamed(Routes.post_retrieve, arguments: {'post': postProvider.post['id']},);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          textAlign: TextAlign.left,
                          softWrap: true,
                          text: TextSpan(children: <TextSpan> [
                            TextSpan(
                              text: '${this.item.price.toString()} ${Constants.currency[this.item.currency-1]}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorExtension.toColor('#000000'),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            TextSpan(
                              text: '  à ${(this.item.price! - ((this.item.price! * this.item.promotion!) / 100)).toStringAsFixed(2)} ${Constants.currency[this.item.currency-1]} -${this.item.promotion.toString()}% ' + 'en moins'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorExtension.toColor('#F69723'),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  GestureDetector(
                    onTap: () {
                      postProvider.post = postProvider.posts.where((post) => post['id'] == this.item.id).toList()[0];
                      Get.toNamed(Routes.post_retrieve, arguments: {'post': postProvider.post['id']},);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          textAlign: TextAlign.left,
                          softWrap: true,
                          text: TextSpan(children: <TextSpan> [
                            TextSpan(
                              text: '-${this.item.promotion.toString()}% ' + 'en moins'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorExtension.toColor('#F69723'),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ],
              ] else ...[
                if (this.item.price != null) ...[
                  GestureDetector(
                    onTap: () {
                      postProvider.post = postProvider.posts.where((post) => post['id'] == this.item.id).toList()[0];
                      Get.toNamed(Routes.post_retrieve, arguments: {'post': postProvider.post['id']},);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          textAlign: TextAlign.left,
                          softWrap: true,
                          text: TextSpan(children: <TextSpan> [
                            TextSpan(
                              text: '${this.item.price.toString()} ${Constants.currency[this.item.currency-1]}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorExtension.toColor('#F69723'),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
              GestureDetector(
                onTap: () {
                  postProvider.post = postProvider.posts.where((post) => post['id'] == this.item.id).toList()[0];
                  Get.toNamed(Routes.post_retrieve, arguments: {'post': postProvider.post['id']},);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      this.item.content,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: ColorExtension.toColor('#000000'),
                      ),
                    ),
                  ),
                ),
              ),
            ], 
          ),
        ),
      ),
    ); 
  } 
}

class PostRetrieve extends StatelessWidget {
  final Post item;
  final Function(Map?) functionCallback;
  PostRetrieve({Key? key, required this.item, required this.functionCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final token = (authProvider.token != null && !authProvider.token.isEmpty) ? authProvider.token : Constants.token;
    final tokenRefresh = (authProvider.tokenRefresh != null && !authProvider.tokenRefresh.isEmpty) ? authProvider.tokenRefresh : Constants.tokenRefresh;
    final postProvider = Provider.of<PostProvider>(context);
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final loginControl = Get.put(LoginController());

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: ColorExtension.toColor('#EEEEEE'),
            width: 0,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container( 
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
          child: Column( 
            children: <Widget>[ 
              if (this.item.photos.length > 0) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: CarouselSlider(
                    options: CarouselOptions(
                        height: 160.0,
                        aspectRatio: 2.0,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: false,
                        autoPlayInterval: Duration(seconds: 2),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        enlargeFactor: 0.3,
                        scrollDirection: Axis.horizontal,
                    ),
                    items: this.item.photos.map((photo) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container( 
                            height: 160.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage('${Constants.baseUrl}${photo['thumbnail']}'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10, top: 5),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  iconSize: 24.0,
                                  color: ColorExtension.toColor('#9E9E9E'),
                                  onPressed: () async {
                                    if (loginControl.authenticated) {
                                      if (favoriteProvider.favorites.map((favorite) => favorite['post']).toList().contains(this.item.id) == true) {
                                        http.Response responseFavorite = await createFavorite(token, tokenRefresh, post: this.item.id, action: 0);
                                      } else {
                                        http.Response responseFavorite = await createFavorite(token, tokenRefresh, post: this.item.id, action: 1);
                                      }

                                      this.functionCallback(null);
                                    } else {
                                      if (favoriteProvider.favorites.map((favorite) => favorite['post']).toList().contains(this.item.id) == true) {
                                        this.functionCallback({
                                            "post": this.item.id,
                                            "item": this.item,
                                            "action": 0,
                                        });
                                      } else {
                                        this.functionCallback({
                                            "post": this.item.id,
                                            "item": this.item,
                                            "action": 1,
                                        });
                                      }
                                    }
                                  },
                                  icon: favoriteProvider.favorites.map((favorite) => favorite['post']).toList().contains(this.item.id) == true ? Icon(
                                    size: 30.0,
                                    Icons.favorite,
                                    color: ColorExtension.toColor('#d82e2f'),
                                  ) : Icon(
                                    size: 30.0,
                                    Icons.favorite,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
              SizedBox(height: 5),
              if (this.item.location != null && this.item.location != '') ...[
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      this.item.location.toString(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: ColorExtension.toColor('#000000'),
                      ),
                    ),
                  ),
                ),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  if (this.item.reviews.length > 0) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 3),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${(this.item.reviews.fold<dynamic>(0, (sum, item) => sum + num.tryParse(item['rating'].toString())?.toDouble()) / this.item.reviews.length).toDouble()}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ColorExtension.toColor('#000000'),
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ColorExtension.toColor('#000000'),
                          ),
                        ),
                      ),
                    ),
                  ],
                  GestureDetector(
                    onTap: () {
                      postProvider.post = postProvider.posts.where((post) => post['id'] == this.item.id).toList()[0];
                      Get.toNamed(Routes.review_create, arguments: {'post': postProvider.post['id']},);
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RatingBarIndicator(
                        rating: this.item.reviews.length > 0 ? (this.item.reviews.fold<dynamic>(0, (sum, item) => sum + num.tryParse(item['rating'].toString())?.toDouble()) / this.item.reviews.length).toDouble() : 0.0,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemSize: 16.0,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ),
                  if (this.item.reviews.length > 0) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${this.item.reviews.length} avis',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ColorExtension.toColor('#000000'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (this.item.promotion != null) ...[
                if (this.item.price != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        textAlign: TextAlign.left,
                        softWrap: true,
                        text: TextSpan(children: <TextSpan> [
                          TextSpan(
                            text: '${this.item.price.toString()} ${Constants.currency[this.item.currency-1]}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ColorExtension.toColor('#000000'),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          TextSpan(
                            text: '  à ${(this.item.price! - ((this.item.price! * this.item.promotion!) / 100)).toStringAsFixed(2)} ${Constants.currency[this.item.currency-1]} -${this.item.promotion.toString()}% ' + 'en moins'.tr,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ColorExtension.toColor('#F69723'),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        textAlign: TextAlign.left,
                        softWrap: true,
                        text: TextSpan(children: <TextSpan> [
                          TextSpan(
                            text: '-${this.item.promotion.toString()}% ' + 'en moins'.tr,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ColorExtension.toColor('#F69723'),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ],
              ] else ...[
                if (this.item.price != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        textAlign: TextAlign.left,
                        softWrap: true,
                        text: TextSpan(children: <TextSpan> [
                          TextSpan(
                            text: '${this.item.price.toString()} ${Constants.currency[this.item.currency-1]}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ColorExtension.toColor('#F69723'),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ],
              ],
              if (this.item.service != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Services',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ColorExtension.toColor('#000000'),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      this.item.service!,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: ColorExtension.toColor('#000000'),
                      ),
                    ),
                  ),
                ),
              ],
              if (this.item.condition != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Conditions',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: ColorExtension.toColor('#000000'),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      this.item.condition!,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: ColorExtension.toColor('#000000'),
                      ),
                    ),
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'A propos de'.tr + ' ${this.item.title}',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ColorExtension.toColor('#000000'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    this.item.content,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: ColorExtension.toColor('#000000'),
                    ),
                  ),
                ),
              ),
            ], 
          ),
        ),
      ),
    ); 
  } 
}

class PostSimilarList extends StatelessWidget {
  final Post item;
  final Function(int) functionCallback;
  PostSimilarList({Key? key, required this.item, required this.functionCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Column(
        children: [
          if (this.item.photos.length > 0) ...[
            GestureDetector(
              onTap: () {
                this.functionCallback(this.item.id);
              },
              child: Container( 
                height: 80.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage('${Constants.baseUrl}${this.item.photos[0]['thumbnail']}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
          GestureDetector(
            onTap: () {
              this.functionCallback(this.item.id);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  this.item.title,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: ColorExtension.toColor('#000000'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  } 
}
