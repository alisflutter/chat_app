import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ph_login/model/user_model.dart';
import 'package:ph_login/screen/confirm_status.dart';
import 'package:ph_login/screen/qr_screen.dart';
import 'package:ph_login/widget/Bottom_menu/bottom_menu3.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../widget/pick_file.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context);

    // use bottom_menu3.dart
    void _selectImageGallery() async {
      File? image = await pickImage(context);

      if (image != null) {
        user.uploadProfile(image, context);
        // sendFile(image, MessageEnum.image);
      }
      // Navigator.pop(context);
    }

    //
    void _selectImageCamera() async {
      File? image = await pickImageCamera(context);

      if (image != null) {
        user.uploadProfile(image, context);
        // sendFile(image, MessageEnum.image);
      }
      // Navigator.pop(context);
    }

    //

    return Scaffold(
      body: Column(
        children: [
          // Container(
          //   margin: EdgeInsets.only(top: 50, right: 20),
          //   alignment: Alignment.centerRight,
          //   child: IconButton(
          //     color: Colors.blueGrey,
          //     icon: const Icon(
          //       Icons.qr_code,
          //       color: Colors.black,
          //     ),
          //     onPressed: () {

          //       Navigator.push(context, MaterialPageRoute(builder: ((context) {
          //         return QrScreen();
          //       })));
          //     },
          //   ),
          // ),
          SingleChildScrollView(
            child: StreamBuilder<Object>(
                stream: user.getuserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  UserModel userModel = snapshot.data as UserModel;

                  final name = TextEditingController(text: userModel.name);
                  final email = TextEditingController(text: userModel.email);
                  final phone = TextEditingController(text: userModel.phoneNo);
                  // ConfirmStatus(
                  //   username: userModel.name,
                  //   profilePic: userModel.profilePic,
                  // );
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 50, right: 20),
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          // color: Colors.black,
                          // splashColor: Colors.blueGrey,
                          icon: const Icon(
                            Icons.qr_code_2_outlined,
                            //  color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: ((context) {
                              return QrScreen(
                                userName: userModel.name,
                                userPhone: userModel.phoneNo,
                                uid: userModel.uid,
                              );
                            })));
                          },
                        ),
                      ),
                      Container(
                        //  color: Colors.amberAccent,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 10),
                        child: InkWell(
                          onTap: () {
                            print(name);
                            showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                              )),
                              context: context,
                              builder: ((context) {
                                return BottomMenu(
                                  image: _selectImageGallery,
                                  camera: _selectImageCamera,
                                );
                              }),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            // child: Image.network(
                            //   'https://3.bp.blogspot.com/-h8xPYD07uh0/Wr835tAa5EI/AAAAAAAABFk/RhF22VQEfqoflTJedHKJOO3T5OTMnsUawCLcBGAs/s1600/Arijit%2BSingh.jpg',
                            //   height: 100,
                            //   width: 100,
                            //   fit: BoxFit.fill,
                            // )
                            child: CachedNetworkImage(
                              imageUrl: userModel.profilePic,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.person),
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 30, left: 16, right: 16, bottom: 10),
                              child: TextFormField(
                                controller: name,
                                // initialValue: userModel.name,
                                style: const TextStyle(fontSize: 20),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    // color: Colors.black,
                                  ),
                                  labelText: 'Name',
                                  // labelStyle: const TextStyle(
                                  //     fontSize: 17,
                                  //     color: Color.fromARGB(255, 53, 72, 53)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  // focusedBorder: OutlineInputBorder(
                                  //   borderRadius: BorderRadius.circular(15),
                                  //   borderSide: const BorderSide(
                                  //       color: Color.fromARGB(255, 90, 136, 90),
                                  //       width: 2),
                                  // ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 10, left: 16, right: 16, bottom: 10),
                              child: TextFormField(
                                controller: email,
                                // initialValue: userModel.email,

                                style: const TextStyle(fontSize: 20),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.email,
                                    // color: Colors.black,
                                  ),
                                  labelText: 'Email',
                                  // labelStyle: const TextStyle(
                                  //     fontSize: 17,
                                  //     color: Color.fromARGB(255, 53, 72, 53)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  // focusedBorder: OutlineInputBorder(
                                  //   borderRadius: BorderRadius.circular(15),
                                  //   borderSide: const BorderSide(
                                  //       color: Color.fromARGB(255, 90, 136, 90),
                                  //       width: 2),
                                  // ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 10, left: 16, right: 16, bottom: 10),
                              child: TextFormField(
                                readOnly: true,
                                //  controller: name,
                                initialValue: userModel.phoneNo,
                                //  initialValue: user.getUserInfo().name,
                                style: const TextStyle(fontSize: 20),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.call,
                                    // color: Colors.black,
                                  ),
                                  labelText: 'Mobile No',
                                  // labelStyle: const TextStyle(
                                  //     fontSize: 17,
                                  //     color: Color.fromARGB(255, 53, 72, 53)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  // focusedBorder: OutlineInputBorder(
                                  //   borderRadius: BorderRadius.circular(15),
                                  //   borderSide: const BorderSide(
                                  //       color: Color.fromARGB(255, 90, 136, 90),
                                  //       width: 2),
                                  // ),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(
                                  top: 30, left: 50, right: 50),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      padding:
                                          MaterialStateProperty.all<EdgeInsets>(
                                              const EdgeInsets.only(
                                                  left: 30,
                                                  right: 30,
                                                  top: 13,
                                                  bottom: 13)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              const Color.fromARGB(
                                                  255, 143, 188, 143)),
                                      shape: MaterialStateProperty.all<
                                          OutlinedBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      )), //
                                  onPressed: (() async {
                                    user.updateUser(
                                      name.text.toString(),
                                      email.text.toString(),
                                    );
                                  }),
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  )),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
