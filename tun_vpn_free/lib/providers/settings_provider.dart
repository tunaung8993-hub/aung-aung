import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyAutoConnect = 'auto_connect';
  static const String _keyKillSwitch = 'kill_switch';
  static const String _keyLanguage = 'language';
  static const String _keyPrivacyAccepted = 'privacy_accepted';
  static const String _keyFirstLaunch = 'first_launch';

  ThemeMode _themeMode = ThemeMode.dark;
  bool _autoConnect = false;
  bool _killSwitch = false;
  String _language = 'en';
  bool _privacyAccepted = false;
  bool _firstLaunch = true;

  ThemeMode get themeMode => _themeMode;
  bool get autoConnect => _autoConnect;
  bool get killSwitch => _killSwitch;
  String get language => _language;
  bool get privacyAccepted => _privacyAccepted;
  bool get firstLaunch => _firstLaunch;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_keyThemeMode) ?? 2; // dark by default
    _themeMode = ThemeMode.values[themeIndex];
    _autoConnect = prefs.getBool(_keyAutoConnect) ?? false;
    _killSwitch = prefs.getBool(_keyKillSwitch) ?? false;
    _language = prefs.getString(_keyLanguage) ?? 'en';
    _privacyAccepted = prefs.getBool(_keyPrivacyAccepted) ?? false;
    _firstLaunch = prefs.getBool(_keyFirstLaunch) ?? true;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyThemeMode, mode.index);
    notifyListeners();
  }

  Future<void> setAutoConnect(bool value) async {
    _autoConnect = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAutoConnect, value);
    notifyListeners();
  }

  Future<void> setKillSwitch(bool value) async {
    _killSwitch = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyKillSwitch, value);
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, lang);
    notifyListeners();
  }

  Future<void> acceptPrivacy() async {
    _privacyAccepted = true;
    _firstLaunch = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyPrivacyAccepted, true);
    await prefs.setBool(_keyFirstLaunch, false);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }
}
