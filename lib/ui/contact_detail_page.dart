import 'package:flutter/material.dart';

import '../../data/contact_model.dart';
import '../../data/database_helper.dart';
import 'add_contact_page.dart';

class ContactDetailPage extends StatefulWidget {
  final Contact contact;

  const ContactDetailPage({required this.contact, super.key});

  @override
  State<ContactDetailPage> createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  late Contact _contact;

  @override
  void initState() {
    super.initState();
    _contact = widget.contact;
  }

  Future<void> _toggleFavorite() async {
    final updated = _contact.copyWith(isFavorite: !_contact.isFavorite);
    await DatabaseHelper.instance.updateContact(updated);
    setState(() {
      _contact = updated;
    });
  }

  void _navigateToEdit() async {
    final updatedContact = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddContactPage(contact: _contact)),
    );

    if (updatedContact != null) {
      setState(() {
        _contact = updatedContact;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_contact.name),
        actions: [
          IconButton(
            icon: Icon(_contact.isFavorite ? Icons.star : Icons.star_border),
            onPressed: _toggleFavorite,
          ),
          IconButton(icon: const Icon(Icons.edit), onPressed: _navigateToEdit),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Name:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_contact.name, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const Text('Phone:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_contact.phone, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
