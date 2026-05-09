import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recent_file.dart';

class RecentFilesService {
  static const String _key = 'recent_files';
  static const int _maxFiles = 30;

  Future<List<RecentFile>> getRecentFiles() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => RecentFile.fromJson(e)).toList();
  }

  Future<void> addFile(RecentFile file) async {
    final prefs = await SharedPreferences.getInstance();
    List<RecentFile> files = await getRecentFiles();

    // Remove if already exists to move to top
    files.removeWhere((e) => e.path == file.path);
    
    // Add to top
    files.insert(0, file);

    // Trim list
    if (files.length > _maxFiles) {
      files = files.sublist(0, _maxFiles);
    }

    await prefs.setString(_key, jsonEncode(files.map((e) => e.toJson()).toList()));
  }

  Future<void> removeFile(String path) async {
    final prefs = await SharedPreferences.getInstance();
    List<RecentFile> files = await getRecentFiles();
    files.removeWhere((e) => e.path == path);
    await prefs.setString(_key, jsonEncode(files.map((e) => e.toJson()).toList()));
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
