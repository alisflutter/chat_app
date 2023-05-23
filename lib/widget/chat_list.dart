import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:ph_login/common/encryptAES.dart';
import 'package:ph_login/common/enums/message_enum.dart';
import 'package:ph_login/providers/wallpaper.dart';

import 'package:ph_login/widget/my_card.dart';
import 'package:ph_login/widget/sender_card.dart';
import 'package:provider/provider.dart';

import '../providers/chat.dart';

class ChatList extends StatefulWidget {
  final String recieverId;
  final bool isGroupChat;
  final String userName;
  // final int color;
  ChatList({
    required this.recieverId,
    required this.isGroupChat,
    required this.userName,
    // required this.color
  });

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ScrollController messageController = ScrollController();
  int cccc = 0;
  // late var wallpapers;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  didChangeDependencies();
    // aaa();
  }

  @override
  Widget build(BuildContext context) {
    final messageChat = Provider.of<Chat>(context);
    final wallpapers = Provider.of<Wallpaper>(context);
    print(widget.userName + 'MMMMMMMM');
    //  wallpapers.saveColor();
    // Color(wallpapers.getColor() as int)
    // print(wallpapers.getColor().then((value) => value).toString());
    // int rrr = wallpapers.ssss == null ? 0 : wallpapers.ssss;

    // print(wallpapers.ssss == null ? 0 : wallpapers.ssss);

    // Future<Color> aaa() async {
    //   await wallpapers.saveColor();
    //   //  setState(() async {
    //   int cccc = await wallpapers.getColor();
    //   // });
    //   return Color(cccc) as Color;

    //   print(cccc);
    // }

    // aaa();

    return Scaffold(
      backgroundColor: Color(wallpapers.ttttt),
      body: StreamBuilder(
          stream: widget.isGroupChat
              ? messageChat.getGroupChat(widget.recieverId)
              : messageChat.getchatMessage(widget.recieverId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return buildText('Something Went Wrong Try later');
            } else if (snapshot.data!.isEmpty) {
              return buildText('Say Hi..');
            }
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              messageController
                  .jumpTo(messageController.position.maxScrollExtent);
            });
            return ListView.builder(
              controller: messageController,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var timeSent = DateFormat()
                    .add_jm()
                    .format(snapshot.data![index].timeSent);
                var type2 = snapshot.data![index].type;
                if (!snapshot.data![index].isSeen &&
                    snapshot.data![index].recieverid ==
                        FirebaseAuth.instance.currentUser!.uid) {
                  messageChat.setChatMessageSeen(context, widget.recieverId,
                      snapshot.data![index].messageId);
                }
                //

                if (snapshot.data![index].senderId ==
                    FirebaseAuth.instance.currentUser!.uid) {
                  return MyCard(
                    message: type2 == MessageEnum.text
                        ? MyEncryptDecrypt().decryptAES(
                            snapshot.data![index].text,
                          )
                        : snapshot.data![index].text,
                    // message: snapshot.data![index].text,
                    date: timeSent,
                    type: snapshot.data![index].type,
                    reciverUserId: snapshot.data![index].recieverid,
                    messageId: snapshot.data![index].messageId,

                    isSeen: snapshot.data![index].isSeen,
                    userName: widget.userName,
                    timeSent: snapshot.data![index].timeSent,
                  );
                }
                return SenderCard(
                  message: // snapshot.data![index].text,
                      type2 == MessageEnum.text
                          ? MyEncryptDecrypt()
                              .decryptAES(snapshot.data![index].text)
                          : snapshot.data![index].text,
                  date: timeSent,
                  type: snapshot.data![index].type,
                  dateTime: snapshot.data![index].timeSent,
                );
              },
            );
          }),
    );
  }

//
  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
        ),
      );
}
