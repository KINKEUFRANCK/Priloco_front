import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import 'package:bonsplans/utils/colors.dart';
import 'package:bonsplans/utils/api.dart';
import 'package:bonsplans/providers/auth.dart';
import 'package:bonsplans/configs/constants.dart';
import 'package:bonsplans/configs/routes.dart';
import 'package:bonsplans/providers/post.dart';
import 'package:bonsplans/providers/favorite.dart';
import 'package:bonsplans/providers/favoritecategory.dart';
import 'package:bonsplans/controllers/login.dart';

import 'package:bonsplans/components/post.dart';
import 'package:bonsplans/components/category.dart';

class PostFavorite extends StatelessWidget {
  final Post item;
  final Function(Map?) functionCallback;
  PostFavorite({Key? key, required this.item, required this.functionCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final token = (authProvider.token != null && !authProvider.token.isEmpty) ? authProvider.token : Constants.token;
    final tokenRefresh = (authProvider.tokenRefresh != null && !authProvider.tokenRefresh.isEmpty) ? authProvider.tokenRefresh : Constants.tokenRefresh;
    final postProvider = Provider.of<PostProvider>(context);
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final loginControl = Get.put(LoginController());

    return Container(
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
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        if (this.item.photos.length > 0) ...[
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container( 
                              height: 40.0,
                              width: 40.0,
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
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
                        GestureDetector(
                          onTap: () {
                            postProvider.post = postProvider.posts.where((post) => post['id'] == this.item.id).toList()[0];
                            Get.toNamed(Routes.review_create, arguments: {'post': postProvider.post['id']},);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2, left: 10),
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
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: Align(
                      alignment: Alignment.centerRight,
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
                ], 
              ),
            ],
          ),
        ),
      ),
    ); 
  } 
}

class CategoryFavorite extends StatelessWidget {
  final Category item;
  final Function(Map?) functionCallback;
  CategoryFavorite({Key? key, required this.item, required this.functionCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final token = (authProvider.token != null && !authProvider.token.isEmpty) ? authProvider.token : Constants.token;
    final tokenRefresh = (authProvider.tokenRefresh != null && !authProvider.tokenRefresh.isEmpty) ? authProvider.tokenRefresh : Constants.tokenRefresh;
    final favoriteCategoryProvider = Provider.of<FavoriteCategoryProvider>(context);
    final loginControl = Get.put(LoginController());

    return Container(
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (this.item.thumbnail != null) ...[
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container( 
                              height: 40.0,
                              width: 40.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage('${Constants.baseUrl}${this.item.thumbnail}'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${this.item.title.tr}',
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
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (loginControl.authenticated) {
                        if (favoriteCategoryProvider.favoritecategories.map((favorite) => favorite['category']).toList().contains(this.item.id) == true) {
                          http.Response responseFavoriteCategory = await createFavoriteCategory(token, tokenRefresh, category: this.item.id, action: 0);
                        } else {
                          http.Response responseFavoriteCategory = await createFavoriteCategory(token, tokenRefresh, category: this.item.id, action: 1);
                        }

                        this.functionCallback(null);
                      } else {
                        if (favoriteCategoryProvider.favoritecategories.map((favorite) => favorite['category']).toList().contains(this.item.id) == true) {
                          this.functionCallback({
                              "category": this.item.id,
                              "item": this.item,
                              "action": 0,
                          });
                        } else {
                          this.functionCallback({
                              "category": this.item.id,
                              "item": this.item,
                              "action": 1,
                          });
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5, right: 5),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: favoriteCategoryProvider.favoritecategories.map((favorite) => favorite['category']).toList().contains(this.item.id) == true ? Icon(
                          size: 30.0,
                          color: ColorExtension.toColor('#FF914D'),
                          Icons.check_circle,
                        ) : Icon(
                          size: 30.0,
                          color: ColorExtension.toColor('#9E9E9E'),
                          Icons.check_circle_outline,
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
    ); 
  } 
}
