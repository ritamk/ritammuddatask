import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ritammuddatask/models/user_model.dart';
import 'package:ritammuddatask/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LocalSharedPrefKeys { isLoggedInKey, uidKey, themeKey }

class LocalSharedPref {
  static SharedPreferences? sharedPreferences;

  static Future init() async =>
      sharedPreferences = await SharedPreferences.getInstance();

  static Future<bool> setLoggedIn(bool isLoggedIn) async =>
      await sharedPreferences!
          .setBool(LocalSharedPrefKeys.isLoggedInKey.name, isLoggedIn);

  static bool getLoggedIn() {
    try {
      return sharedPreferences!
              .getBool(LocalSharedPrefKeys.isLoggedInKey.name) ??
          false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> setUid(String uid) async =>
      await sharedPreferences!.setString(LocalSharedPrefKeys.uidKey.name, uid);

  static String? getUid() {
    try {
      final String? user =
          sharedPreferences!.getString(LocalSharedPrefKeys.uidKey.name);
      return user;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> setTheme(ThemeModel theme) async =>
      await sharedPreferences!.setString(
        LocalSharedPrefKeys.themeKey.name,
        jsonEncode({
          "color": THEMES.keys
              .firstWhere((element) => THEMES[element] == theme.color),
          "dark": theme.dark,
        }),
      );

  static ThemeModel? getTheme() {
    try {
      final String? data =
          sharedPreferences!.getString(LocalSharedPrefKeys.themeKey.name);
      if (data != null) {
        final Map<dynamic, dynamic> decodedData = jsonDecode(data);
        return ThemeModel(
          color: THEMES[decodedData["color"]] ?? Colors.deepPurple,
          dark: decodedData["dark"],
        );
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> clearSharedPref() async =>
      await sharedPreferences!.clear();
}
