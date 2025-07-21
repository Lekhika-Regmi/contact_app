import 'package:contact_app/ui/home_page.dart';
import 'package:contact_app/ui/username_prompt_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    final savedName = prefs.getString('username');

    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      _username = savedName;
    });
  }

  void _updateTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _saveUsername(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', name);
    setState(() {
      _username = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(primary: Colors.lightGreen),
      ),
      themeMode: _themeMode,
      home: _username == null
          ? UsernamePromptPage(onSubmit: _saveUsername)
          : HomePage(
              username: _username!,
              onThemeToggle: _updateTheme,
              isDarkMode: _themeMode == ThemeMode.dark,
            ),
    );
  }
}
