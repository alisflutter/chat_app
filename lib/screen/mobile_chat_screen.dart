import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ph_login/model/call.dart';

import 'package:ph_login/model/user_model.dart';
import 'package:ph_login/providers/auth.dart';
import 'package:ph_login/providers/wallpaper.dart';

import 'package:ph_login/screen/reciver_profile_screen.dart';
import 'package:ph_login/widget/bottom_chat_field.dart';
import 'package:ph_login/widget/call_invitation_page.dart';
import 'package:ph_login/widget/chat_list.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../providers/group_provider.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class MChatScreen extends StatefulWidget {
  const MChatScreen({super.key});

  @override
  State<MChatScreen> createState() => _MChatScreenState();
}

class _MChatScreenState extends State<MChatScreen> {
  bool isShowButton = false;
  final TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth2 = Provider.of<Auth>(context, listen: false);
    final groups = Provider.of<GroupProvider>(context);
    final wallpapers = Provider.of<Wallpaper>(context);
    // final call = Provider.of<CallProvider>(context);
    final routeArg =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String name = routeArg['name'];
    String uid = routeArg['uid'];
    bool isGroup = routeArg['isGroup'];
    // String profilepic = routeArg['profilePic'];
    // String phoneNo = routeArg['phoneNo'];

    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    String callId = const Uuid().v1();
    // final num = "+919913448401";
    var num;
    // String aaa =
    //     auth2.getuserData().single.then((value) => value.profilePic) as String;

    // Call sender = Call(callerId: firebaseAuth.currentUser!.uid, callerName: firebaseAuth.currentUser!.displayName!, callerPic: aaa, receiverId: uid, receiverName: name, receiverPic: profilepic, callId: callId, hasDialled: hasDialled,);

    // void makeCall() {
    //
    //   Call sender = Call(
    //       callerId: firebaseAuth.currentUser!.uid,
    //       callerName: firebaseAuth.currentUser!.displayName.toString(),
    //       callerPic: '',
    //       receiverId: uid,
    //       receiverName: name,
    //       receiverPic: profilepic,
    //       callId: callId,
    //       hasDialled: true);
    //   Call reciever = Call(
    //     callerId: firebaseAuth.currentUser!.uid,
    //     callerName: firebaseAuth.currentUser!.displayName.toString(),
    //     callerPic: '',
    //     receiverId: uid,
    //     receiverName: name,
    //     receiverPic: profilepic,
    //     callId: callId,
    //     hasDialled: false,
    //   );
    //   if (isGroup) {
    //     call.makeGroupCall(sender, context, reciever);
    //   } else {
    //     call.makeCall(sender, context, reciever);
    //   }
    // }

    return Scaffold(
      backgroundColor: Color(wallpapers.ttttt),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: isGroup
            ? InkWell(
                child: Text(name),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) {
                    return ReciverProfile(
                      Ruid: uid,
                      isGroup: true,
                    );
                  })));
                },
              )
            : InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) {
                    return ReciverProfile(
                      Ruid: uid,
                      isGroup: false,
                    );
                  })));
                },
                child: StreamBuilder<UserModel>(
                    stream: auth2.userData(uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(' ');
                      }
                      num = snapshot.data!.phoneNo;
                      return Column(
                        children: [
                          Text(name),
                          Text(
                            snapshot.data!.isOnline ? 'Online' : 'Offline',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      );
                    }),
              ),
        actions: [
          // IconButton(
          //   onPressed: () async {
          //     launch('sms://$num');
          //     //  makeCall();
          //     // Navigator.push(context, MaterialPageRoute(builder: ((context) {
          //     //   return CallInvitationPage(
          //     //     callId: callId,
          //     //     username: name,
          //     //   );
          //     // })));
          //   },
          //   icon: const Icon(Icons.message),
          // ),
          Container(
            padding: const EdgeInsets.all(10),
            // width: 50,
            // height: 50,
            child: isGroup
                ? null
                : IconButton(
                    onPressed: () async {
                      launch('tel://$num');
                    },
                    icon: isGroup ? Icon(Icons.abc) : Icon(Icons.call),
                  ),
          ),
          // Container(
          //   width: 50,
          //   height: 50,
          //   child: GestureDetector(
          //     child: isGroup ? null : Icon(Icons.call),
          //     onTap: () async {
          //       launch('tel://$num');
          //     },
          //   ),
          // ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(
              recieverId: uid,
              isGroupChat: isGroup,
              userName: firebaseAuth.currentUser!.displayName.toString(),
            ),
          ),
          BottomChatField(
            uid,
            isGroup,
          ),
        ],
      ),
    );
  }

  // ZegoAcceptInvitationButton actionButton(
  //     bool isVideo, String uid, String name) {
  //   ZegoSendCall(
  //     isVideoCall: true,
  //     resourceID: "zegouikit_call", // For offline call notification
  //     invitees: [
  //       ZegoUIKitUser(
  //         id: targetUserID,
  //         name: targetUserName,
  //       ),
  //     ],
  //   );
  // }

  // void makecall() {
  //   ZegoCall(
  //     isVideoCall: true,
  //     resourceID: "zegouikit_call", // For offline call notification
  //     invitees: [
  //       ZegoUIKitUser(
  //         id: targetUserID,
  //         name: targetUserName,
  //       ),
  //     ],
  //   );
  // }

  // ZegoAcceptInvitationButton aaaaa(String callId) {
  //   return ZegoAcceptInvitationButton(
  //     inviterID: callId,
  //   );
  // }

  //
}
