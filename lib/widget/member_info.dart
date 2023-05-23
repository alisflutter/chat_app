import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';
import '../providers/auth.dart';

class MemberInfo extends StatelessWidget {
  final String Muid;
  const MemberInfo({super.key, required this.Muid});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context);
    var data = user.getReciverUser(Muid);

    return StreamBuilder(
        stream: data,
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          UserModel userModel = snapshot.data as UserModel;
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              // child: Image.network(
              //   'https://3.bp.blogspot.com/-h8xPYD07uh0/Wr835tAa5EI/AAAAAAAABFk/RhF22VQEfqoflTJedHKJOO3T5OTMnsUawCLcBGAs/s1600/Arijit%2BSingh.jpg',
              //   height: 100,
              //   width: 100,
              //   fit: BoxFit.fill,
              // )
              child: CachedNetworkImage(
                imageUrl: userModel.profilePic,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => const Icon(Icons.person),
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
              ),
            ),
            title: Text(
              userModel.name,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            subtitle: Text(
              userModel.phoneNo,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          );
        }));
  }
}
