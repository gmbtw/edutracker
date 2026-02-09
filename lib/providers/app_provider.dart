import git push -f origin maingit push -f origin main'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AppProvider extends ChangeNotifier {
  String? _userEmail;
  String? _passwordHash;
  ThemeMode _themeMode = ThemeMode.light;

  String? get userEmail => _userEmail;
  String? get passwordHash => _passwordHash;
  ThemeMode get themeMode => _themeMode;

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  void loginUser(String email, String password) {
    _userEmail = email;
    _passwordHash = _hashPassword(password);
    notifyListeners();
  }

  void setUserEmail(String email) {
    _userEmail = email;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void logout() {
    _userEmail = null;
    _passwordHash = null;
    notifyListeners();
  }
}
