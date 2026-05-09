class PdfDocumentInfo {
  final String title;
  final String author;
  final int totalPages;
  final String filePath;
  final String fileSize;
  final String creator;
  final DateTime? creationDate;
  final DateTime? modificationDate;

  PdfDocumentInfo({
    required this.title,
    required this.author,
    required this.totalPages,
    required this.filePath,
    required this.fileSize,
    required this.creator,
    this.creationDate,
    this.modificationDate,
  });
}
