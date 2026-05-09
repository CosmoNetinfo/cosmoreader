import '../models/bookmark.dart';
import 'database_service.dart';

class BookmarkService {
  final DatabaseService _dbService = DatabaseService();

  Future<int> addBookmark(Bookmark bookmark) async {
    final db = await _dbService.database;
    return await db.insert('bookmarks', bookmark.toMap());
  }

  Future<List<Bookmark>> getBookmarksForFile(String filePath) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bookmarks',
      where: 'file_path = ?',
      whereArgs: [filePath],
      orderBy: 'page_number ASC',
    );
    return List.generate(maps.length, (i) => Bookmark.fromMap(maps[i]));
  }

  Future<void> deleteBookmark(int id) async {
    final db = await _dbService.database;
    await db.delete(
      'bookmarks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  Future<bool> isPageBookmarked(String filePath, int pageNumber) async {
    final db = await _dbService.database;
    final maps = await db.query(
      'bookmarks',
      where: 'file_path = ? AND page_number = ?',
      whereArgs: [filePath, pageNumber],
    );
    return maps.isNotEmpty;
  }

  Future<void> removeBookmark(String filePath, int pageNumber) async {
    final db = await _dbService.database;
    await db.delete(
      'bookmarks',
      where: 'file_path = ? AND page_number = ?',
      whereArgs: [filePath, pageNumber],
    );
  }
}
