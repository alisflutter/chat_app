import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ph_login/widget/Bottom_menu/bottom_reciver.dart';
import 'package:ph_login/widget/display_file_messaage.dart';

import '../common/enums/message_enum.dart';

class SenderCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final DateTime dateTime;

  const SenderCard({
    super.key,
    required this.message,
    required this.date,
    required this.type,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () => showModalBottomSheet(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          context: context,
          builder: (context) {
            return ReciverMenuC(
              type: type,
              message: message,
              dateTime: DateFormat().add_yMMMEd().format(dateTime),
            );
          }),
      child: Align(
        alignment: Alignment.centerLeft,
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
                            right: 45,
                            top: 5,
                            bottom: 24,
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
                    //   message,
                    //   style: const TextStyle(
                    //     fontSize: 17,
                    //   ),
                    // ),
                  ),
                  Positioned(
                    left: 10,
                    // top: 25,
                    bottom: 5,
                    child: Row(
                      children: [
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(153, 56, 56, 56),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
