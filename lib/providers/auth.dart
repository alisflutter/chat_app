import 'dart:async';

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:ph_login/model/group.dart' as model;

import 'package:ph_login/model/user_model.dart';
import 'package:ph_login/widget/snackbar.dart';

class Auth with ChangeNotifier {
  // FirebaseAuth firebaseAuth = null;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  bool checkUser() {
    if (firebaseAuth.currentUser == null) {
      return false;
    } else {
      return true;
    }
  }

//

  // Future<UserModel?> getCurrentUserData() async {
  //   var userData = await firestore
  //       .collection('users')
  //       .doc(firebaseAuth.currentUser?.uid)
  //       .get();

  //   UserModel? user;
  //   if (userData.data() != null) {
  //     user = await UserModel.fromMap(userData.data()!);
  //   }
  //   return user;
  // }

// Phone no //
  void verifiNumber(BuildContext context, String phoneno) async {
    try {
      showSnackBar(context, 'OTP sent');
      firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneno,
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {},
          codeSent: (String verificationId, int? resendToken) async {
            Navigator.pushReplacementNamed(context, '/otp',
                arguments: {'verifi': verificationId, 'phone': phoneno});
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
      print(e.message);
      showSnackBar(context, 'Invaild PhoneNo');
    }
  }

// verifi otp //

  void verifiOtp(BuildContext context, String verificationId, String userOtp,
      String phone) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);
      await firebaseAuth.signInWithCredential(credential).then((value) =>
          Navigator.of(context)
              .pushReplacementNamed('/name', arguments: phone));
    } on FirebaseAuthException catch (e) {
      print(e.message);
      showSnackBar(context, 'Invaild OTP');
    }
  }

// user data store firebase firestore //

  void storeUserData(
      String name, String email, File? profile, BuildContext context) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      // add pic profile pic  and store

      var user = UserModel(
          name: name,
          email: email,
          profilePic: '',
          isOnline: true,
          uid: uid,
          phoneNo: firebaseAuth.currentUser!.phoneNumber.toString(),
          groupID: []);

      await firestore.collection('users').doc(uid).set(user.toMap());

      Navigator.of(context).pushReplacementNamed('/home');
    } on FirebaseAuthException catch (e) {
      print(e.message);
      showSnackBar(context, e.message.toString());
    }
  }

//

  Stream<UserModel> userData(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }

  //

// already register

  Future<bool> checkUserRegister(String phone, BuildContext context) async {
    //bool f = false;
    bool isFound = false;
    try {
      var usersCollection = await firestore.collection('users').get();

      for (var document in usersCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectPhone = phone;

        print(selectPhone);
        print(userData.phoneNo);
        if (selectPhone == userData.phoneNo) {
          isFound = true;
          // sss = true;
          //   Navigator.of(context).pushReplacementNamed('/home');
          return isFound; // register
        }
        // } else {
        //   isFound = false;
        //   return isFound;
        // }
      }
      // return false;

      if (!isFound) {
        isFound = false;

        return isFound; // login

      }

      // return false;
    } catch (e) {
      print(e);
    }
    //  isFound = false;
    return false;
  }

  //

//  online and ofline
  // void setUserState(bool isOnline) async {
  //   await firestore
  //       .collection('users')
  //       .doc(firebaseAuth.currentUser!.uid)
  //       .update({
  //     'isOnline': isOnline,
  //   });
  // }

// user info

  Stream<UserModel> getuserData() {
    String uid = firebaseAuth.currentUser!.uid;
    return firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }

//

  // user data update
  Future<void> updateUser(String name, String email) async {
    String uid = firebaseAuth.currentUser!.uid;
    await firestore.collection('users').doc(uid).update({
      'name': name,
      'email': email,
    });
  }
  //

// update user profile
  void uploadProfile(File file, BuildContext context) async {
    UploadTask uploadTask = firebaseStorage
        .ref()
        .child(
          'profile/${firebaseAuth.currentUser!.uid} ',
        )
        .putFile(file);
    TaskSnapshot snap = await uploadTask;
    String profileUrl = await snap.ref.getDownloadURL();

    await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update({
      'profilePic': profileUrl,
    });
    Navigator.pop(context);
  }

  //
  // reciver user data
  Stream<UserModel> getReciverUser(String uid) {
    //  String uid = firebaseAuth.currentUser!.uid;
    return firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }

//

  void deleteAccount(BuildContext context) {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      firestore.collection('users').doc(uid).delete();
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

//
  // Stream<UserModel> getGroupUser(String guid) {
  //   //  String uid = firebaseAuth.currentUser!.uid;
  //   return firestore.collection('groups').doc(guid).snapshots();
  //   // .map((event) => model.Group.fromMap(event.data()!));
  // }

  //
}
