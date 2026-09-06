import 'package:my_template/features/main_app/home/domain/entity/site_faqs/site_faqs_entity.dart';

class SiteFaqsModel extends SiteFaqsEntity {
  SiteFaqsModel({
    required super.id,
    required super.questionUz,
    required super.questionRu,
    required super.questionEn,
    required super.answerUz,
    required super.answerRu,
    required super.answerEn,
    required super.module,
  });

  factory SiteFaqsModel.fromJson(Map<String, dynamic> json) {
    return SiteFaqsModel(
      id: json['id'] ?? 0,
      questionUz: json['question_uz'] ?? 'Unknown',
      questionRu: json['question_ru'] ?? 'Unknown',
      questionEn: json['question_en'] ?? 'Unknown',
      answerUz: json['answer_uz'] ?? 'Unknown',
      answerRu: json['answer_ru'] ?? 'Unknown',
      answerEn: json['answer_en'] ?? 'Unknown',
      module: json['module'] ?? 'Unknown',
    );
  }
}
