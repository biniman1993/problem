import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  double _fontSize = 18.0;
  double _lineHeight = 1.5;
  bool _isDarkMode = false;
  String _fontFamily = 'GeezMahtem';

  final List<String> _fontOptions = [
    'GeezMahtem',
    'Roboto',
    'Arial',
    'Times New Roman',
    'Helvetica',
  ];

  // Getters
  double get fontSize => _fontSize;
  double get lineHeight => _lineHeight;
  bool get isDarkMode => _isDarkMode;
  String get fontFamily => _fontFamily;
  List<String> get fontOptions => _fontOptions;

  // Background colors based on theme
  Color get backgroundColor => _isDarkMode ? Colors.black : Colors.white;
  Color get textColor => _isDarkMode ? Colors.white : Colors.black87;
  Color get headingColor => _isDarkMode 
      ? const Color.fromARGB(255, 120, 140, 255) 
      : const Color.fromARGB(255, 55, 67, 138);

  // Setters with notification
  void setFontSize(double value) {
    _fontSize = value;
    notifyListeners();
  }

  void setLineHeight(double value) {
    _lineHeight = value;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void setFontFamily(String value) {
    _fontFamily = value;
    notifyListeners();
  }

  // Reset to defaults
  void resetToDefaults() {
    _fontSize = 18.0;
    _lineHeight = 1.5;
    _isDarkMode = false;
    _fontFamily = 'GeezMahtem';
    notifyListeners();
  }
}