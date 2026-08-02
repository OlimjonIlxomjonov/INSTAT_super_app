/// `POST data-requests/`, `PUT data-requests/{id}/` va fayl yuklash
/// javoblaridagi to'liq obyekt.
///
/// Ro'yxatdagi [DataRequestEntity] dan farq qiladi: bu yerda `category`
/// obyekt emas, id; hudud esa kod (string) ko'rinishida keladi.
class DataRequestDetailEntity {
  final int id;
  final String fullName;
  final String? companyName;
  final int? categoryId;
  final String? description;
  final String? aim;
  final String? regionCode;
  final String? districtCode;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? phoneNumber;
  final String? email;
  final String status;
  final DateTime? createdAt;
  final String? fileUrl;
  final String fileName;
  final int? fileSize;
  final String fileExtension;

  const DataRequestDetailEntity({
    required this.id,
    required this.fullName,
    this.companyName,
    this.categoryId,
    this.description,
    this.aim,
    this.regionCode,
    this.districtCode,
    this.dateFrom,
    this.dateTo,
    this.phoneNumber,
    this.email,
    this.status = 'draft',
    this.createdAt,
    this.fileUrl,
    this.fileName = '',
    this.fileSize,
    this.fileExtension = '',
  });

  bool get hasFile => fileName.isNotEmpty || (fileUrl?.isNotEmpty ?? false);
}
