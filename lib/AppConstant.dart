import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConstant {
  static const String AppUrl = 'http://y-ral-gaming.com/admin/api/';
  static const Color lightBlack = Color(0xFF252525);
  static const String phoneNumber = "phoneNumber";
  static const String userId = "userId";
  static const String userName = "userName";
  static const String games = "games";
  static const String loyalFriends = "contactFriends";
  static const String teamList = "teamList";
  static const String countryCode = "countryCode";
  static const String bio = "bio";
  static const String title = "title";
  static const String name = "name";
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(phoneNumber) != null &&
        prefs.getString(userId) != null;
  }

  static void saveData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    print("data saved");
  }



  static void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

// To retrieve data from shared preferences
  static Future<String?> getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);
    return value ?? "";
  }
}
