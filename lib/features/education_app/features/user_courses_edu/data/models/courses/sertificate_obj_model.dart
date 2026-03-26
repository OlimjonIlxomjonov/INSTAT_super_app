import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/sertificate_object_entity.dart';

class CertificateObjModel extends CertificateObject {
  CertificateObjModel({
    required super.x,
    required super.y,
    required super.id,
    required super.size,
    required super.color,
    required super.label,
    required super.content,
  });

  factory CertificateObjModel.fromJson(Map<String, dynamic> json) {
    return CertificateObjModel(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      id: json['id'],
      size: json['size'].toString(),
      color: json['color'],
      label: json['label'],
      content: json['content'],
    );
  }
}
