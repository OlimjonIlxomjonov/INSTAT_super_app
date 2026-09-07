import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_report_ref_entity.dart';

class DataReportRefModel extends DataReportRefEntity {
  const DataReportRefModel({required super.id, required super.name});

  /// Backend `data_report` ni ba'zan to'liq obyekt, ba'zan faqat id qilib
  /// qaytaradi — ikkalasini ham qabul qilamiz.
  static DataReportRefModel? tryFromJson(dynamic value) {
    if (value == null) return null;
    if (value is int) return DataReportRefModel(id: value, name: '');
    if (value is Map) {
      return DataReportRefModel(
        id: value['id'] ?? 0,
        name: value['name'] ?? '',
      );
    }
    return null;
  }
}
