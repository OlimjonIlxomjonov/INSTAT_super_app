import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/course_files_entity/course_file_entity.dart';

class CourseFilesModel extends CourseFileEntity {
  CourseFilesModel({
    super.file,
    super.fileExtension,
    super.fileName,
    super.filePath,
    super.fileSize,
    super.id,
    super.lesson,
  });

  factory CourseFilesModel.fromJson(Map<String, dynamic> json) {
    return CourseFilesModel(
      id: json['id'] as int?,
      lesson: json['lesson'] as int?,
      file: json['file'] as String?,
      fileName: json['file_name'] as String?,
      fileExtension: json['file_extension'] as String?,
      filePath: json['file_path'] as String?,
      fileSize: json['file_size'] as int?,
    );
  }
}
