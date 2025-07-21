import 'package:flutter/material.dart';

import '../../data/contact_model.dart';
import '../../data/database_helper.dart';
import 'calling_page.dart';
import 'contact_detail_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Contact> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final contacts = await DatabaseHelper.instance.getContacts();
    setState(() {
      _favorites = contacts.where((c) => c.isFavorite).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _favorites.isEmpty
        ? const Center(child: Text('No favorites yet'))
        : ListView.builder(
            itemCount: _favorites.length,
            itemBuilder: (context, index) {
              final contact = _favorites[index];
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
          );
  }
}
