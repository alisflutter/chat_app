import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ph_login/providers/auth.dart';
import 'package:ph_login/screen/profile_screen.dart';
import 'package:ph_login/screen/wallpaper_colors.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../providers/wallpaper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // bool status = false;
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    final wall = Provider.of<Wallpaper>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(width: 2, color: Colors.black12),
              ),
              contentPadding:
                  const EdgeInsets.only(top: 2.5, bottom: 2.5, left: 5),
              tileColor: const Color.fromARGB(115, 225, 220, 220),
              leading: const CircleAvatar(
                backgroundColor: Colors.blueGrey,
                child: Icon(
                  Icons.person,
                  size: 25,
                  color: Colors.white,
                ),
              ),
              title: const Text(
                'Profile',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: ((context) {
                  return const Profile();
                })));
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(width: 2, color: Colors.black12),
              ),
              contentPadding:
                  const EdgeInsets.only(top: 2.5, bottom: 2.5, left: 5),
              tileColor: const Color.fromARGB(115, 225, 220, 220),
              leading: const CircleAvatar(
                backgroundColor: Colors.blueGrey,
                child: Icon(
                  Icons.brightness_high,
                  size: 25,
                  color: Colors.white,
                ),
              ),
              title: const Text(
                'Dark Theme',
                style: TextStyle(fontSize: 18),
              ),
              trailing: Switch(
                //  activeColor: Colors.blueGrey,
                value: theme.getValue,
                onChanged: (value) {
                  print("VALUE : $value");
                  // setState(() {
                  //   status = value;
                  // });
                  theme.swapTheme();
                  // wall.saveColor();
                  // wall.getColor();
                  //  wall.backgroundImage(0xff55efc4);
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(width: 2, color: Colors.black12),
              ),
              contentPadding:
                  const EdgeInsets.only(top: 2.5, bottom: 2.5, left: 5),
              tileColor: const Color.fromARGB(115, 225, 220, 220),
              leading: const CircleAvatar(
                backgroundColor: Colors.blueGrey,
                child: Icon(
                  Icons.wallpaper,
                  size: 25,
                  color: Colors.white,
                ),
              ),
              title: const Text(
                'Chat Wallpaper',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: ((context) {
                  return WallPaperColors();
                  ;
                })));
              },
              // trailing: Switch(
              //   //  activeColor: Colors.blueGrey,
              //   value: theme.getValue,
              //   onChanged: (value) {
              //     print("VALUE : $value");
              //     // setState(() {
              //     //   status = value;
              //     // });
              //      theme.swapTheme();
              //     // wall.saveColor();
              //     // wall.getColor();
              //   //  wall.backgroundImage(0xff55efc4);
              //   },
              // ),
            ),
            const SizedBox(
              height: 10,
            ),
            // ListTile(
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(15),
            //     side: const BorderSide(width: 2, color: Colors.black12),
            //   ),
            //   contentPadding:
            //       const EdgeInsets.only(top: 2.5, bottom: 2.5, left: 5),
            //   tileColor: const Color.fromARGB(115, 225, 220, 220),
            //   leading: const CircleAvatar(
            //     backgroundColor: Colors.blueGrey,
            //     child: Icon(
            //       Icons.delete_forever,
            //       size: 25,
            //       color: Colors.white,
            //     ),
            //   ),
            //   title: const Text(
            //     'Delete Account',
            //     style: TextStyle(fontSize: 18),
            //   ),
            //   onTap: () {
            //     showDialog(
            //         context: context,
            //         builder: ((context) {
            //           return AlertDialog(
            //             title: const Text('Are you sure delete account!'),
            //             elevation: 5,
            //             actions: [
            //               TextButton(
            //                   onPressed: () {
            //                     auth.deleteAccount(context);
            //                     Navigator.pushReplacementNamed(
            //                         context, '/login');
            //                   },
            //                   child: const Text('Yes')),
            //               TextButton(
            //                   onPressed: () {
            //                     Navigator.pop(context);
            //                   },
            //                   child: const Text('No'))
            //             ],
            //           );
            //         }));
            //   },
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(width: 2, color: Colors.black12),
              ),
              contentPadding:
                  const EdgeInsets.only(top: 2.5, bottom: 2.5, left: 5),
              tileColor: const Color.fromARGB(115, 225, 220, 220),
              leading: const CircleAvatar(
                backgroundColor: Colors.blueGrey,
                child: Icon(
                  Icons.logout,
                  size: 25,
                  color: Colors.white,
                ),
              ),
              title: const Text(
                'Log Out',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: ((context) {
                      return AlertDialog(
                        title: const Text('Log out!'),
                        elevation: 5,
                        actions: [
                          TextButton(
                              onPressed: () {
                                firebaseAuth.signOut();
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                              },
                              child: const Text('Yes')),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('No'))
                        ],
                      );
                    }));
              },
            ),
          ],
        ),
      ),
    );
  }
}
