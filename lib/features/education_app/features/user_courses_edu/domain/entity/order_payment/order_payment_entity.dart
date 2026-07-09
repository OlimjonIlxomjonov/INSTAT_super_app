class OrderPaymentEntity {
  final int id;
  final String status;
  final String redirectUrl;

  OrderPaymentEntity({
    required this.id,
    required this.status,
    required this.redirectUrl,
  });
}
