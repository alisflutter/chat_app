import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ph_login/model/group.dart';
import 'package:ph_login/model/user_model.dart';
import 'package:ph_login/widget/member_info.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class ReciverProfile extends StatelessWidget {
  final String Ruid;
  final bool isGroup;
  ReciverProfile({required this.Ruid, required this.isGroup});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context);
    var data = user.getReciverUser(Ruid);
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    groupInfo() {
      return Column(
        children: [
          Container(
            child: StreamBuilder(
              stream: firestore.collection('groups').doc(Ruid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                //  UserModel userModel = snapshot.data as UserModel;
                // Group groupInfo = snapshot.data as Group;
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Center(
                        // child: CircleAvatar(
                        //   backgroundImage: userModel.profilePic,
                        //   radius: 60,
                        // ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          // child: Image.network(
                          //   'https://3.bp.blogspot.com/-h8xPYD07uh0/Wr835tAa5EI/AAAAAAAABFk/RhF22VQEfqoflTJedHKJOO3T5OTMnsUawCLcBGAs/s1600/Arijit%2BSingh.jpg',
                          //   height: 100,
                          //   width: 100,
                          //   fit: BoxFit.fill,
                          // )
                          child: CachedNetworkImage(
                            imageUrl: snapshot.data!['groupPic'].toString(),
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
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        snapshot.data!['name'],
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          //
          SizedBox(
            height: 10,
          ),
          Container(
            child: StreamBuilder(
                stream: firestore.collection('groups').doc(Ruid).snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    // if(snapshot.data["about"] != null){
                    //   //  groupAbout = snapshot.data["about"];
                    // }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data["membersUid"].length,
                      itemBuilder: (context, index) {
                        // return Text(snapshot.data['membersUid'][index]);
                        return MemberInfo(
                            Muid: snapshot.data['membersUid'][index]);
                        // print(snapshot.data["membersUid"][index]);
                      },
                    );
                  } else {
                    return const CircularProgressIndicator(
                      color: Colors.white,
                    );
                  }
                }),
          )
        ],
      );
    }

    //
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            isGroup
                ? groupInfo()
                : StreamBuilder(
                    stream: data,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      UserModel userModel = snapshot.data as UserModel;
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 20, bottom: 10),
                            child: Center(
                              // child: CircleAvatar(
                              //   backgroundImage: userModel.profilePic,
                              //   radius: 60,
                              // ),
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
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              userModel.name,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(15),
                            alignment: Alignment.center,
                            child: Text(
                              userModel.phoneNo,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
