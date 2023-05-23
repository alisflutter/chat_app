//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:ph_login/home.dart';
import 'package:ph_login/providers/auth.dart';
import 'package:ph_login/widget/snackbar.dart';
//import 'package:ph_login/screen/otp.dart';
import 'package:provider/provider.dart';

//import '../widget/snackbar.dart';

class Login extends StatefulWidget {
  // static String verifiy = '';
  // static String phone = '';
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var code = '+91';
  String phoneNo = '';

  var islogin = false;
//

  late ConnectivityResult result;
  late StreamSubscription subscription;
  var isConnected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startStreaming();
  }

  checkInternet() async {
    result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      isConnected = true;
    } else {
      isConnected = false;
      showDialogBox();
    }
    setState(() {});
  }

  showDialogBox() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: const Text("No Internet"),
            content: const Text('Please check your internet connection'),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  checkInternet();
                },
                child: const Text('Retry'),
              )
            ],
          );
        }));
  }

  startStreaming() {
    subscription = Connectivity().onConnectivityChanged.listen((event) async {
      checkInternet();
    });
  }

//
  @override
  Widget build(BuildContext context) {
    final auth2 = Provider.of<Auth>(context);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('welcome '),
      // ),
      // backgroundColor: const Color.fromARGB(255, 245, 254, 254),
      body: auth2.checkUser()
          ? const Home()
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(50),
                    alignment: Alignment.center,
                    child: const Text(
                      'Welcome',
                      style: TextStyle(
                        color: Color.fromARGB(255, 143, 188, 143),
                        fontSize: 35,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Enter your Phone no!',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 50, bottom: 15),
                  ),
                  Container(
                    width: double.infinity,
                    margin:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                    //  padding: EdgeInsets.all(15),
                    alignment: Alignment.center,
                    // height: 40,
                    child: const Text(
                      'We will send you an OTP on this mobile number',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    //  padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 1,
                          style: BorderStyle.solid,
                        )),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 15, right: 5),
                          child: const Text(
                            '+91',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          width: 15,
                          child: const Text(
                            '|',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),

                            // controller: phoneNo,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter phone no',
                            ),
                            onChanged: (value) {
                              //  setState(() {
                              phoneNo = value;
                              //  });
                            },
                            keyboardType: TextInputType.phone,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: TextButton(
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
                          )),
                      onPressed: () async {
                        setState(() {
                          islogin = true;
                        });
                        print(islogin);

                        // try {
                        //   setState(() {
                        //     islogin = true;
                        //   });
                        //   firebaseAuth.verifyPhoneNumber(
                        //       phoneNumber: '${code + phoneNo}',
                        //       verificationCompleted:
                        //           (PhoneAuthCredential credential) {},
                        //       verificationFailed: (FirebaseAuthException e) {},
                        //       codeSent: (String verificationId,
                        //           int? resendToken) async {
                        //         Navigator.pushReplacementNamed(context, '/otp',
                        //             arguments: {
                        //               'verifi': verificationId,
                        //               'phone': '${code + phoneNo}'
                        //             });
                        //       },
                        //       codeAutoRetrievalTimeout:
                        //           (String verificationId) {});
                        //   setState(() {
                        //     islogin = false;
                        //   });
                        // } on FirebaseAuthException catch (e) {
                        //   print(e.message);
                        //   showSnackBar(context, 'Invaild PhoneNo');
                        // }

                        //
                        if (phoneNo.isNotEmpty) {
                          auth2.verifiNumber(context, '${code + phoneNo}');
                        } else {
                          showSnackBar(context, 'Enter Phone No!');
                        }

                        // setState(() {
                        //   islogin = false;
                        // });

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: ((context) => OTP()),
                        //   ),
                        // );
                      },
                      child: islogin
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Text(
                              'Genrate OTP',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
