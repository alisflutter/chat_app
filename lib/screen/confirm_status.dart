import 'dart:io';

import 'package:flutter/material.dart';

import 'package:ph_login/model/user_model.dart';
import 'package:ph_login/providers/status_provider.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class ConfirmStatus extends StatefulWidget {
  static String routeName = '/confirmStatus';
  // final File file;
  // final String username;
  // final String profilePic;
  ConfirmStatus({super.key});

  @override
  State<ConfirmStatus> createState() => _ConfirmStatusState();
}

class _ConfirmStatusState extends State<ConfirmStatus> {
//
  @override
  Widget build(BuildContext context) {
    final status = Provider.of<StatusProvider>(context);
    final users = Provider.of<Auth>(context);
    final file = ModalRoute.of(context)!.settings.arguments as File;
    // FirebaseAuth auth = FirebaseAuth.instance;

    void addStatus(BuildContext context, String name, String profilePic,
        String phoneNumber) {
      status.uploadStatus(
        username: name,
        //   auth.currentUser!.displayName.toString(),
        profilePic: profilePic,
        phoneNumber: phoneNumber, // auth.currentUser!.phoneNumber.toString(),
        statusImage: file,
        context: context,
      );
      print(name);
      Navigator.of(context, rootNavigator: true).pop();
      // Navigator.pop(context);
    }

    UserModel? user;

    return Scaffold(
      body: StreamBuilder<UserModel>(
          stream: users.getuserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            user = snapshot.data! as UserModel;
            print(user!.name);
            return Center(
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: Image.file(file),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
        onPressed: () =>
            addStatus(context, user!.name, user!.profilePic, user!.phoneNo),
      ),
    );
  }
}
