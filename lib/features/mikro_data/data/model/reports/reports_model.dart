import 'package:my_template/features/mikro_data/data/model/reports/analysis_unit_model.dart';
import 'package:my_template/features/mikro_data/data/model/reports/collection_method_model.dart';
import 'package:my_template/features/mikro_data/domain/entity/reports/reports_entity.dart';

class ReportsModel extends ReportsEntity {
  ReportsModel({
    required super.id,
    required super.name,
    required super.uniqueId,
    required super.status,
    required super.isActive,
    super.collectionMethod,
    required super.periodicity,
    required super.annotation,
    required super.topics,
    super.analysisUnit,
    super.region,
    super.district,
    super.timeCoverageFrom,
    super.timeCoverageTo,
    super.coverage,
    super.dataPeriodFrom,
    super.dataPeriodTo,
    super.samplingMethod,
    required super.accessPolicy,
    super.dataOwner,
    super.contact,
    super.externalResources,
    super.termsOfUseFile,
    required super.filesSize,
    required super.createdAt,
  });

  factory ReportsModel.fromJson(Map<String, dynamic> json) {
    final collectionMethodJson =
        json['collection_method'] as Map<String, dynamic>?;
    final analysisUnitJson = json['analysis_unit'] as Map<String, dynamic>?;

    final topicsRaw = json['topics'];
    final topics = topicsRaw is List
        ? topicsRaw.map((e) => e?.toString() ?? '').toList()
        : <String>[];

    return ReportsModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      uniqueId: json['unique_id'] as String? ?? '',
      status: json['status'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? false,
      collectionMethod: collectionMethodJson != null
          ? CollectionMethodModel.fromJson(collectionMethodJson)
          : null,
      periodicity: json['periodicity'] as String? ?? '',
      annotation: json['annotation'] as String? ?? '',
      topics: topics,
      analysisUnit: analysisUnitJson != null
          ? AnalysisUnitModel.fromJson(analysisUnitJson)
          : null,
      region: json['region']?.toString(),
      district: json['district']?.toString(),
      timeCoverageFrom:
          DateTime.tryParse(json['time_coverage_from']?.toString() ?? ''),
      timeCoverageTo:
          DateTime.tryParse(json['time_coverage_to']?.toString() ?? ''),
      coverage: (json['coverage'] as num?)?.toDouble(),
      dataPeriodFrom:
          DateTime.tryParse(json['data_period_from']?.toString() ?? ''),
      dataPeriodTo:
          DateTime.tryParse(json['data_period_to']?.toString() ?? ''),
      samplingMethod: json['sampling_method'] as String?,
      accessPolicy: json['access_policy'] as String? ?? '',
      dataOwner: json['data_owner'] as String?,
      contact: json['contact'] as String?,
      externalResources: json['external_resources'],
      termsOfUseFile: json['terms_of_use_file'] as String?,
      filesSize: json['files_size'] as int? ?? 0,
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
