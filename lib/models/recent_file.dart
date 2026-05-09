class RecentFile {
  final String path;
  final String name;
  final int totalPages;
  final int currentPage;
  final DateTime lastOpened;
  final double fileSize; // in MB

  RecentFile({
    required this.path,
    required this.name,
    required this.totalPages,
    required this.currentPage,
    required this.lastOpened,
    required this.fileSize,
  });

  double get progress => totalPages > 0 ? currentPage / totalPages : 0.0;

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'name': name,
      'totalPages': totalPages,
      'currentPage': currentPage,
      'lastOpened': lastOpened.toIso8601String(),
      'fileSize': fileSize,
    };
  }

  factory RecentFile.fromJson(Map<String, dynamic> json) {
    return RecentFile(
      path: json['path'],
      name: json['name'],
      totalPages: json['totalPages'],
      currentPage: json['currentPage'],
      lastOpened: DateTime.parse(json['lastOpened']),
      fileSize: (json['fileSize'] as num).toDouble(),
    );
  }
}
