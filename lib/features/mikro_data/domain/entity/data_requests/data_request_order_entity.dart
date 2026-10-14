class DataRequestOrderEntity {
  final int id;
  final String status;
  final String? code;

  const DataRequestOrderEntity({
    required this.id,
    required this.status,
    this.code,
  });

  String? buildRedirectUrl(String paymentMethod) {
    if (paymentMethod == 'payme') {
      if (code == null || code!.isEmpty) return null;
      return 'https://checkout.paycom.uz/$code';
    }
    if (paymentMethod == 'click') {
      if (code == null || code!.isEmpty) return null;
      return 'https://my.click.uz/services/pay?$code';
    }
    return null;
  }
}
