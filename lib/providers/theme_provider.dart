import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- PROVIDER MEJORADO PARA MANEJAR TODOS LOS AJUSTES ---
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _notificationsEnabled = true;
  String _language = 'Español';

  static const String _themeModeKey = 'themeMode';
  static const String _notificationsKey = 'notificationsEnabled';
  static const String _languageKey = 'language';

  ThemeProvider() {
    _loadSettings(); // Carga todos los ajustes guardados al iniciar
  }

  ThemeMode get themeMode => _themeMode;
  bool get notificationsEnabled => _notificationsEnabled;
  String get language => _language;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _saveThemeMode();
    notifyListeners();
  }

  void setNotifications(bool enabled) {
    _notificationsEnabled = enabled;
    _saveNotifications();
    notifyListeners();
  }

  void setLanguage(String lang) {
    _language = lang;
    _saveLanguage();
    notifyListeners();
  }

  // --- LÓGICA DE GUARDADO Y CARGA ---

  Future<void> _saveThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, _themeMode.toString());
  }

  Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, _notificationsEnabled);
  }

  Future<void> _saveLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, _language);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Cargar Tema
    final savedTheme = prefs.getString(_themeModeKey);
    if (savedTheme != null) {
      _themeMode = ThemeMode.values.firstWhere((e) => e.toString() == savedTheme, orElse: () => ThemeMode.system);
    }

    // Cargar Notificaciones
    _notificationsEnabled = prefs.getBool(_notificationsKey) ?? true; // Por defecto, activadas

    // Cargar Idioma
    _language = prefs.getString(_languageKey) ?? 'Español'; // Por defecto, Español

    notifyListeners();
  }
}
