class CourseFileEntity {
  final int? id;
  final int? lesson;
  final String? file;
  final String? fileName;
  final String? fileExtension;
  final String? filePath;
  final int? fileSize;

  const CourseFileEntity({
    this.id,
    this.lesson,
    this.file,
    this.fileName,
    this.fileExtension,
    this.filePath,
    this.fileSize,
  });
}
