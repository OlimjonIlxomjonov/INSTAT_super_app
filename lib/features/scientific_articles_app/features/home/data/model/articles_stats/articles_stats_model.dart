import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/articles_stats/articles_stats_entity.dart';

class ArticlesStatsModel extends ArticlesStatsEntity {
  ArticlesStatsModel({
    required super.all,
    required super.inReview,
    required super.cancelled,
    required super.published,
  });

  factory ArticlesStatsModel.fromJson(Map<String, dynamic> json) {
    return ArticlesStatsModel(
      all: json['all'] ?? 0,
      inReview: json['in_review'] ?? 0,
      cancelled: json['cancelled'] ?? 0,
      published: json['published'] ?? 0,
    );
  }
}
