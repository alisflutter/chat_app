import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ph_login/home.dart';
import 'package:ph_login/widget/snackbar.dart';

import 'package:provider/provider.dart';

import '../model/user_model.dart';
import '../providers/auth.dart';

class UserName extends StatefulWidget {
  @override
  State<UserName> createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  var name = TextEditingController();
  var email = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  bool ff = false;
    //checkUserRegister(phone, context)
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Auth>(context);
    final pNumber = ModalRoute.of(context)!.settings.arguments as String;

    var res = data.checkUserRegister(pNumber, context);

    return FutureBuilder<bool>(
        future: res,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!
                ? const Home()
                : userInfo(name: name, email: email, data: data);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }));
  }
}

class userInfo extends StatelessWidget {
  const userInfo({
    Key? key,
    required this.name,
    required this.email,
    required this.data,
  }) : super(key: key);

  final TextEditingController name;
  final TextEditingController email;
  final Auth data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Your details', style: TextStyle(color: Colors.black)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: const Color.fromARGB(255, 245, 254, 254),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(
                  top: 30, left: 17, right: 17, bottom: 10),
              child: TextFormField(
                controller: name,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  labelText: 'Enter Name',
                  labelStyle: const TextStyle(
                      fontSize: 17, color: Color.fromARGB(255, 53, 72, 53)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 90, 136, 90), width: 2),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 20, left: 17, right: 17, bottom: 10),
              child: TextFormField(
                controller: email,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  labelText: 'Enter Email',
                  labelStyle: const TextStyle(
                      fontSize: 17, color: Color.fromARGB(255, 53, 72, 53)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 90, 136, 90), width: 2),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
              child: ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.only(
                              left: 30, right: 30, top: 13, bottom: 13)),
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 143, 188, 143)),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      )), //
                  onPressed: (() {
                    // createUser();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: ((context) => const Home()),
                    //   ),
                    // );
                    if (name.text.isNotEmpty || email.text.isNotEmpty) {
                      data.storeUserData(name.text, email.text, null, context);
                    } else {
                      showSnackBar(context, 'Filed are empty');
                    }
                  }),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
