import 'package:my_template/features/mikro_data/domain/entity/regions/region_entity.dart';

class ReportsOptionsEntity {
  final int id;
  final DateTime dateFrom;
  final DateTime dateTo;
  final String fileExtension;
  final RegionEntity? region;
  final DistrictEntity? district;
  final int? dataReport;
  final String? file;
  final dynamic fileSize;
  final String? fileName;
  final String? price;
  final DateTime? createdAt;

  const ReportsOptionsEntity({
    required this.id,
    required this.dateFrom,
    required this.dateTo,
    required this.fileExtension,
    this.region,
    this.district,
    this.dataReport,
    this.file,
    this.fileSize,
    this.fileName,
    this.price,
    this.createdAt,
  });
}

