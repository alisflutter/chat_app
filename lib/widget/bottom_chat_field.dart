import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:ph_login/widget/pick_file.dart';
import 'package:ph_login/widget/snackbar.dart';
import 'package:provider/provider.dart';

import '../common/encryptAES.dart';
import '../common/enums/message_enum.dart';
import '../model/user_model.dart';
import '../providers/auth.dart';
import '../providers/chat.dart';
import 'Bottom_menu/file_menu2.dart';

class BottomChatField extends StatefulWidget {
  final String uid;
  final bool isGroupChat;
  const BottomChatField(this.uid, this.isGroupChat, {super.key});

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  bool isShowButton = false;
  final TextEditingController messageController = TextEditingController();
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isRecording = false;
  bool isShowEmojiContainer = false;
  FocusNode focusNode = FocusNode();
  // final messageReply = ref.read(messageReplyProvider);

  @override
  void initState() {
    // TODO: implement initState

    _soundRecorder = FlutterSoundRecorder();
    openAudio();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed!');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  //

  @override
  Widget build(BuildContext context) {
    final auth2 = Provider.of<Auth>(context, listen: false);
    // final routeArg =
    //     ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // // String name = routeArg['name'];
    // String uid = routeArg['uid'];
    final chats = Provider.of<Chat>(context, listen: false);

    // String texts = MyEncryptDecrypt.encryptAES(messageController.text.trim());

    void _sendTextMessage() async {
      if (isShowButton) {
        chats.sendTextMessage(
          context: context,
          text: MyEncryptDecrypt().encryptAES(messageController.text.trim()),
          //messageController.text.trim(),
          reciverUserId: widget.uid,
          sendUser: UserModel(
            name: auth2.firebaseAuth.currentUser!.displayName.toString(),
            email: auth2.firebaseAuth.currentUser!.email.toString(),
            profilePic: '',
            isOnline: true,
            uid: auth2.firebaseAuth.currentUser!.uid.toString(),
            phoneNo: auth2.firebaseAuth.currentUser!.phoneNumber.toString(),
            groupID: [],
          ),
          isGroupChat: widget.isGroupChat,
        );
        setState(() {
          messageController.text = '';
        });
      } else {
        var temdir = await getTemporaryDirectory();
        var path = '${temdir.path}/flutter_ssound.aac';
        if (!isRecorderInit) {
          return;
        }
        if (isRecording) {
          showSnackBar(context, 'Stop recording');
          print('object');
          await _soundRecorder!.stopRecorder();
          chats.sendFileMessage(
            context: context,
            file: File(path),
            reciverUserId: widget.uid,
            senderUserData: UserModel(
              name: auth2.firebaseAuth.currentUser!.displayName.toString(),
              email: auth2.firebaseAuth.currentUser!.email.toString(),
              profilePic: '',
              isOnline: true,
              uid: auth2.firebaseAuth.currentUser!.uid.toString(),
              phoneNo: auth2.firebaseAuth.currentUser!.phoneNumber.toString(),
              groupID: [],
            ),
            messageEnum: MessageEnum.audio,
            isGroupChat: widget.isGroupChat,
          );
        } else {
          await _soundRecorder!.startRecorder(toFile: path);
          showSnackBar(context, 'Start recording');
        }

        setState(() {
          isRecording = !isRecording;
        });
      }
    }
    //
    // file provider use
    // final File = Provider.of<Chat>(context, listen: false);

    void sendFile(
      File file,
      MessageEnum messageEnum,
    ) {
      chats.sendFileMessage(
        context: context,
        file: file,
        reciverUserId: widget.uid,
        senderUserData: UserModel(
          name: auth2.firebaseAuth.currentUser!.displayName.toString(),
          email: auth2.firebaseAuth.currentUser!.email.toString(),
          profilePic: '',
          isOnline: true,
          uid: auth2.firebaseAuth.currentUser!.uid.toString(),
          phoneNo: auth2.firebaseAuth.currentUser!.phoneNumber.toString(),
          groupID: [],
        ),
        messageEnum: messageEnum,
        isGroupChat: widget.isGroupChat,
      );
    }

    // image
    void selectImage() async {
      File? image = await pickImage(context);

      if (image != null) {
        sendFile(image, MessageEnum.image);
      }
    }

    // video
    void selectVideo() async {
      File? video = await pickVideo(context);

      if (video != null) {
        sendFile(video, MessageEnum.video);
      }
    }

    void selectFile() async {
      File? files = await pickFiles(context);
      if (files != null) {
        sendFile(files, MessageEnum.document);
      }
      print(files!.path.toString());
    }

//

//
    //
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Column(
        children: [
          Row(
            //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      // border: ,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white),
                  // color: Colors.white,
                  child: TextFormField(
                    focusNode: focusNode,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          isShowButton = true;
                        });
                      } else {
                        setState(() {
                          isShowButton = false;
                        });
                      }
                    },
                    controller: messageController,
                    decoration: InputDecoration(
                      // fillColor: Colors.white,
                      // focusColor: Colors.white,
                      // //   hoverColor: Theme.of(context).primaryColor,
                      iconColor: Colors.amberAccent,
                      // filled: true,
                      prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 0, right: 0),
                          child: SizedBox(
                            width: 10,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: toggleEmojiKeyboardContainer,
                                    icon: const Icon(
                                      Icons.emoji_emotions,
                                      color: Color.fromARGB(255, 143, 188, 143),
                                    ))
                              ],
                            ),
                          )),
                      suffixIcon: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // IconButton(
                            //   icon: const Icon(Icons.camera_alt),
                            //   color: Color.fromARGB(255, 143, 188, 143),
                            //   onPressed: selectImage,
                            // ),
                            IconButton(
                              icon: const Icon(Icons.attach_file),
                              color: Color.fromARGB(255, 143, 188, 143),
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    )),
                                    builder: (context) {
                                      return Menu2(
                                        file: selectFile,
                                        image: selectImage,
                                        video: selectVideo,
                                      );
                                    });
                              },
                            ),
                          ],
                        ),
                      ),
                      hintText: 'Type a message',

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Color(0xFF000000),
                          width: 5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 2,
                  right: 2,
                  bottom: 8,
                ),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).backgroundColor,
                  child: GestureDetector(
                    child: Icon(
                      isShowButton
                          ? Icons.send
                          : isRecording
                              ? Icons.close
                              : Icons.mic,
                      color: Colors.white,
                    ),
                    onTap: () {
                      _sendTextMessage();
                    },
                  ),
                  radius: 25,
                ),
              )
            ],
          ),
          isShowEmojiContainer
              ? SizedBox(
                  height: 300,
                  child: EmojiPicker(
                    onEmojiSelected: ((category, emoji) {
                      setState(() {
                        messageController.text =
                            messageController.text + emoji.emoji;
                      });

                      if (!isShowButton) {
                        setState(() {
                          isShowButton = true;
                        });
                      }
                    }),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
