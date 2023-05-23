import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:ph_login/model/user_model.dart';
import 'package:ph_login/widget/snackbar.dart';

class SelectContact with ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Contact> contactList = [];
  // bool permission = false;
  Future<List<Contact>> getContacts() async {
    // List<Contact> contactList = [];
    try {
      if (await FlutterContacts.requestPermission() ||
          await Permission.contacts.isGranted) {
        contactList = await FlutterContacts.getContacts(withProperties: true);
      } else {
        await Permission.contacts.request();
      }
    } catch (e) {
      print(e);
    }

    return contactList;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var usersCollection = await firestore.collection('users').get();
      bool isFound = false;

      for (var document in usersCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectPhone =
            selectedContact.phones[0].number.replaceAll(' ', '');
        print(selectPhone);
        print(userData.phoneNo);
        if (selectPhone == userData.phoneNo) {
          isFound = true;
          Navigator.pushNamed(
            context,
            '/chatsScreen',
            arguments: {
              'name': userData.name,
              'uid': userData.uid,
              'isGroup': false,
              'profilePic': userData.profilePic,
              'phoneNo': userData.phoneNo,
            },
          );
        }
      }

      if (!isFound) {
        showSnackBar(context, 'This Number not Register !');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

//   'users' collection == user phone contact
  List<Contact> ListContacts = [];
  Future<List<Contact>> getList() async {
    try {
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }

      for (int i = 0; i < contacts.length; i++) {
        var userDataFirebase = await firestore
            .collection('users')
            .where('phoneNo',
                isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''))
            .get();

        if (userDataFirebase.docs.isNotEmpty) {
          // var userData = UserModel.fromMap(userDataFirebase.docs[0].data());
          ListContacts.add(contacts[i]);
        }
      }
    } catch (e) {
      print(e);
    }
    return ListContacts;
  }

  // List<Contact> get getLists =>   [...ListContacts];
// user select contact for group
  List<Contact> selectContacts = [];
  //
}
