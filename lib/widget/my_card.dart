import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ph_login/common/enums/message_enum.dart';
import 'package:ph_login/widget/Bottom_menu/bottom_menu4.dart';
import 'package:ph_login/widget/Bottom_menu/pdf_viewer.dart';
import 'package:ph_login/widget/display_file_messaage.dart';

class MyCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final String reciverUserId;
  final String messageId;
  final bool isSeen;
  final String userName;
  final DateTime timeSent;

  const MyCard({
    super.key,
    required this.message,
    required this.date,
    required this.type,
    required this.reciverUserId,
    required this.messageId,
    required this.isSeen,
    required this.userName,
    required this.timeSent,
    // required this.onLeftSwipe,
    // required this.repliedText,
    // required this.username,
    // required this.repliedMessageType,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () {
      //   if (type == MessageEnum.document) {
      //     // SfPdfViewer.network(
      //     //   message,
      //     // );
      //     print(message);
      //     Navigator.push(context, MaterialPageRoute(builder: ((context) {
      //       return HomePage(message);
      //     })));
      //   }
      // },
      onLongPress: () {
        showModalBottomSheet(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            context: context,
            builder: ((context) {
              return MessageMenu(
                type: type,
                message: message,
                reciverId: reciverUserId,
                messageId: messageId,
                date: DateFormat().add_yMMMEd().format(timeSent),
              );
            }));
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 45),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: const Color.fromARGB(255, 192, 218, 231),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Stack(
                children: [
                  Padding(
                    padding: type == MessageEnum.text
                        ? const EdgeInsets.only(
                            left: 10,
                            right: 85,
                            top: 5,
                            bottom: 20,
                          )
                        : const EdgeInsets.only(
                            left: 5,
                            right: 5,
                            top: 5,
                            bottom: 25,
                          ),
                    child: DisplayFileMessage(
                      message: message,
                      type: type,
                    ),
                    // Text(
                    //   message.toString(),
                    //   style: const TextStyle(
                    //     fontSize: 17,
                    //   ),
                    // ),
                  ),
                  Positioned(
                    // left: 5,
                    right: 10,
                    // top: 25,
                    bottom: 4,

                    child: Row(
                      children: [
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color.fromARGB(153, 70, 66, 47),
                            // color: Color.fromARGB(153, 56, 56, 56),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(
                          isSeen ? Icons.done_all : Icons.done,
                          size: 20,
                          color: isSeen
                              ? Colors.redAccent
                              : Color.fromARGB(153, 70, 66, 47),
                        ),
                      ],
                    ),
                  ),
                  //  Positioned(child: Text(userName)),
                ],
              ),
            )),
      ),
    );
  }
}
