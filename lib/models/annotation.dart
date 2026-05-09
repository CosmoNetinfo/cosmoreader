import 'dart:convert';

enum AnnotationType { highlight, note, drawing }

class Annotation {
  final int? id;
  final String filePath;
  final int pageNumber;
  final AnnotationType type;
  final Map<String, dynamic> data;
  final String colorHex;
  final DateTime createdAt;

  Annotation({
    this.id,
    required this.filePath,
    required this.pageNumber,
    required this.type,
    required this.data,
    required this.colorHex,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'file_path': filePath,
      'page_number': pageNumber,
      'type': type.name,
      'data': jsonEncode(data),
      'color': colorHex,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Annotation.fromMap(Map<String, dynamic> map) {
    return Annotation(
      id: map['id'],
      filePath: map['file_path'],
      pageNumber: map['page_number'],
      type: AnnotationType.values.byName(map['type']),
      data: jsonDecode(map['data']),
      colorHex: map['color'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
