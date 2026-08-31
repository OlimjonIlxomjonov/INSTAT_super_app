import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/library_stats/library_stats_entity.dart';

class LibraryStatsModel extends LibraryStatsEntity {
  LibraryStatsModel({
    required super.allOnline,
    required super.saved,
    required super.loans,
    required super.activeLoans,
    required super.ok,
  });

  factory LibraryStatsModel.fromJson(Map<String, dynamic> json) {
    return LibraryStatsModel(
      allOnline: json['all_online'] ?? 0,
      saved: json['saved'] ?? 0,
      loans: json['loans'] ?? 0,
      activeLoans: json['active_loans'] ?? 0,
      ok: json['ok'] ?? false,
    );
  }
}
