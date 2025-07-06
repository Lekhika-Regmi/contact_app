import 'package:flutter/material.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({super.key});

  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  late Future<List<Contact>> _contactsFuture;

  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshContactList();
  }

  void _refreshContactList() {
    setState(() {
      //_contactsFuture = DatabaseHelper.instance.getAllContacts();
    });
  }

  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Contact {}
