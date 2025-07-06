import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String keyTheme = 'isDarkMode';
  static const String keyUsername = 'username';

  // Save theme preferences

  Future<void> setDarkMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyTheme, isDarkMode);
  }

  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyTheme) ?? false;
  }

  Future<void> setUsername(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUsername, name);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUsername);
  }
}
