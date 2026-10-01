class ArticleQuoteEntity {
  final int id;
  final int quotesCount;
  final String text;

  const ArticleQuoteEntity({
    required this.id,
    this.quotesCount = 0,
    this.text = '',
  });
}
