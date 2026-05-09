import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadingStateService {
  static const String _prefix = 'page_';

  String _generateKey(String path) {
    final bytes = utf8.encode(path);
    final digest = sha256.convert(bytes);
    return '$_prefix$digest';
  }

  Future<int?> getLastPage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _generateKey(path);
    return prefs.getInt(key);
  }

  Future<void> saveLastPage(String path, int page) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _generateKey(path);
    await prefs.setInt(key, page);
  }

  Future<void> clearProgress(String path) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _generateKey(path);
    await prefs.remove(key);
  }
}
