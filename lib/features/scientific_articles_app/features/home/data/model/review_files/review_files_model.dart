import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_files/review_files_entity.dart';

class ReviewFilesModel extends ReviewFilesEntity {
  ReviewFilesModel({
    required super.id,
    super.file,
    super.fileExtension,
    super.fileName,
    super.filePath,
    super.fileSize,
    super.review,
    super.type,
  });

  factory ReviewFilesModel.fromJson(Map<String, dynamic> json) {
    return ReviewFilesModel(
      id: json['id'] as int,
      type: json['type'] as String?,
      review: json['review'] as int?,
      file: json['file'] as String?,
      fileName: json['file_name'] as String?,
      fileExtension: json['file_extension'] as String?,
      filePath: json['file_path'] as String?,
      fileSize: json['file_size'] as int?,
    );
  }
}
