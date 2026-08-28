class NotifEntity {
  final int id;
  final String title, link;
  final String? message;
  final bool isRead;
  final String createdAt;

  NotifEntity({
    required this.id,
    required this.title,
    required this.link,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });
}
