import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ph_login/providers/auth.dart';
import 'package:ph_login/screen/chats.dart';
import 'package:ph_login/screen/contact.dart';
import 'package:ph_login/screen/settings_screen.dart';
import 'package:ph_login/screen/status_contact.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
//  var Ustate = false;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void setUserState(bool isOnline) async {
    await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update({
      'isOnline': isOnline, //isOnline,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        //  Ustate = true;
        setState(() {
          setUserState(true);
        });

        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        //  Ustate = false;
        setState(() {
          setUserState(false);
        });

        break;
    }
  }

//

  late List<Map<String, dynamic>> _pages;
  @override
  void initState() {
    _pages = [
      {'page': const ChatScreen(), 'title': 'Chats'},
      {'page': const StatusContact(), 'title': 'Status'},
      {'page': const ContactScreen(), 'title': 'Contacts'},
      {'page': const SettingsScreen(), 'title': 'Settings'},
    ];
    setUserState(true);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    // setUserState(Ustate);
  }

  int _pageIndex = 0;

  void _selectPages(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    // final state = Provider.of<Auth>(context).setUserState(Ustate);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     _pages[_pageIndex]['title'],
      //     style: const TextStyle(color: Colors.black),
      //   ),
      //   actions: [

      //     IconButton(
      //         onPressed: (() {
      //           firebaseAuth.signOut();
      //           Navigator.pushReplacementNamed(context, '/login');
      //           // ignore: avoid_print
      //           // print(toString(state));
      //         }),
      //         icon: Icon(Icons.exit_to_app)),

      //   ],
      //   backgroundColor: const Color.fromARGB(255, 143, 188, 143),
      // ),
      body: _pages[_pageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // selectedItemColor: const Color.fromARGB(255, 195, 136, 28),
        currentIndex: _pageIndex,
        onTap: _selectPages,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add_sharp),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_phone),
            label: 'Contact',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
