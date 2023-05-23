import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:ph_login/model/group.dart';
import 'package:ph_login/providers/group_provider.dart';
import 'package:provider/provider.dart';

import '../providers/select_contact.dart';
import '../widget/pick_file.dart';
import '../widget/select_contact_group.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final TextEditingController groupNameController = TextEditingController();
  File? image;
  List<int> selectedContactsIndex = [];
  List<Contact> selectContacts = [];
  String name = '';

  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    groupNameController.dispose();
  }

  //
  void selectContact(int index, Contact contact) {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.removeAt(index);
      selectContacts.removeAt(index);
      //  contactList.selectContacts.removeAt(index);
    } else {
      selectedContactsIndex.add(index);
      selectContacts.add(contact);
      //  contactList.selectContacts.add(contact);
    }
    setState(() {});
    print(selectContacts);
  }

  //

  @override
  Widget build(BuildContext context) {
    final contactList = Provider.of<SelectContact>(context);
    final groups = Provider.of<GroupProvider>(context);

    void createGroup() {
      if (groupNameController.text.trim().isNotEmpty && image != null) {
        groups.createGroup(
          context,
          groupNameController.text.trim(),
          image!,
          // contactList.selectContacts,
          selectContacts,
        );
        Navigator.pop(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    image == null
                        ? const CircleAvatar(
                            backgroundImage: NetworkImage(
                              'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
                            ),
                            radius: 64,
                          )
                        : CircleAvatar(
                            backgroundImage: FileImage(
                              image!,
                            ),
                            radius: 64,
                          ),
                    Positioned(
                      bottom: -1,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(
                          Icons.add_a_photo,
                        ),
                      ),
                    ),
                  ],
                ),
                //   ],
                // ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: groupNameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Group Name',
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(8),
                  child: const Text(
                    'Select Contacts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextField(
                  style: const TextStyle(color: Colors.black),
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),

          //  SelectContactsGroup(),
          Expanded(
            child: FutureBuilder(
              future: contactList.getContacts(),
              builder: (context, future) {
                if (future.connectionState == ConnectionState.waiting ||
                    future.hasError) {
                  return const Center(child: CircularProgressIndicator());
                } else if (future.data == null) {
                  return buildText('No contact please allow permission');
                } else {
                  List<Contact> contacts = future.data!;
                  print(contacts.length);
                  return ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (name.isEmpty) {
                          return InkWell(
                            onTap: () => selectContact(index, contacts[index]),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                // shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(15)),
                                // tileColor: Color.fromARGB(255, 160, 184, 196),
                                // title: Text('${snapshot.data}'),
                                title: Text(contacts[index].displayName),
                                leading: selectedContactsIndex.contains(index)
                                    ? IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.done),
                                      )
                                    : null,
                              ),
                            ),
                          );
                        }
                        if (contacts[index]
                            .displayName
                            .toString()
                            .toLowerCase()
                            .startsWith(name.toLowerCase())) {
                          return InkWell(
                            onTap: () => selectContact(index, contacts[index]),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                // shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(15)),
                                // tileColor: Color.fromARGB(255, 160, 184, 196),
                                // title: Text('${snapshot.data}'),
                                title: Text(contacts[index].displayName),
                                leading: selectedContactsIndex.contains(index)
                                    ? IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.done),
                                      )
                                    : null,
                              ),
                            ),
                          );
                        }
                        return Container();
                      },
                      itemCount: contacts.length);
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createGroup,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.done,
          color: Colors.white,
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
