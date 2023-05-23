import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:ph_login/model/chat_contact.dart';
import 'package:ph_login/model/message.dart';
import 'package:ph_login/model/user_model.dart';

import 'package:ph_login/widget/snackbar.dart';
import 'package:uuid/uuid.dart';

import '../common/enums/message_enum.dart';
import '../model/group.dart';

class Chat with ChangeNotifier {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

// list of chats ...
  Stream<List<ChatContact>> getChatContact() {
    return firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> ChatCon = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);

        ChatCon.add(
          ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
          ),
        );
      }
      return ChatCon;
    });
  }
//

  Stream<List<Group>> getChatGroups() {
    return firestore.collection('groups').snapshots().map((event) {
      List<Group> groups = [];
      for (var document in event.docs) {
        var group = Group.fromMap(document.data());
        if (group.membersUid.contains(firebaseAuth.currentUser!.uid)) {
          groups.add(group);
        }
      }
      return groups;
    });
  }

//
//       get all message
  Stream<List<dynamic>> getchatMessage(String recieverUserId) {
    return firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('message')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<dynamic> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }
//

  Stream<List<Message>> getGroupChat(String groudId) {
    return firestore
        .collection('groups')
        .doc(groudId)
        .collection('chats')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

//
//
  void _sendDataToContactsSubcollection(
    UserModel senderUserData,
    UserModel? reciverUserData,
    String text,
    DateTime timesent,
    String reciverUserId,
    bool isGroupChat,
  ) async {
    if (isGroupChat) {
      await firestore.collection('groups').doc(reciverUserId).update({
        'lastMessage': text,
        'timeSent': DateTime.now().millisecondsSinceEpoch,
      });
    }
// users -> reciever user id => chats -> current user id -> set data
    var reciverChatContact = ChatContact(
        name: senderUserData.name,
        profilePic: senderUserData.profilePic,
        contactId: senderUserData.uid,
        timeSent: timesent,
        lastMessage: text);
    await firestore
        .collection('users')
        .doc(reciverUserId)
        .collection('chats')
        .doc(firebaseAuth.currentUser!.uid)
        .set(reciverChatContact.toMap());

// users -> current user id  => chats -> reciever user id -> set data
    var senderChatContact = ChatContact(
        name: reciverUserData!.name,
        profilePic: reciverUserData.profilePic,
        contactId: reciverUserData.uid,
        timeSent: timesent,
        lastMessage: text);
    await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .doc(reciverUserId)
        .set(senderChatContact.toMap());
  }

  void _saveMessageToMessageSubcollection({
    required String recieverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required MessageEnum messageType,
    // required String reciverUsername,
    // required MessageReplyPro? messageReply,
    // required String senderUsername,
    // required String? recieverUserName,
    required bool isGroupChat,
  }) async {
    final message = Message(
      senderId: firebaseAuth.currentUser!.uid,
      recieverid: recieverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
    );

    if (isGroupChat) {
      await firestore
          .collection('groups')
          .doc(recieverUserId)
          .collection('chats')
          .doc(messageId)
          .set(message.toMap());
    } else {
      // users -> sender id -> reciever id -> messages -> message id -> store message
      await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('message')
          .doc(messageId)
          .set(message.toMap());

      //  // users -> reciever id  -> sender id -> messages -> message id -> store message
      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('message')
          .doc(messageId)
          .set(message.toMap());
    }
  }

  //

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String reciverUserId,
    required UserModel sendUser,
    required bool isGroupChat, //   UserModel? sendUser,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel? reciverUserData;
      if (!isGroupChat) {
        var userdataMap =
            await firestore.collection('users').doc(reciverUserId).get();

        reciverUserData = UserModel.fromMap(userdataMap.data()!);
      }

      _sendDataToContactsSubcollection(
        sendUser,
        reciverUserData,
        text,
        timeSent,
        reciverUserId,
        isGroupChat,
      );

      var messageId = const Uuid().v1();

      _saveMessageToMessageSubcollection(
        recieverUserId: reciverUserId,
        text: text,
        timeSent: timeSent,
        messageId: messageId,
        messageType: MessageEnum.text,
        //  reciverUsername: reciverUserData.name,
        username: sendUser.name,
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

//

// send file message
  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String reciverUserId,
    required UserModel senderUserData,
    required MessageEnum messageEnum,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      //await firebaseStorage;
      final ext = file.path.split('.').last;
      UploadTask uploadTask = firebaseStorage
          .ref()
          .child(
            'chat/${messageEnum.type}/${senderUserData.uid}/$reciverUserId/$messageId.$ext',
          )
          .putFile(file);
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
//
      UserModel? reciverUserData;
      var userdataMap =
          await firestore.collection('users').doc(reciverUserId).get();

      reciverUserData = UserModel.fromMap(userdataMap.data()!);
//
      String contMsg;

      switch (messageEnum) {
        case MessageEnum.image:
          contMsg = '📷Photo';

          break;
        case MessageEnum.video:
          contMsg = '🎥Video';

          break;
        case MessageEnum.audio:
          contMsg = '🎵Audio';

          break;
        case MessageEnum.gif:
          contMsg = ' GIF';

          break;
        case MessageEnum.document:
          contMsg = '📄Document';

          break;
        default:
          contMsg = ' GIF';
      }
      //

      _sendDataToContactsSubcollection(
        senderUserData,
        reciverUserData,
        contMsg, // downloadUrl,
        timeSent,
        reciverUserId,
        isGroupChat,
      );

      _saveMessageToMessageSubcollection(
        recieverUserId: reciverUserId,
        text: downloadUrl,
        timeSent: timeSent,
        messageId: messageId,
        username: senderUserData.name,
        messageType: messageEnum,
        isGroupChat: isGroupChat,
      );

      //
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

//delete message  text/image
  Future deleteMessage(
      String messageId, String reciverId, MessageEnum type) async {
    await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .doc(reciverId)
        .collection('message')
        .doc(messageId)
        .delete();

    if (type == MessageEnum.image || type == MessageEnum.video) {
      await firebaseStorage.refFromURL(messageId).delete();
    }
  }
//

  void setChatMessageSeen(
    BuildContext context,
    String recieverUserId,
    String messageId,
  ) async {
    try {
      await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('message')
          .doc(messageId)
          .update({'isSeen': true});

      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('message')
          .doc(messageId)
          .update({'isSeen': true});

      //  notifyListeners();
    } catch (e) {
      print(e);
      // showSnackBar(context, e.toString());
    }
  }
//

  Future<bool?> view(
    BuildContext context,
    String recieverUserId,
  ) async {
    bool values = false;
    try {
      await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('message')
          .orderBy('timeSent')
          .snapshots()
          .last
          .asStream()
          .contains('isSeen')
          .then((value) {
        values = value;
      });
      return values;
    } catch (e) {
      print(e);
    }
  }

  //
}
