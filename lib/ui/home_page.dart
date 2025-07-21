import 'package:flutter/material.dart';

import 'contact_list_page.dart';
import 'dial_page.dart';
import 'favorites_page.dart';

class HomePage extends StatefulWidget {
  final String username;
  final Function(bool) onThemeToggle;
  final bool isDarkMode;

  const HomePage({
    required this.username,
    required this.onThemeToggle,
    required this.isDarkMode,
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ContactListPage(),
    const DialPage(),
    const FavoritesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.username}!'),
        actions: [
          Switch(value: widget.isDarkMode, onChanged: widget.onThemeToggle),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.contacts), label: 'Contact'),
          BottomNavigationBarItem(icon: Icon(Icons.dialpad), label: 'Dial'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
      ),
    );
  }
}
