import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<dynamic> getAccountData(GoogleSignInAccount? googleUser) async {
  final headers = await googleUser!.authHeaders;

  Map<String, dynamic> data = {
    'personFields': 'names,emailAddresses',
  };

  print('totototototo url: https://people.googleapis.com/v1/people/me');
  print('totototototo data: ${json.encode(data)}');

  final response = await http.get(
    Uri.parse('https://people.googleapis.com/v1/people/me').replace(queryParameters: data),
    headers: {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json; charset=utf-8',
      'Authorization': headers!["Authorization"]!,
    },
  );

  var body = json.decode(utf8.decode(response.bodyBytes));

  print('totototototo body: ${body}');

  return body;
}

Future<(UserCredential, dynamic)> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  await googleSignIn.signOut();
  final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

  dynamic accountData = await getAccountData(googleUser);

  print('totototototo googleUser: ${googleUser}');

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  print('totototototo googleAuth: ${googleAuth}');

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

  return (userCredential, accountData);
}

Future<void> signOutWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/userinfo.profile',
      // 'https://www.googleapis.com/auth/user.birthday.read',
      // 'https://www.googleapis.com/auth/user.gender.read'
    ],
  );

  await googleSignIn.signOut();
}
