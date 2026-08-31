import 'package:my_template/features/mikro_data/domain/entity/regions/region_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/reports/analysis_unit_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/reports/collection_method_entity.dart';

class ReportsEntity {
  final int id;
  final String name;
  final String uniqueId;
  final String status;
  final bool isActive;
  final CollectionMethodEntity? collectionMethod;
  final String periodicity;
  final String annotation;
  final List<String> topics;
  final AnalysisUnitEntity? analysisUnit;
  final RegionEntity? region;
  final DistrictEntity? district;
  final DateTime? timeCoverageFrom;
  final DateTime? timeCoverageTo;
  final double? coverage;
  final DateTime? dataPeriodFrom;
  final DateTime? dataPeriodTo;
  final String? samplingMethod;
  final String accessPolicy;
  final String? dataOwner;
  final String? contact;
  final dynamic externalResources;
  final String? termsOfUseFile;
  final int filesSize;
  final DateTime createdAt;

  const ReportsEntity({
    required this.id,
    required this.name,
    required this.uniqueId,
    required this.status,
    required this.isActive,
    this.collectionMethod,
    required this.periodicity,
    required this.annotation,
    required this.topics,
    this.analysisUnit,
    this.region,
    this.district,
    this.timeCoverageFrom,
    this.timeCoverageTo,
    this.coverage,
    this.dataPeriodFrom,
    this.dataPeriodTo,
    this.samplingMethod,
    required this.accessPolicy,
    this.dataOwner,
    this.contact,
    this.externalResources,
    this.termsOfUseFile,
    required this.filesSize,
    required this.createdAt,
  });

  String formattedLocation(String localeCode) {
    if (region == null && district == null) {
      return "Respublika bo‘yicha";
    }
    final rName = region?.localizedName(localeCode) ?? '';
    final dName = district?.localizedName(localeCode) ?? '';
    if (rName.isNotEmpty && dName.isNotEmpty) {
      return '$rName, $dName';
    } else if (rName.isNotEmpty) {
      return rName;
    } else if (dName.isNotEmpty) {
      return dName;
    }
    return "Respublika bo‘yicha";
  }
}
