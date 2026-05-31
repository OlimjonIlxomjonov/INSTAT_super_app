import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_detail/review_detail_entity.dart';

class ReviewDetailModel extends ReviewDetailEntity {
  ReviewDetailModel({
    required super.id,
    required super.title,
    required super.articleType,
    required super.journalSection,
    super.annotationUz,
    super.annotationRu,
    super.annotationEn,
    super.mainFile,
    super.mainFileSize,
    super.antiplagiatFile,
    super.antiplagiatFileSize,
    required super.udkCode,
    required super.status,
    required super.language,
    super.expert,
    required super.userId,
    required super.keywords,
    super.createdAt,
  });

  factory ReviewDetailModel.fromJson(Map<String, dynamic> json) {
    return ReviewDetailModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      articleType: json['article_type'] ?? 0,
      journalSection: json['journal_section'] ?? 0,
      annotationUz: json['annotation_uz'],
      annotationRu: json['annotation_ru'],
      annotationEn: json['annotation_en'],
      mainFile: json['main_file'],
      mainFileSize: json['main_file_size'],
      antiplagiatFile: json['antiplagiat_file'],
      antiplagiatFileSize: json['antiplagiat_file_size'],
      udkCode: json['udk_code'] ?? '',
      status: json['status'] ?? '',
      language: json['language'] ?? '',
      expert: json['expert'],
      userId: json['user_id'] ?? 0,
      keywords: json['keywords'] ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }
}
