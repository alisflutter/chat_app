import 'package:flutter/material.dart';
import 'package:ph_login/widget/snackbar.dart';

import 'package:pinput/pinput.dart';

import 'package:provider/provider.dart';

import '../providers/auth.dart';

class OTP extends StatefulWidget {
  // String phone;

  // OTP({required this.phone});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  String phone = '+91 41124512';
  var islogin = false;
  @override
  Widget build(BuildContext context) {
    final verifi = Provider.of<Auth>(context);
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final verificationId = routeArgs['verifi'];

    // final number = ModalRoute.of(context)!.settings.arguments ;
    final number = routeArgs['phone'];
    var code = '';
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('OTP'),
      // ),
      backgroundColor: const Color.fromARGB(255, 245, 254, 254), //azure
      body: Center(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(left: 23, top: 80),
              child: const Text(
                'OTP Verification',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 143, 188, 143)),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                'Enter the OTP you received to ',
                style: TextStyle(fontSize: 18),
              ),
              width: double.infinity,
              margin: const EdgeInsets.only(top: 50),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                number.toString(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.all(12),
              child: Pinput(
                androidSmsAutofillMethod:
                    AndroidSmsAutofillMethod.smsRetrieverApi,
                defaultPinTheme: PinTheme(
                    width: 50,
                    height: 50,
                    textStyle: const TextStyle(
                        fontSize: 20,
                        color: Color.fromRGBO(30, 60, 87, 1),
                        fontWeight: FontWeight.w600),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(44, 175, 35, 35),
                          width: 3),
                      borderRadius: BorderRadius.circular(20),
                    )),
                length: 6,
                onChanged: (value) {
                  code = value;
                },
              ),
            ),
            // SizedBox(
            //   height: 10,
            // ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 42, left: 20, right: 20),
              child: ElevatedButton(
                // style: ElevatedButton.styleFrom(
                //     padding: EdgeInsets.only(
                //         left: 20, right: 20, top: 13, bottom: 13),
                //     backgroundColor: Colors.amber),
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

                child: islogin
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Text(
                        'Verify',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                onPressed: () async {
                  setState(() {
                    islogin = true;
                  });
                  try {
                    // //
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: ((context) => UserName()),
                    //   ),
                    // );
// new
                    verifi.verifiOtp(
                        context, verificationId!, code, number.toString());
                  } catch (e) {
                    showSnackBar(context, 'worng otp');
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
