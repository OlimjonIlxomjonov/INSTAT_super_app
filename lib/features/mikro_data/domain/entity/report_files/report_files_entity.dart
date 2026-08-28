class ReportFilesEntity {
  final int id, dataReports;
  final String file, fileName, fileExtension;
  final int fileSize;
  final String createdAt;

  ReportFilesEntity({
    required this.id,
    required this.dataReports,
    required this.file,
    required this.fileName,
    required this.fileExtension,
    required this.createdAt,
    required this.fileSize,
  });
}
