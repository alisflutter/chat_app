import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wallpaper with ChangeNotifier {
  // int lightGreenVal = 0xff55efc4;
  // int darkGreenVal = 0xff00b894;
  late int colorVal;

  Wallpaper() {
    _loadBackgroundImage();
  }

//   void saveColor() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setInt("switchColorValue", 0xff00b894);
//     print('ddddddd');
//   }

// //
//   Future<void> getColor() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     colorVal = prefs.getInt("switchColorValue") as int;
//     print('object');
//   }

//   int get ssss => colorVal as int;

  Future<void> _loadBackgroundImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    colorVal = prefs.getInt('switchColorValue') ?? 0xFFFFFFFF;
    notifyListeners();
  }

  int get ttttt => colorVal;

  void backgroundImage(int value) async {
    colorVal = value;
    notifyListeners();

    // Save the chat background image to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('switchColorValue', colorVal);
  }
}
