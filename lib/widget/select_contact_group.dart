import 'package:flutter/material.dart';

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:provider/provider.dart';

import '../providers/select_contact.dart';

class SelectContactsGroup extends StatefulWidget {
  const SelectContactsGroup({super.key});

  @override
  State<SelectContactsGroup> createState() => _SelectContactsGroupState();
}

class _SelectContactsGroupState extends State<SelectContactsGroup> {
  List<int> selectedContactsIndex = [];
  List<Contact> selectContacts = [];

  // void selectContact(int index, Contact contact) {
  //   if (selectedContactsIndex.contains(index)) {
  //     selectedContactsIndex.removeAt(index);
  //     selectContacts.removeAt(index);
  //   } else {
  //     selectedContactsIndex.add(index);
  //     selectContacts.add(contact);
  //   }
  //   setState(() {});
  //   print(selectContacts);
  // }

  @override
  Widget build(BuildContext context) {
    final contactList = Provider.of<SelectContact>(context);

    void selectContact(int index, Contact contact) {
      if (selectedContactsIndex.contains(index)) {
        selectedContactsIndex.removeAt(index);
        selectContacts.removeAt(index);
        contactList.selectContacts.removeAt(index);
      } else {
        selectedContactsIndex.add(index);
        selectContacts.add(contact);
        contactList.selectContacts.add(contact);
      }
      setState(() {});
      print(selectContacts);
    }

    return FutureBuilder(
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
              itemBuilder: (context, index) => InkWell(
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
                  ),
              itemCount: contacts.length);
        }
      },
    );
  }

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
        ),
      );
}
