import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RecentFile {
  final String path;
  final String name;
  final DateTime openedAt;

  const RecentFile({
    required this.path,
    required this.name,
    required this.openedAt,
  });

  Map<String, dynamic> toJson() => {
    'path': path,
    'name': name,
    'openedAt': openedAt.toIso8601String(),
  };

  factory RecentFile.fromJson(Map<String, dynamic> json) => RecentFile(
    path: json['path'] as String,
    name: json['name'] as String,
    openedAt: DateTime.parse(json['openedAt'] as String),
  );
}

class RecentFilesService {
  static const _key = 'cosmonet_recent_files';
  static const _maxRecent = 20;

  static Future<List<RecentFile>> getRecent() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw
        .map((e) => RecentFile.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.openedAt.compareTo(a.openedAt));
  }

  static Future<void> addFile(String path, String name) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_key) ?? [];

    // Rimuovi duplicati stesso path
    final filtered = existing.where((e) {
      final m = jsonDecode(e) as Map<String, dynamic>;
      return m['path'] != path;
    }).toList();

    final newEntry = jsonEncode(RecentFile(
      path: path,
      name: name,
      openedAt: DateTime.now(),
    ).toJson());

    filtered.insert(0, newEntry);

    if (filtered.length > _maxRecent) {
      filtered.removeRange(_maxRecent, filtered.length);
    }

    await prefs.setStringList(_key, filtered);
  }

  static Future<void> removeFile(String path) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_key) ?? [];
    final filtered = existing.where((e) {
      final m = jsonDecode(e) as Map<String, dynamic>;
      return m['path'] != path;
    }).toList();
    await prefs.setStringList(_key, filtered);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
