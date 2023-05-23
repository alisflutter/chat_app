import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _selectedTheme = ThemeData.light().copyWith(
    primaryColor: const Color.fromARGB(255, 143, 188, 143),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Color.fromARGB(255, 9, 194, 231),
      elevation: 5,
    ),
    toggleableActiveColor: Colors.amberAccent,
    backgroundColor: const Color.fromARGB(255, 77, 101, 113),
    dividerColor: Colors.black12,
    inputDecorationTheme: InputDecorationTheme(
      iconColor: Colors.black,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide:
            const BorderSide(color: Color.fromARGB(255, 96, 152, 96), width: 2),
      ),
      labelStyle:
          const TextStyle(fontSize: 17, color: Color.fromARGB(255, 53, 72, 53)),
    ),
    // appBarTheme: AppBarTheme(
    //     actionsIconTheme: IconThemeData(color: Colors.black),
    //     color: Colors.black)
  );

  ThemeData light = ThemeData.light().copyWith(
    primaryColor: const Color.fromARGB(255, 143, 188, 143),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Color.fromARGB(255, 9, 194, 231),
      elevation: 5,
    ),
    toggleableActiveColor: Colors.amberAccent,
    backgroundColor: const Color.fromARGB(255, 77, 101, 113),
    dividerColor: Colors.black12,
    inputDecorationTheme: InputDecorationTheme(
      iconColor: Colors.black,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide:
            const BorderSide(color: Color.fromARGB(255, 96, 152, 96), width: 2),
      ),
      labelStyle:
          const TextStyle(fontSize: 17, color: Color.fromARGB(255, 53, 72, 53)),
    ),
    // appBarTheme: AppBarTheme(
    //     actionsIconTheme: IconThemeData(color: Colors.black),
    //     color: Colors.black),
  );
  ThemeData dark = ThemeData.dark().copyWith(
      primaryColor: const Color.fromARGB(66, 48, 47, 47),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.blueAccent,
        elevation: 5,
      ),
      backgroundColor: const Color.fromARGB(255, 88, 195, 163),
      dividerColor: Colors.white,
      //  toggleableActiveColor: Colors.amberAccent,
      inputDecorationTheme: InputDecorationTheme(
        iconColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 248, 250, 248), width: 2),
        ),
        labelStyle: const TextStyle(
            fontSize: 17, color: Color.fromARGB(255, 250, 250, 250)),
      ));
  late bool value;
  ThemeProvider({required bool isDarkMode}) {
    this._selectedTheme = isDarkMode ? dark : light;
    value = isDarkMode ? true : false;
  }

  Future<void> swapTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    //  _selectedTheme = _selectedTheme == dark ? light : dark;
    if (_selectedTheme == dark) {
      _selectedTheme = light;
      preferences.setBool('isDarkTheme', false);
      value = preferences.getBool('isDarkTheme') as bool;
    } else {
      _selectedTheme = dark;
      preferences.setBool('isDarkTheme', true);
      value = preferences.getBool('isDarkTheme') as bool;
    }
    notifyListeners();
  }

  ThemeData get getTheme => _selectedTheme;

  bool get getValue => value;
}
