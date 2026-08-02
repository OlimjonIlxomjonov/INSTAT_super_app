import 'package:my_template/core/utils/enums/app_enums.dart';

class DataRequestProcessUserEntity {
  final int id;
  final String userName;
  final String email;
  final String? avatar;
  final String firstName;
  final String lastName;
  final bool isVerified;

  const DataRequestProcessUserEntity({
    required this.id,
    this.userName = '',
    this.email = '',
    this.avatar,
    this.firstName = '',
    this.lastName = '',
    this.isVerified = false,
  });

  String get fullName {
    final name = '$firstName $lastName'.trim();
    return name.isEmpty ? userName : name;
  }
}

class DataRequestProcessEntity {
  final int id;
  final String? file;
  final String status;
  final String comment;
  final DataRequestProcessUserEntity? user;
  final int cycle;
  final DateTime? createdAt;
  final int? fileSize;

  const DataRequestProcessEntity({
    required this.id,
    this.file,
    this.status = '',
    this.comment = '',
    this.user,
    this.cycle = 1,
    this.createdAt,
    this.fileSize,
  });

  bool get hasFile => file != null && file!.isNotEmpty;

  /// Fayl nomi javobda kelmaydi — URL'ning oxirgi bo'lagidan olamiz.
  String get fileName {
    if (!hasFile) return '';
    final segments = Uri.tryParse(file!)?.pathSegments;
    if (segments == null || segments.isEmpty) return '';
    return segments.last;
  }

  MicroDataRequestStatus get processStatus {
    switch (status) {
      case 'accepted':
        return MicroDataRequestStatus.accepted;
      case 'rejected':
        return MicroDataRequestStatus.rejected;
      case 'pending_payment':
        return MicroDataRequestStatus.pendingPayment;
      case 'draft':
        return MicroDataRequestStatus.draft;
      case 'in_review':
      default:
        return MicroDataRequestStatus.inReview;
    }
  }
}
