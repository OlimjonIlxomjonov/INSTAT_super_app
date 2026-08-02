import 'package:my_template/features/mikro_data/data/model/data_requests/data_request_category_model.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_entity.dart';

class DataRequestModel extends DataRequestEntity {
  const DataRequestModel({
    required super.id,
    required super.userId,
    required super.fullName,
    required super.status,
    super.updatedAt,
    super.createdAt,
    super.fileName,
    super.fileSize,
    super.fileExtension,
    super.category,
    super.description,
    super.aim,
    super.price,
    super.expertId,
  });

  factory DataRequestModel.fromJson(Map<String, dynamic>? json) {
    return DataRequestModel(
      id: json?['id'] ?? 0,
      userId: json?['user'] ?? 0,
      fullName: json?['full_name'] ?? '',
      status: json?['status'] ?? '',
      updatedAt: DateTime.tryParse(json?['updated_at']?.toString() ?? ''),
      createdAt: DateTime.tryParse(json?['created_at']?.toString() ?? ''),
      fileName: json?['file_name'] ?? '',
      fileSize: json?['file_size'],
      fileExtension: json?['file_extension'] ?? '',
      category: DataRequestCategoryModel.fromJson(json?['category']),
      description: json?['description'],
      aim: json?['aim'],
      // Backend narxni string qilib qaytaradi ("448180167"), lekin ba'zan
      // son bo'lib kelishi mumkin — ikkalasini ham qabul qilamiz.
      price: json?['price']?.toString() ?? '0',
      expertId: json?['expert'],
    );
  }
}
