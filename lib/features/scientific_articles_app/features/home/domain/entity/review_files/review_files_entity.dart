class ReviewFilesEntity {
  final int id;
  final String? type;
  final int? review;
  final String? file;
  final String? fileName;
  final String? fileExtension;
  final String? filePath;
  final int? fileSize;

  ReviewFilesEntity({
    required this.id,
    this.type,
    this.review,
    this.file,
    this.fileName,
    this.fileExtension,
    this.filePath,
    this.fileSize,
  });


}
