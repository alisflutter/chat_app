import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:ph_login/screen/status_screen.dart';
import 'package:ph_login/widget/pick_file.dart';

import 'package:provider/provider.dart';

import '../model/status.dart';
import '../providers/status_provider.dart';

class StatusContact extends StatefulWidget {
  const StatusContact({super.key});

  @override
  State<StatusContact> createState() => _StatusContactState();
}

class _StatusContactState extends State<StatusContact> {
  // var status;
  // @override
  // void initState() {
  //   // Future.delayed(Duration.zero).then((value) {
  //   status = Provider.of<StatusProvider>(context, listen: false);
  //   // });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final status = Provider.of<StatusProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        margin: const EdgeInsets.all(12),
        child: FutureBuilder<List<Status>>(
          future: status.getStatus(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.data!.isEmpty) {
              return buildText('Say Hi..');
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var statusData = snapshot.data![index];
                print(statusData.username);
                // print();
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    StatusScreen(status: statusData))));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: ListTile(
                          title: Text(
                            statusData.username,
                          ),
                          leading: Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.grey),
                            width: 50,
                            height: 50,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                              child: CachedNetworkImage(
                                imageUrl: statusData.profilePic,
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.error,
                                  color: Colors.white,
                                ),
                                //  fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(color: Colors.black, indent: 85),
                  ],
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_a_photo),
        onPressed: () async {
          File? pickImages = await pickImage(context);
          if (pickImages != null) {
            Navigator.pushNamed(
              context,
              '/confirmStatus',
              arguments: pickImages,
            );
          }
        },
      ),
    );
  }

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 24),
        ),
      );
}
