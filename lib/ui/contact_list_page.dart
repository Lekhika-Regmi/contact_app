import 'package:flutter/material.dart';

import '../data/contact_model.dart';
import '../data/database_helper.dart';
import '../services/preferences_services.dart';
import 'add_edit_contact_page.dart';

class ContactListPage extends StatefulWidget {
  final bool isDarkMode;
  final void Function(bool) onThemeToggle;

  const ContactListPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });
  @override
  State<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  late Future<List<Contact>> _contactsFuture;

  final _prefs = PreferencesService();
  String _username = '';

  @override
  void initState() {
    super.initState();
    _refreshContactList();
    _loadUsername();
    _checkAndAskName();
  }

  void _loadUsername() async {
    final name = await _prefs.getUsername();
    if (name != null && mounted) {
      setState(() {
        _username = name;
      });
    }
  }

  void _refreshContactList() {
    setState(() {
      _contactsFuture = DatabaseHelper.instance.getAllContacts();
    });
  }

  void _navigateAndRefresh(BuildContext context, {Contact? contact}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditContactPage(contact: contact),
      ),
    );
    if (result == true) {
      _refreshContactList();
    }
  }

  void _deleteContact(int id) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: const Text('Are you sure you want to delete this contact?'),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(false), // User selects No
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(true), // User selects Yes
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await DatabaseHelper.instance.delete(id);
      _refreshContactList();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Contact deleted')));
      }
    }
  }

  void _checkAndAskName() async {
    final name = await _prefs.getUsername();
    if (name == null && mounted) {
      final enteredName = await showDialog<String>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Enter your name'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Your name'),
            onSubmitted: Navigator.of(context).pop,
          ),
        ),
      );
      if (enteredName != null && enteredName.isNotEmpty) {
        await _prefs.setUsername(enteredName);
        setState(() {
          _username = enteredName;
        });
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _username.isNotEmpty ? 'Welcome, $_username' : 'Sqflite Contact App',
        ),
        actions: [
          Switch(value: widget.isDarkMode, onChanged: widget.onThemeToggle),
        ],
      ),
      body: FutureBuilder<List<Contact>>(
        future: _contactsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'No contacts yet.\nTap the ➕ button below to add one!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          } else {
            final contacts = snapshot.data!;
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(contact.name[0])),
                  title: Text(contact.name),
                  subtitle: Text(contact.phone),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteContact(contact.id!),
                  ),
                  onTap: () => _navigateAndRefresh(context, contact: contact),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateAndRefresh(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
