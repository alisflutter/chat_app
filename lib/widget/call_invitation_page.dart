// import 'package:flutter/material.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

// final appId = 1899916103;
// final appSign =
//     "b0c04f7aa2a2af4066f5ab11a175b5f6aa52528a53f66d09c39b845ed399f599";

// class CallInvitationPage extends StatelessWidget {
//   const CallInvitationPage({
//     super.key,
//     required this.username,
//     required this.callId,
//   });

//   final String callId;
//   final String username;

//   @override
//   Widget build(BuildContext context) {
//     return ZegoUIKitPrebuiltCall(
//         appID: appId,
//         appSign: appSign,
//         userID: username,
//         userName: username,
//         callID: callId,

//         // Modify your custom configurations here.
//         config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
//         // ..onOnlySelfInRoom = () {
//         //   Navigator.of(context).pop();
//         // },
//         // ..layout = ZegoLayout.pictureInPicture(
//         //   // isSmallViewDraggable: true,
//         //   // switchLargeOrSmallViewByClick: true,
//         // ),
//         );
//   }
// }
