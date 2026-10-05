class SimilarBookEntity {
  final int id;
  final String name;
  final String type;
  final int price;
  final int categoryId;

  const SimilarBookEntity({
    required this.id,
    this.name = '',
    this.type = '',
    this.price = 0,
    this.categoryId = 0,
  });
}
