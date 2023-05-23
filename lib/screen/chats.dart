import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ph_login/common/encryptAES.dart';
import 'package:ph_login/model/chat_contact.dart';
import 'package:ph_login/model/group.dart';

import 'package:provider/provider.dart';

import '../providers/chat.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final conChats = Provider.of<Chat>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'ChatMate',
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          //  IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Create Group'),
                onTap: () {
                  Future(
                    () => Navigator.pushNamed(context, '/createGroup'),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.pushNamed(context, '/contacts');
      //   },
      //   child: Icon(Icons.contact_phone),
      // ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2));
          //  return true;
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder<List<Group>>(
                  stream: conChats.getChatGroups(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.hasError) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    //  else if (snapshot.data!.isEmpty) {
                    //   return buildText('No chat ..');
                    // }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/chatsScreen', // MChatScrren()
                                  arguments: {
                                    'name': snapshot.data![index].name,
                                    'uid': snapshot.data![index].groupId,
                                    'isGroup': true,
                                    'profilePic':
                                        snapshot.data![index].groupPic,
                                  },
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 7.0),
                                child: ListTile(
                                  title: Text(
                                    snapshot.data![index].name.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text(
                                      snapshot.data![index].lastMessage
                                                  .length >=
                                              8
                                          ? MyEncryptDecrypt().decryptAES(
                                              snapshot.data![index].lastMessage
                                                  .toString(),
                                            )
                                          : snapshot.data![index].lastMessage
                                              .toString(),
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  leading: Container(
                                    //color: Colors.grey,
                                    width: 50,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey),
                                    //borderRadius: BorderRadius.circular(10),
                                    // backgroundImage: NetworkImage(
                                    //   snapshot.data![index].profilePic.toString(),
                                    // ),
                                    // backgroundColor: Colors.blueGrey,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(100)),
                                      child: CachedNetworkImage(
                                        // height: 100,
                                        // width: 100,
                                        imageUrl: snapshot.data![index].groupPic
                                            .toString(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.error,
                                          color: Colors.white,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // radius: 25,
                                  ),
                                  trailing: Text(
                                    DateFormat().add_jm().format(
                                          snapshot.data![index].timeSent,
                                        ),
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 34, 33, 33),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(
                              color: Colors.black,
                              indent: 70,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                StreamBuilder<List<ChatContact>>(
                  stream: conChats.getChatContact(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.hasError) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.data!.isEmpty) {
                      return buildText('No chat ..');
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        // bool ccc = conChats
                        //     .view(context, snapshot.data![index].contactId)
                        //     .asStream()
                        //     .isBroadcast;

                        // print(conChats
                        //     .view(context, snapshot.data![index].contactId)
                        //     .asStream()
                        //     .isBroadcast);
                        // .then((value) => ccc = value!));
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/chatsScreen', // MChatScrren()
                                  arguments: {
                                    'name': snapshot.data![index].name,
                                    'uid': snapshot.data![index].contactId,
                                    'isGroup': false,
                                    'profilePic':
                                        snapshot.data![index].profilePic,
                                  },
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 7.0),
                                child: ListTile(
                                  title: Text(
                                    snapshot.data![index].name.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text(
                                      snapshot.data![index].lastMessage
                                                  .length >=
                                              8
                                          ? MyEncryptDecrypt().decryptAES(
                                              snapshot.data![index].lastMessage
                                                  .toString(),
                                            )
                                          : snapshot.data![index].lastMessage
                                              .toString(),
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  leading: Container(
                                    //color: Colors.grey,
                                    width: 50,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey),
                                    //borderRadius: BorderRadius.circular(10),
                                    // backgroundImage: NetworkImage(
                                    //   snapshot.data![index].profilePic.toString(),
                                    // ),
                                    // backgroundColor: Colors.blueGrey,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(100)),
                                      child: CachedNetworkImage(
                                        // height: 100,
                                        // width: 100,
                                        imageUrl: snapshot
                                            .data![index].profilePic
                                            .toString(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.error,
                                          color: Colors.white,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // radius: 25,
                                  ),
                                  trailing: Text(
                                    DateFormat().add_jm().format(
                                          snapshot.data![index].timeSent,
                                        ),
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 34, 33, 33),
                                      fontSize: 12,
                                    ),
                                  ),

                                  // Icon(conChats
                                  //         .view(
                                  //             context,
                                  //             snapshot
                                  //                 .data![index].contactId)
                                  //         .asStream()
                                  //         .isBroadcast
                                  //     ? null
                                  //     : Icons.add),

                                  // if(conChats.view(context,snapshot.data![index].contactId) == true){

                                  // },
                                ),
                              ),
                            ),
                            //),
                            const Divider(
                              color: Colors.black,
                              indent: 70,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
        ),
      );
}
