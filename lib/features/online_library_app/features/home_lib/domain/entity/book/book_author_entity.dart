class BookAuthorEntity {
  final int id;
  final String name;
  final String? image;
  final String createdAt;

  BookAuthorEntity({
    required this.id,
    required this.name,
    this.image,
    required this.createdAt,
  });
}
