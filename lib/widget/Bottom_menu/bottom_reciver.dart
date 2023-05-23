import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:ph_login/widget/snackbar.dart';
import 'package:provider/provider.dart';

import '../../common/enums/message_enum.dart';
import '../../providers/chat.dart';

class ReciverMenuC extends StatefulWidget {
  MessageEnum type;
  String message;
  String dateTime;

  ReciverMenuC({
    required this.type,
    required this.message,
    required this.dateTime,
  });

  @override
  State<ReciverMenuC> createState() => _ReciverMenuCState();
}

class _ReciverMenuCState extends State<ReciverMenuC> {
  @override
  Widget build(BuildContext context) {
    // final messageChat = Provider.of<Chat>(context, listen: false);
    return ListView(
      shrinkWrap: true,
      children: [
        //black divider
        Container(
          width: 5,
          height: 4,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 170),
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(8)),
        ),

        widget.type == MessageEnum.text
            ?
            //copy option
            _OptionItem(
                icon: const Icon(Icons.copy_all_rounded,
                    color: Colors.blue, size: 30),
                name: 'Copy Text',
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: widget.message))
                      .then((value) {
                    //for hiding bottom sheet
                    Navigator.pop(context);
                    showSnackBar(context, 'Text Copied!');
                    //  Dialogs.showSnackbar(context, 'Text Copied!');
                  });
                })
            :
            //save option
            _OptionItem(
                icon: const Icon(Icons.download_rounded,
                    color: Colors.blue, size: 30),
                name: 'Save Image',
                onTap: () async {
                  try {
                    // print('Image Url: ${widget.message}');
                    if (widget.type == MessageEnum.image) {
                      await GallerySaver.saveImage(widget.message,
                              albumName: 'Chat')
                          .then((success) {
                        //for hiding bottom sheet
                        Navigator.pop(context);
                        if (success != null && success) {
                          showSnackBar(context, 'Image Successfully Saved!');
                          // Dialogs.showSnackbar(
                          //     context, 'Image Successfully Saved!');
                        }
                      });
                    } else {
                      await GallerySaver.saveVideo(widget.message,
                              albumName: 'Chat')
                          .then((success) {
                        //for hiding bottom sheet
                        Navigator.pop(context);
                        if (success != null && success) {
                          showSnackBar(context, 'Video Successfully Saved!');
                          // Dialogs.showSnackbar(
                          //     context, 'Image Successfully Saved!');
                        }
                      });
                    }
                  } catch (e) {
                    print(e);
                  }
                }),

        //separator or divider
        // if (isMe)
        const Divider(
          color: Colors.black54,
          endIndent: 6,
          indent: 6,
        ),
        _OptionItem(
            icon: const Icon(
              Icons.info,
              size: 30,
            ),
            name: widget.dateTime,
            onTap: (() {})),

        // _OptionItem(
        //     icon: const Icon(Icons.delete_forever, color: Colors.red, size: 30),
        //     name: 'Delete Message',
        //     onTap: () async {
        //       await messageChat.deleteMessage(
        //           widget.messageId, widget.reciverId, widget.type);

        //       //for hiding bottom sheet
        //       Navigator.pop(context);
        //       //   });
        //     }),

        const SizedBox(
          height: 10,
        )

        //sent time
        // _OptionItem(
        //     icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
        //     name:
        //         'Sent At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
        //     onTap: () {}),

        //read time
      ],
    );
  }
}

//
class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
          child: Row(children: [
            icon,
            Flexible(
                child: Text('    $name',
                    style: const TextStyle(
                        fontSize: 17, color: Colors.black, letterSpacing: 0.5)))
          ]),
        ));
  }
}
