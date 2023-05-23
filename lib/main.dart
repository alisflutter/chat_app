import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ph_login/home.dart';
import 'package:ph_login/providers/auth.dart';

import 'package:ph_login/providers/chat.dart';
import 'package:ph_login/providers/group_provider.dart';
import 'package:ph_login/providers/select_contact.dart';
import 'package:ph_login/providers/status_provider.dart';
import 'package:ph_login/providers/theme_provider.dart';
import 'package:ph_login/providers/wallpaper.dart';
import 'package:ph_login/screen/confirm_status.dart';
import 'package:ph_login/screen/contact.dart';
import 'package:ph_login/screen/create_group_screen.dart';
import 'package:ph_login/screen/mobile_chat_screen.dart';
import 'package:ph_login/screen/otp.dart';
import 'package:ph_login/screen/settings_screen.dart';
import 'package:ph_login/screen/splash_screen.dart';
import 'package:ph_login/screen/user_name.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screen/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  if (preferences.getBool('isDarkTheme') == null) {
    preferences.setBool('isDarkTheme', false);
  }
  //
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
    child: const MyApp(),
    create: (context) =>
        ThemeProvider(isDarkMode: preferences.getBool('isDarkTheme') as bool
            //  == null
            //     ? false
            //     : preferences.getBool('isDarkTheme') as bool
            ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // final check = Provider.of<Auth>(context, listen: false);
    //  final theme = Provider.of<ThemeProvider>(context);
    // var ck = check.checkUser();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: ((context) => Auth()),
          ),
          ChangeNotifierProvider(
            create: ((context) => SelectContact()),
          ),
          ChangeNotifierProvider(
            create: ((context) => Chat()),
          ),
          ChangeNotifierProvider(
            create: ((context) => StatusProvider()),
          ),
          ChangeNotifierProvider(
            create: ((context) => GroupProvider()),
          ),
          ChangeNotifierProvider(
            create: ((context) => Wallpaper()),
          ),
          // ChangeNotifierProvider(
          //   create: ((context) => CallProvider()),
          // ),
          // ChangeNotifierProvider(
          //   create: ((context) => ThemeProvider(isDarkMode: preferences)),
          // ),
        ],
        child: Consumer<ThemeProvider>(
          builder: (context, value, child) {
            return MaterialApp(
                // theme: ThemeData(
                //   primaryColor: const Color.fromARGB(255, 143, 188, 143),
                //   //  primarySwatch: MaterialColor(0xFFB2DFDB, color),
                // ),
                theme: value.getTheme,
                debugShowCheckedModeBanner: false,

                // home: ck ? const Home() : Login(),
                home: const SplashScreen(), // login
                routes: {
                  //  '/': (context) => Home(),
                  '/login': (context) => Login(),
                  '/otp': (context) => OTP(),
                  '/name': (context) => UserName(), // name
                  '/home': (context) => const Home(),
                  '/contacts': (context) => const ContactScreen(),
                  '/chatsScreen': (context) => const MChatScreen(),
                  '/confirmStatus': (context) => ConfirmStatus(),
                  '/createGroup': (context) => const CreateGroup(),
                });
          },
        ));
  }
}
