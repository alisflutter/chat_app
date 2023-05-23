import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:ph_login/widget/snackbar.dart';
import 'package:uuid/uuid.dart';

import '../model/status.dart';
import '../model/user_model.dart';

class StatusProvider with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  void uploadStatus({
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required BuildContext context,
  }) async {
    try {
      var statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;

      UploadTask uploadTask = firebaseStorage
          .ref()
          .child('/status/$statusId$uid')
          .putFile(statusImage);
      TaskSnapshot snapshot = await uploadTask;
      String imageurl = await snapshot.ref.getDownloadURL();

      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }

      List<String> uidWhoCanSee = [];

      // for (int i = 0; i < contacts.length; i++) {
      //   var userDataFirebase = await firestore
      //       .collection('users')
      //       .where(
      //         'phoneNo',
      //         isEqualTo: contacts[i].phones[0].number.replaceAll(
      //               ' ',
      //               '',
      //             ),
      //       )
      //       .get();

      //   if (userDataFirebase.docs.isNotEmpty) {
      //     var userData = UserModel.fromMap(userDataFirebase.docs[0].data());
      //     uidWhoCanSee.add(userData.uid);
      //   }
      // }

      List<String> statusImageUrls = [];
      var statusesSnapshot = await firestore
          .collection('status')
          .where(
            'uid',
            isEqualTo: auth.currentUser!.uid,
          )
          .get();

      if (statusesSnapshot.docs.isNotEmpty) {
        Status status = Status.fromMap(statusesSnapshot.docs[0].data());
        statusImageUrls = status.photoUrl;
        statusImageUrls.add(imageurl);
        await firestore
            .collection('status')
            .doc(statusesSnapshot.docs[0].id)
            .update({
          'photoUrl': statusImageUrls,
        });
        return;
      } else {
        statusImageUrls = [imageurl];
        print(statusImageUrls);
      }

      Status status = Status(
        uid: uid,
        username: username,
        phoneNumber: phoneNumber,
        photoUrl: statusImageUrls,
        createdAt: DateTime.now(),
        profilePic: profilePic,
        statusId: statusId,
        whoCanSee: uidWhoCanSee,
      );

      await firestore.collection('status').doc(statusId).set(status.toMap());
      // showSnackBar(context, 'Status upload');
      print('ggggggggggggggggggggg');
    } catch (e) {
      // showSnackBar(context: context, content: e.toString());
      showSnackBar(context, e.toString());
      print('PPPPPPPP' + e.toString());
    }
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statusData = [];
    try {
      // List<Contact> contacts = [];
      // if (await FlutterContacts.requestPermission()) {
      //   contacts = await FlutterContacts.getContacts(withProperties: true);
      // }
      // for (int i = 0; i < contacts.length; i++) {
      var statusesSnapshot = await firestore.collection('status').get();
      // .where(
      //   'phoneNo',
      //   isEqualTo: contacts[i].phones[0].number.replaceAll(
      //         ' ',
      //         '',
      //       ),
      // )
      // .where(
      //   'createdAt',
      //   isGreaterThan: DateTime.now()
      //       .subtract(const Duration(hours: 24))
      //       .millisecondsSinceEpoch,
      // )
      // .get();
      print(statusesSnapshot.docs);
      for (var tempData in statusesSnapshot.docs) {
        Status tempStatus = Status.fromMap(tempData.data());
        // if (tempStatus.whoCanSee.contains(auth.currentUser!.uid)) {
        statusData.add(tempStatus);
        // }
      }
      // }
    } catch (e) {
      if (kDebugMode) print(e);
      showSnackBar(context, e.toString());
    }
    return statusData;
  }
}
