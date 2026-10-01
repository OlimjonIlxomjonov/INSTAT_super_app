import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/article_quote/article_quote_entity.dart';

class ArticleQuoteModel extends ArticleQuoteEntity {
  ArticleQuoteModel({required super.id, super.quotesCount, super.text});

  factory ArticleQuoteModel.fromJson(Map<String, dynamic> json) {
    return ArticleQuoteModel(
      id: json['id'] ?? 0,
      quotesCount: json['quotes_count'] ?? 0,
      text: json['text'] ?? '',
    );
  }
}
