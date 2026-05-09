import '../models/annotation.dart';
import 'database_service.dart';

class AnnotationService {
  final DatabaseService _dbService = DatabaseService();

  Future<int> addAnnotation(Annotation annotation) async {
    final db = await _dbService.database;
    return await db.insert('annotations', annotation.toMap());
  }

  Future<List<Annotation>> getAnnotationsForFile(String filePath) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'annotations',
      where: 'file_path = ?',
      whereArgs: [filePath],
      orderBy: 'page_number ASC',
    );
    return List.generate(maps.length, (i) => Annotation.fromMap(maps[i]));
  }

  Future<void> deleteAnnotation(int id) async {
    final db = await _dbService.database;
    await db.delete(
      'annotations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateAnnotation(Annotation annotation) async {
    if (annotation.id == null) return;
    final db = await _dbService.database;
    await db.update(
      'annotations',
      annotation.toMap(),
      where: 'id = ?',
      whereArgs: [annotation.id],
    );
  }
}
