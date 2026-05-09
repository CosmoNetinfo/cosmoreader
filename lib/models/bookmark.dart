class Bookmark {
  final int? id;
  final String filePath;
  final int pageNumber;
  final DateTime createdAt;
  final String note;

  Bookmark({
    this.id,
    required this.filePath,
    required this.pageNumber,
    required this.createdAt,
    this.note = '',
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'file_path': filePath,
      'page_number': pageNumber,
      'created_at': createdAt.toIso8601String(),
      'note': note,
    };
  }

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      id: map['id'],
      filePath: map['file_path'],
      pageNumber: map['page_number'],
      createdAt: DateTime.parse(map['created_at']),
      note: map['note'] ?? '',
    );
  }
}
