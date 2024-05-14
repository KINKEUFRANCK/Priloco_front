import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:bonsplans/configs/constants.dart';

Future<http.Response> registerUser(String email, String password, int role, String? first_name, String? last_name) async {
  Map<String, dynamic> data = {
    'email': email,
    'password': password,
    'role': role,
    'first_name': first_name,
    'last_name': last_name,
  };

  print('totototototo url: ${Constants.baseUrl}/api/auth/user/register/');
  print('totototototo data: ${json.encode(data)}');

  return await http.post(
    Uri.parse('${Constants.baseUrl}/api/auth/user/register/'),
    body: json.encode(data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      // 'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<http.Response> destroyUser(String token, String tokenRefresh) async {
  Map<String, dynamic> data = {
  };

  print('totototototo url: ${Constants.baseUrl}/api/auth/user/destroy/');
  print('totototototo data: ${json.encode(data)}');

  return await http.delete(
    Uri.parse('${Constants.baseUrl}/api/auth/user/destroy/').replace(queryParameters: data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<http.Response> registerGoogleUser(String password, int role, String? first_name, String? last_name, Map<dynamic, dynamic>? profile) async {
  Map<String, dynamic> data = {
    'password': password,
    'role': role,
    'first_name': first_name,
    'last_name': last_name,
    ...profile!,
  };

  print('totototototo url: ${Constants.baseUrl}/api/auth/user/google_register/');
  print('totototototo data: ${json.encode(data)}');

  return await http.post(
    Uri.parse('${Constants.baseUrl}/api/auth/user/google_register/'),
    body: json.encode(data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      // 'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<http.Response> retrieveUser(String token, String tokenRefresh, {int id = 0}) async {
  Map<String, dynamic> data = {
    'id': id.toString(),
  };

  print('totototototo url: ${Constants.baseUrl}/api/auth/user/retrieve/');
  print('totototototo data: ${json.encode(data)}');

  return await http.get(
    Uri.parse('${Constants.baseUrl}/api/auth/user/retrieve/').replace(queryParameters: data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<http.Response> loginUser(String email, String password) async {
  Map<String, dynamic> data = {
    'email': email,
    'password': password,
  };

  print('totototototo url: ${Constants.baseUrl}/api/auth/token/');
  print('totototototo data: ${json.encode(data)}');

  return await http.post(
    Uri.parse('${Constants.baseUrl}/api/auth/token/'),
    body: json.encode(data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      // 'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<http.Response> verifyUser(String token, String tokenRefresh) async {
  Map<String, dynamic> data = {
    'token': token,
  };

  print('totototototo url: ${Constants.baseUrl}/api/auth/token/verify/');
  print('totototototo data: ${json.encode(data)}');

  return await http.post(
    Uri.parse('${Constants.baseUrl}/api/auth/token/verify/'),
    body: json.encode(data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      // 'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<http.Response> refreshUser(String token, String tokenRefresh) async {
  Map<String, dynamic> data = {
    'refresh': tokenRefresh,
  };

  print('totototototo url: ${Constants.baseUrl}/api/auth/token/refresh/');
  print('totototototo data: ${json.encode(data)}');

  return await http.post(
    Uri.parse('${Constants.baseUrl}/api/auth/token/refresh/'),
    body: json.encode(data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      // 'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<http.Response> loginGoogleUser(Map<dynamic, dynamic>? profile) async {
  Map<String, dynamic>? data = {...profile!};

  print('totototototo url: ${Constants.baseUrl}/api/auth/user/google_login/');
  print('totototototo data: ${json.encode(data)}');

  return await http.post(
    Uri.parse('${Constants.baseUrl}/api/auth/user/google_login/'),
    body: json.encode(data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      // 'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<http.Response> resetPasswordUser(String email) async {
  Map<String, dynamic> data = {
    'email': email,
  };

  print('totototototo url: ${Constants.baseUrl}/api/auth/password/reset/');
  print('totototototo data: ${json.encode(data)}');

  return await http.post(
    Uri.parse('${Constants.baseUrl}/api/auth/password/reset/'),
    body: json.encode(data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      // 'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<http.Response> resetConfirmPasswordUser(String email, String code, {String password = '', String password2 = ''}) async {
  Map<String, dynamic> data = {
    'email': email,
    'code': code,
    'password': password,
    'password2': password2,
  };

  print('totototototo url: ${Constants.baseUrl}/api/auth/password/reset/confirm/');
  print('totototototo data: ${json.encode(data)}');

  return await http.post(
    Uri.parse('${Constants.baseUrl}/api/auth/password/reset/confirm/'),
    body: json.encode(data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      // 'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<http.Response> verifyRegistrationUser(String email) async {
  Map<String, dynamic> data = {
    'email': email,
  };

  print('totototototo url: ${Constants.baseUrl}/api/auth/registration/verify/');
  print('totototototo data: ${json.encode(data)}');

  return await http.post(
    Uri.parse('${Constants.baseUrl}/api/auth/registration/verify/'),
    body: json.encode(data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      // 'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<http.Response> verifyConfirmRegistrationUser(String email, String code) async {
  Map<String, dynamic> data = {
    'email': email,
    'code': code,
  };

  print('totototototo url: ${Constants.baseUrl}/api/auth/registration/verify/confirm/');
  print('totototototo data: ${json.encode(data)}');

  return await http.post(
    Uri.parse('${Constants.baseUrl}/api/auth/registration/verify/confirm/'),
    body: json.encode(data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      // 'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<http.Response> changePasswordUser(String token, String tokenRefresh, {String old_password = '', String password = '', String password2 = ''}) async {
  Map<String, dynamic> data = {
    'old_password': old_password,
    'password': password,
    'password2': password2,
  };

  print('totototototo url: ${Constants.baseUrl}/api/auth/password/change/');
  print('totototototo data: ${json.encode(data)}');

  return await http.put(
    Uri.parse('${Constants.baseUrl}/api/auth/password/change/'),
    body: json.encode(data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

// Future<http.Response> logoutUser() async {
// }

// Future<http.Response> profileUser() async {
// }

// --------------- Post ---------------
Future<http.Response> listPosts(String token, String tokenRefresh, {String location = '', double latitude = 0.0, double longitude = 0.0, int limit = 0, int offset = 0, String search = '', String sort = 'id', String order = 'desc', int distance = Constants.distance, int unit = Constants.defaultUnit, bool authenticated = false, int? category = 0, int? user = 0}) async {
  Map<String, dynamic> data = {
    'location': location,
    'latitude': latitude.toString(),
    'longitude': longitude.toString(),
    'limit': limit.toString(),
    'offset': offset.toString(),
    'search': search,
    'sort': sort,
    'order': order,
    'category': category.toString(),
    'distance': distance.toString(),
    'unit': unit.toString(),
    'user': user.toString(),
  };

  if (authenticated) {
    print('totototototo url: ${Constants.baseUrl}/api/post/auth/');
    print('totototototo data: ${json.encode(data)}');

    return await http.get(
      Uri.parse('${Constants.baseUrl}/api/post/auth/').replace(queryParameters: data),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json; charset=utf-8',
        'Authorization': 'Bearer ${token}',
      },
    ).then((http.Response response) {
        // print('statusCode : ${response.statusCode}');
        // print('body : ${json.encode(response.body)}');

        return response;
      }
    );
  } else {
    print('totototototo url: ${Constants.baseUrl}/api/post/');
    print('totototototo data: ${json.encode(data)}');

    return await http.get(
      Uri.parse('${Constants.baseUrl}/api/post/').replace(queryParameters: data),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json; charset=utf-8',
        // 'Authorization': 'Bearer ${token}',
      },
    ).then((http.Response response) {
        // print('statusCode : ${response.statusCode}');
        // print('body : ${json.encode(response.body)}');

        return response;
      }
    );
  }
}

Future<http.Response> retrievePost(String token, String tokenRefresh, {int id = 0}) async {
  Map<String, dynamic> data = {
    'id': id.toString(),
  };

  print('totototototo url: ${Constants.baseUrl}/api/post/retrieve/${data["id"]}/');
  print('totototototo data: ${json.encode(data)}');

  return await http.get(
    Uri.parse('${Constants.baseUrl}/api/post/retrieve/${data["id"]}/').replace(queryParameters: data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      // 'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<http.Response> destroyPost(String token, String tokenRefresh, {int id = 0}) async {
  Map<String, dynamic> data = {
    'id': id.toString(),
  };

  print('totototototo url: ${Constants.baseUrl}/api/post/destroy/${data["id"]}/');
  print('totototototo data: ${json.encode(data)}');

  return await http.delete(
    Uri.parse('${Constants.baseUrl}/api/post/destroy/${data["id"]}/').replace(queryParameters: data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<http.Response> createPost(String token, String tokenRefresh, {int category = 0, String title = '', double price = 0.0, int promotion = 0, String content = '', String phone = '', String service = '', String condition = '', String url = '', String location = '', double latitude = 0.0, double longitude = 0.0}) async {
  Map<String, dynamic> data = {
    'categories': [category.toString()],
    'title': title,
    'price': price.toString(),
    'promotion': promotion.toString(),
    'location': location,
    'content': content,
    'phone': phone,
    'service': service,
    'condition': condition,
    'url': url,
    'latitude': latitude.toString(),
    'longitude': longitude.toString(),
  };

  print('totototototo url: ${Constants.baseUrl}/api/post/create/');
  print('totototototo data: ${json.encode(data)}');

  return await http.post(
    Uri.parse('${Constants.baseUrl}/api/post/create/'),
    body: json.encode(data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<http.Response> updatePost(String token, String tokenRefresh, {int id = 0, String title = '', double price = 0.0, int promotion = 0, String content = '', String phone = '', String service = '', String condition = '', String url = ''}) async {
  Map<String, dynamic> data = {
    'id': id.toString(),
    'title': title,
    'price': price.toString(),
    'promotion': promotion.toString(),
    'content': content,
    'phone': phone,
    'service': service,
    'condition': condition,
    'url': url,
  };

  print('totototototo url: ${Constants.baseUrl}/api/post/update/${data["id"]}/');
  print('totototototo data: ${json.encode(data)}');

  return await http.put(
    Uri.parse('${Constants.baseUrl}/api/post/update/${data["id"]}/'),
    body: json.encode(data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

// Future<http.Response> updatePost(String token, String tokenRefresh) async {
// }

// Future<http.Response> destroyPost(String token, String tokenRefresh) async {
// }

// --------------- Category ---------------
Future<http.Response> listCategories(String token, String tokenRefresh, {String location = '', int limit = 0, int offset = 0, String search = '', String sort = 'id', String order = 'desc', bool authenticated = false}) async {
  Map<String, dynamic> data = {
    'location': location,
    'limit': limit.toString(),
    'offset': offset.toString(),
    'search': search,
    'sort': sort,
    'order': order,
  };

  if (authenticated) {
    print('totototototo url: ${Constants.baseUrl}/api/category/auth/');
    print('totototototo data: ${json.encode(data)}');

    return await http.get(
      Uri.parse('${Constants.baseUrl}/api/category/auth/').replace(queryParameters: data),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json; charset=utf-8',
        'Authorization': 'Bearer ${token}',
      },
    ).then((http.Response response) {
        // print('statusCode : ${response.statusCode}');
        // print('body : ${json.encode(response.body)}');

        return response;
      }
    );
  } else {
    print('totototototo url: ${Constants.baseUrl}/api/category/');
    print('totototototo data: ${json.encode(data)}');

    return await http.get(
      Uri.parse('${Constants.baseUrl}/api/category/').replace(queryParameters: data),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json; charset=utf-8',
        // 'Authorization': 'Bearer ${token}',
      },
    ).then((http.Response response) {
        // print('statusCode : ${response.statusCode}');
        // print('body : ${json.encode(response.body)}');

        return response;
      }
    );
  }
}

// --------------- All Category ---------------
Future<http.Response> listAllCategories(String token, String tokenRefresh, {String location = '', int limit = 0, int offset = 0, String search = '', String sort = 'id', String order = 'desc', bool authenticated = false}) async {
  Map<String, dynamic> data = {
    'location': location,
    'limit': limit.toString(),
    'offset': offset.toString(),
    'search': search,
    'sort': sort,
    'order': order,
  };

  if (authenticated) {
    print('totototototo url: ${Constants.baseUrl}/api/category/all/auth/');
    print('totototototo data: ${json.encode(data)}');

    return await http.get(
      Uri.parse('${Constants.baseUrl}/api/category/all/auth/').replace(queryParameters: data),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json; charset=utf-8',
        'Authorization': 'Bearer ${token}',
      },
    ).then((http.Response response) {
        // print('statusCode : ${response.statusCode}');
        // print('body : ${json.encode(response.body)}');

        return response;
      }
    );
  } else {
    print('totototototo url: ${Constants.baseUrl}/api/category/all/');
    print('totototototo data: ${json.encode(data)}');

    return await http.get(
      Uri.parse('${Constants.baseUrl}/api/category/all/').replace(queryParameters: data),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json; charset=utf-8',
        // 'Authorization': 'Bearer ${token}',
      },
    ).then((http.Response response) {
        // print('statusCode : ${response.statusCode}');
        // print('body : ${json.encode(response.body)}');

        return response;
      }
    );
  }
}

// Future<http.Response> createCategory(String token, String tokenRefresh) async {
// }

// Future<http.Response> retrieveCategory(String token, String tokenRefresh) async {
// }

// Future<http.Response> updateCategory(String token, String tokenRefresh) async {
// }

// Future<http.Response> destroyCategory(String token, String tokenRefresh) async {
// }

Future<http.Response> createConfigUser(String token, String tokenRefresh, {int time = Constants.time, int distance = Constants.distance, int unit = Constants.defaultUnit}) async {
  Map<String, dynamic> data = {
    'time': time.toString(),
    'distance': distance.toString(),
    'unit': unit.toString(),
  };

  print('totototototo url: ${Constants.baseUrl}/api/configuser/create/');
  print('totototototo data: ${json.encode(data)}');

  return await http.post(
    Uri.parse('${Constants.baseUrl}/api/configuser/create/'),
    body: json.encode(data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<http.Response> retrieveConfigUser(String token, String tokenRefresh, {double latitude = 0.0, double longitude = 0.0}) async {
  Map<String, dynamic> data = {
    'latitude': latitude.toString(),
    'longitude': longitude.toString(),
  };

  print('totototototo url: ${Constants.baseUrl}/api/configuser/retrieve/');
  print('totototototo data: ${json.encode(data)}');

  return await http.get(
    Uri.parse('${Constants.baseUrl}/api/configuser/retrieve/').replace(queryParameters: data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      // 'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<http.Response> listConfigUsers(String token, String tokenRefresh, {String search = '', int limit = 0, int offset = 0}) async {
  Map<String, dynamic> data = {
    'search': search,
    'limit': limit.toString(),
    'offset': offset.toString(),
  };

  print('totototototo url: ${Constants.baseUrl}/api/configuser/');
  print('totototototo data: ${json.encode(data)}');

  return await http.get(
    Uri.parse('${Constants.baseUrl}/api/configuser/').replace(queryParameters: data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      // 'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<http.Response> createPhoto(String token, String tokenRefresh, PlatformFile file, {int post = 0}) async {
  Map<String, String> data = {
    'post': post.toString(),
  };

  print('totototototo url: ${Constants.baseUrl}/api/photo/create/');
  print('totototototo data: ${json.encode(data)}');

  var request = http.MultipartRequest('POST', Uri.parse('${Constants.baseUrl}/api/photo/create/'));

  request.fields.addAll(data);

  if (Platform.isAndroid) {
    request.files.add(new http.MultipartFile('thumbnail', File(file.path!).readAsBytes().asStream(), File(file.path!).lengthSync(), filename: file.name));
  } else if (Platform.isIOS) {
  }

  request.headers.addAll({
    'Authorization': 'Bearer ${token}',
    'Content-Type': 'multipart/form-data',
    'Accept': 'application/json; charset=utf-8',
  });

  var response = await http.Response.fromStream(await request.send());

  return response;
}

Future<http.Response> listFavorites(String token, String tokenRefresh, {int limit = 0, int offset = 0}) async {
  Map<String, dynamic> data = {
    'limit': limit.toString(),
    'offset': offset.toString(),
  };

  print('totototototo url: ${Constants.baseUrl}/api/favorite/');
  print('totototototo data: ${json.encode(data)}');

  return await http.get(
    Uri.parse('${Constants.baseUrl}/api/favorite/').replace(queryParameters: data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<http.Response> createFavorite(String token, String tokenRefresh, {int post = 0, int action = 0}) async {
  Map<String, dynamic> data = {
    'post': post.toString(),
    'action': action.toString(),
  };

  print('totototototo url: ${Constants.baseUrl}/api/favorite/create/');
  print('totototototo data: ${json.encode(data)}');

  return await http.post(
    Uri.parse('${Constants.baseUrl}/api/favorite/create/'),
    body: json.encode(data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<http.Response> listFavoriteCategories(String token, String tokenRefresh, {int limit = 0, int offset = 0}) async {
  Map<String, dynamic> data = {
    'limit': limit.toString(),
    'offset': offset.toString(),
  };

  print('totototototo url: ${Constants.baseUrl}/api/favoritecategory/');
  print('totototototo data: ${json.encode(data)}');

  return await http.get(
    Uri.parse('${Constants.baseUrl}/api/favoritecategory/').replace(queryParameters: data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<http.Response> createFavoriteCategory(String token, String tokenRefresh, {int category = 0, int action = 0}) async {
  Map<String, dynamic> data = {
    'category': category.toString(),
    'action': action.toString(),
  };

  print('totototototo url: ${Constants.baseUrl}/api/favoritecategory/create/');
  print('totototototo data: ${json.encode(data)}');

  return await http.post(
    Uri.parse('${Constants.baseUrl}/api/favoritecategory/create/'),
    body: json.encode(data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<http.Response> listNotifications(String token, String tokenRefresh, {int limit = 0, int offset = 0}) async {
  Map<String, dynamic> data = {
    'limit': limit.toString(),
    'offset': offset.toString(),
  };

  print('totototototo url: ${Constants.baseUrl}/api/notification/');
  print('totototototo data: ${json.encode(data)}');

  return await http.get(
    Uri.parse('${Constants.baseUrl}/api/notification/').replace(queryParameters: data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      // 'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<http.Response> listSurveys(String token, String tokenRefresh, {int limit = 0, int offset = 0}) async {
  Map<String, dynamic> data = {
    'limit': limit.toString(),
    'offset': offset.toString(),
  };

  print('totototototo url: ${Constants.baseUrl}/api/survey/');
  print('totototototo data: ${json.encode(data)}');

  return await http.get(
    Uri.parse('${Constants.baseUrl}/api/survey/').replace(queryParameters: data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      // 'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<http.Response> retrieveSurvey(String token, String tokenRefresh, {int id = 0}) async {
  Map<String, dynamic> data = {
    'id': id.toString(),
  };

  print('totototototo url: ${Constants.baseUrl}/api/survey/retrieve/${data["id"]}/');
  print('totototototo data: ${json.encode(data)}');

  return await http.get(
    Uri.parse('${Constants.baseUrl}/api/survey/retrieve/${data["id"]}/').replace(queryParameters: data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      // 'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<http.Response> createSurveyUser(String token, String tokenRefresh, {String first_name = '', String last_name = '', String phone = '', String email = '', String zipcode = '', int survey = 0}) async {
  Map<String, dynamic> data = {
    'first_name': first_name,
    'last_name': last_name,
    'phone': phone,
    'email': email,
    'zipcode': zipcode,
    'survey': survey.toString(),
  };

  print('totototototo url: ${Constants.baseUrl}/api/survey/create/user/');
  print('totototototo data: ${json.encode(data)}');

  return await http.post(
    Uri.parse('${Constants.baseUrl}/api/survey/create/user/'),
    body: json.encode(data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      // 'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<http.Response> createSurveyResponse(String token, String tokenRefresh, {int surveyuser = 0, int surveyform = 0, String answer = ''}) async {
  Map<String, dynamic> data = {
    'surveyuser': surveyuser.toString(),
    'surveyform': surveyform.toString(),
    'answer': answer.toString(),
  };

  print('totototototo url: ${Constants.baseUrl}/api/survey/create/response/');
  print('totototototo data: ${json.encode(data)}');

  return await http.post(
    Uri.parse('${Constants.baseUrl}/api/survey/create/response/'),
    body: json.encode(data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      // 'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<http.Response> createReview(String token, String tokenRefresh, {int post = 0, double rating = 0.0, String comment = ''}) async {
  Map<String, dynamic> data = {
    'post': post.toString(),
    'rating': rating.toString(),
    'comment': comment,
  };

  print('totototototo url: ${Constants.baseUrl}/api/review/create/');
  print('totototototo data: ${json.encode(data)}');

  return await http.post(
    Uri.parse('${Constants.baseUrl}/api/review/create/'),
    body: json.encode(data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

// --------------- Post ---------------
Future<http.Response> listReviews(String token, String tokenRefresh, {int? post = 0, int limit = 0, int offset = 0}) async {
  Map<String, dynamic> data = {
    'post': post.toString(),
    'limit': limit.toString(),
    'offset': offset.toString(),
  };

  print('totototototo url: ${Constants.baseUrl}/api/review/');
  print('totototototo data: ${json.encode(data)}');

  return await http.get(
    Uri.parse('${Constants.baseUrl}/api/review/').replace(queryParameters: data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      // 'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}

Future<void> downloadFile(String token, String tokenRefresh, {int id = 0, String title = ''}) async {
  Map<String, dynamic> data = {
    'id': id.toString(),
  };

  print('totototototo url: ${Constants.baseUrl}/api/survey/download/${data["id"]}/');
  print('totototototo data: ${json.encode(data)}');

  title = title.replaceAll(RegExp("[^A-Za-z]"), "-");
  DateTime now = DateTime.now();
  String date = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

  String filename = '${title}-${date}.xlsx';

  Directory downloadDirectory;

  if (Platform.isIOS) {
    downloadDirectory = await getApplicationDocumentsDirectory();
  } else {
    downloadDirectory = Directory('/storage/emulated/0/Download');
    if (!await downloadDirectory.exists()) downloadDirectory = (await getExternalStorageDirectory())!;
  }

  print('totototototo downloadDirectory path: ${json.encode(downloadDirectory.path)}');

  String filePathName = "${downloadDirectory.path}/${filename}";
  File savedFile = File(filePathName);
  bool fileExists = await savedFile.exists();

  if (!fileExists) {
    Permission permission = Permission.storage;
    PermissionStatus status = await permission.status;
    if (status != PermissionStatus.granted) {
      await permission.request();
      if (await permission.status.isGranted) {
        await http.get(
          Uri.parse('${Constants.baseUrl}/api/survey/download/${data["id"]}/').replace(queryParameters: data),
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
            'Accept': 'application/json; charset=utf-8',
            'Authorization': 'Bearer ${token}',
          },
        ).then((http.Response response) async {
          // print('statusCode : ${response.statusCode}');
          // print('body : ${json.encode(response.body)}');

          await http.get(
            Uri.parse(json.decode(utf8.decode(response.bodyBytes))),
            // headers: {
            //   'Content-Type': 'application/json; charset=utf-8',
            //   'Accept': 'application/json; charset=utf-8',
            //   'Authorization': 'Bearer ${token}',
            // },
          ).then((http.Response response) async {
            // print('statusCode : ${response.statusCode}');
            // print('body : ${json.encode(response.body)}');

            try {
              await savedFile.writeAsBytes(response.bodyBytes);
            } on Exception catch (e, s) {
              downloadDirectory = (await getExternalStorageDirectory())!;

              print('totototototo downloadDirectory path: ${json.encode(downloadDirectory.path)}');

              String filePathName = "${downloadDirectory.path}/${filename}";
              File savedFile = File(filePathName);
              bool fileExists = await savedFile.exists();

              if (!fileExists) {
                await savedFile.writeAsBytes(response.bodyBytes);
              }
            }
          });
        });
      }
    } else {
      await http.get(
        Uri.parse('${Constants.baseUrl}/api/survey/download/${data["id"]}/').replace(queryParameters: data),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json; charset=utf-8',
          'Authorization': 'Bearer ${token}',
        },
      ).then((http.Response response) async {
        // print('statusCode : ${response.statusCode}');
        // print('body : ${json.encode(response.body)}');

        await http.get(
          Uri.parse(json.decode(utf8.decode(response.bodyBytes))),
          // headers: {
          //   'Content-Type': 'application/json; charset=utf-8',
          //   'Accept': 'application/json; charset=utf-8',
          //   'Authorization': 'Bearer ${token}',
          // },
        ).then((http.Response response) async {
          // print('statusCode : ${response.statusCode}');
          // print('body : ${json.encode(response.body)}');

          await savedFile.writeAsBytes(response.bodyBytes);
        });
      });
    }
  }
}

Future<http.Response> createContactService(String token, String tokenRefresh, {String content = ''}) async {
  Map<String, dynamic> data = {
    'content': content,
  };

  print('totototototo url: ${Constants.baseUrl}/api/contactservice/create/');
  print('totototototo data: ${json.encode(data)}');

  return await http.post(
    Uri.parse('${Constants.baseUrl}/api/contactservice/create/'),
    body: json.encode(data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      // 'Authorization': 'Bearer ${token}',
    },
  ).then((http.Response response) {
      // print('statusCode : ${response.statusCode}');
      // print('body : ${json.encode(response.body)}');

      return response;
    }
  );
}
