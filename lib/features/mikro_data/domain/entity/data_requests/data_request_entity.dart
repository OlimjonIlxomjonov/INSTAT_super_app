import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_category_entity.dart';

class DataRequestEntity {
  final int id;
  final int userId;
  final String fullName;
  final String status;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final String fileName;
  final int? fileSize;
  final String fileExtension;
  final DataRequestCategoryEntity? category;
  final String? description;
  final String? aim;
  final String price;
  final int? expertId;

  const DataRequestEntity({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.status,
    this.updatedAt,
    this.createdAt,
    this.fileName = '',
    this.fileSize,
    this.fileExtension = '',
    this.category,
    this.description,
    this.aim,
    this.price = '0',
    this.expertId,
  });

  MicroDataRequestStatus get requestStatus {
    switch (status) {
      case 'paid':
        return MicroDataRequestStatus.accepted;
      case 'in_review':
        return MicroDataRequestStatus.inReview;
      case 'rejected':
        return MicroDataRequestStatus.rejected;
      case 'pending_payment':
        return MicroDataRequestStatus.pendingPayment;
      case 'draft':
        return MicroDataRequestStatus.draft;
      default:
        return MicroDataRequestStatus.draft;
    }
  }
}
