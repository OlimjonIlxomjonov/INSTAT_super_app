class ArticleOrderPaymentEntity {
  final int id;
  final String status;

  // Payme — base64 encoded checkout code
  final String? code;

  // Click — individual params to construct the URL
  final String? merchantId;
  final String? serviceId;
  final String? amount;
  final String? transactionParam;

  ArticleOrderPaymentEntity({
    required this.id,
    required this.status,
    this.code,
    this.merchantId,
    this.serviceId,
    this.amount,
    this.transactionParam,
  });

  /// Returns the URL to launch for the given [paymentMethod].
  /// Both Click and Payme return their data in a single `code` field:
  /// - 'payme'  → https://checkout.paycom.uz/{code}
  /// - 'click'  → https://my.click.uz/services/pay?{code}
  String? buildRedirectUrl(String paymentMethod) {
    if (code == null || code!.isEmpty) return null;
    if (paymentMethod == 'payme') {
      return 'https://checkout.paycom.uz/$code';
    }
    if (paymentMethod == 'click') {
      return 'https://my.click.uz/services/pay?$code';
    }
    return null;
  }
}

