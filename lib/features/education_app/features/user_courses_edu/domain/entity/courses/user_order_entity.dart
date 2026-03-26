class UserOrder {
  final int id;
  final String? paymentMethod;
  final String status;
  final int currentLesson;
  final String createdAt;
  final double progress;

  UserOrder({
    required this.id,
    this.paymentMethod,
    required this.status,
    required this.currentLesson,
    required this.createdAt,
    required this.progress,
  });


}
