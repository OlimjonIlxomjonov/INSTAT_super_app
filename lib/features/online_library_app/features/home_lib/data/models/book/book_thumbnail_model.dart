import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_thumbnail_entity.dart';

class BookThumbnailModel extends BookThumbnailEntity {
  BookThumbnailModel({
    required super.id,
    required super.file,
    required super.fileName,
    required super.fileExtension,
    required super.fileSize,
  });

  factory BookThumbnailModel.fromJson(Map<String, dynamic> json) {
    return BookThumbnailModel(
      id: json['id'],
      file: json['file'] ?? '',
      fileName: json['file_name'] ?? '',
      fileExtension: json['file_extension'] ?? '',
      fileSize: json['file_size'] ?? 0,
    );
  }
}
