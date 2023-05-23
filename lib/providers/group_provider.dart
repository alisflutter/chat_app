import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:ph_login/model/group.dart' as model;
import 'package:ph_login/widget/snackbar.dart';
import 'package:uuid/uuid.dart';

class GroupProvider with ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  var groupId;
  void createGroup(BuildContext context, String name, File profilePic,
      List<Contact> selectedContact) async {
    try {
      List<String> uids = [];
      for (int i = 0; i < selectedContact.length; i++) {
        var userCollection = await firestore
            .collection('users')
            .where(
              'phoneNo',
              isEqualTo: selectedContact[i].phones[0].number.replaceAll(
                    ' ',
                    '',
                  ),
            )
            .get();

        if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
          uids.add(userCollection.docs[0].data()['uid']);
        }
      }
       groupId = const Uuid().v1();

      //
      UploadTask uploadTask =
          firebaseStorage.ref().child('/group/$groupId').putFile(profilePic);
      TaskSnapshot snapshot = await uploadTask;
      String imageurl = await snapshot.ref.getDownloadURL();
      //

      model.Group group = model.Group(
          senderId: auth.currentUser!.uid,
          name: name,
          groupId: groupId,
          lastMessage: '',
          groupPic: imageurl,
          membersUid: [auth.currentUser!.uid, ...uids],
          timeSent: DateTime.now());

      await firestore.collection('groups').doc(groupId).set(group.toMap());
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
