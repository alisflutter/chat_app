import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'package:provider/provider.dart';

import '../providers/select_contact.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactState();
}

class _ContactState extends State<ContactScreen> {
  // List<Contact> contactList = [];
  bool isLoading = true;
  List<Contact> _filteredItems = [];
  String name = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final contactList = Provider.of<SelectContact>(context).getContacts();
    final selectcon = Provider.of<SelectContact>(context);

    //  print(contactList);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
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
          FutureBuilder(
            future: contactList,
            builder: (context, future) {
              if (future.connectionState == ConnectionState.waiting ||
                  future.hasError) {
                return const Center(child: CircularProgressIndicator());
              } else if (future.data == null) {
                return buildText('No contact please allow permission');
              } else {
                List<Contact> contacts = future.data!;
                print(contacts.length);
                return Expanded(
                  child: ListView.builder(
                      itemBuilder: (context, index) {
                        if (name.isEmpty) {
                          return InkWell(
                            onTap: (() => selectcon.selectContact(
                                contacts[index], context)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 8),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                tileColor:
                                    const Color.fromARGB(115, 225, 220, 220),
                                // title: Text('${snapshot.data}'),
                                title: Text(contacts[index].displayName),
                                leading: contacts[index].photo == null
                                    ? null
                                    : CircleAvatar(
                                        backgroundImage:
                                            MemoryImage(contacts[index].photo!),
                                        radius: 30,
                                      ),
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
                            onTap: (() => selectcon.selectContact(
                                contacts[index], context)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 8),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                tileColor:
                                    const Color.fromARGB(115, 225, 220, 220),
                                // title: Text('${snapshot.data}'),
                                title: Text(contacts[index].displayName),
                                leading: contacts[index].photo == null
                                    ? null
                                    : CircleAvatar(
                                        backgroundImage:
                                            MemoryImage(contacts[index].photo!),
                                        radius: 30,
                                      ),
                              ),
                            ),
                          );
                        }
                        return Container();
                      },
                      itemCount: contacts.length),
                );
              }
            },
          ),
        ],
      ),
    );
  }

//
  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
        ),
      );

  //
}
