class Meta {
  final int total;
  final int perPage;
  final int currentPage;
  final int from;
  final int to;
  final int lastPage;

  Meta({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.from,
    required this.to,
    required this.lastPage,
  });
}
