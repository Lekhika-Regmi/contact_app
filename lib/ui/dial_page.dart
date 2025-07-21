import 'package:flutter/material.dart';

import '../../data/contact_model.dart';
import '../../data/database_helper.dart';
import 'calling_page.dart';
import 'contact_detail_page.dart';

class DialPage extends StatefulWidget {
  const DialPage({super.key});

  @override
  State<DialPage> createState() => _DialPageState();
}

class _DialPageState extends State<DialPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
    _searchController.addListener(_filterContacts);
  }

  Future<void> _loadContacts() async {
    final allContacts = await DatabaseHelper.instance.getContacts();
    setState(() {
      _contacts = allContacts;
      _filteredContacts = [];
    });
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() {
        _filteredContacts = [];
      });
    } else {
      setState(() {
        _filteredContacts = _contacts.where((contact) {
          return contact.phone.contains(query) ||
              contact.name.toLowerCase().contains(query);
        }).toList();
      });
    }
  }

  void _onDialPressed() {
    final number = _searchController.text.trim();
    if (number.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CallingPage(name: number)),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 🔍 Search Field
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Search by name or number',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterContacts();
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
            ),
          ),

          // 📋 Contact List
          Expanded(
            child: _filteredContacts.isEmpty
                ? const Center(child: Text('No matches found'))
                : ListView.builder(
                    itemCount: _filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = _filteredContacts[index];
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
                              builder: (_) =>
                                  ContactDetailPage(contact: contact),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),

          // Dial Pad with Call Button
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: 'Enter number to dial',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                FloatingActionButton(
                  onPressed: _onDialPressed,
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.call),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
