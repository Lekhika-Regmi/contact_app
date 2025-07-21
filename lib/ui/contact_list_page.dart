import 'package:flutter/material.dart';

import '../../data/contact_model.dart';
import '../../data/database_helper.dart';
import 'add_contact_page.dart';
import 'calling_page.dart';
import 'contact_detail_page.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({super.key});

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final contacts = await DatabaseHelper.instance.getContacts();
    setState(() {
      _contacts = contacts;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _contacts.isEmpty
          ? const Center(child: Text('No contacts yet'))
          : ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                final contact = _contacts[index];
                return ListTile(
                  title: Text(contact.name),
                  subtitle: Text(contact.phone),
                  trailing: IconButton(
                    icon: const Icon(Icons.call),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CallingPage(name: contact.name),
                        ),
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ContactDetailPage(contact: contact),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newContact = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddContactPage()),
          );
          if (newContact != null) {
            _loadContacts(); // reload contacts
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
