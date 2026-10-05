import 'package:flutter/material.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/common/params/micro_data_params/data_request_params.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/assets/app_images.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/features/mikro_data/domain/usecase/data_requests/add_request_use_cases.dart';
import 'package:url_launcher/url_launcher.dart';

const String _paymentMethodClick = 'click';
const String _paymentMethodPayme = 'payme';

/// To'lov kutayotgan ma'lumot so'rovi uchun click/payme tanlovi.
/// Narx so'rovning o'z `price` maydonidan keladi.
class RequestPayOptionsWg extends StatefulWidget {
  final int requestId;
  final String price;
  final VoidCallback onSuccess;

  const RequestPayOptionsWg({
    super.key,
    required this.requestId,
    required this.price,
    required this.onSuccess,
  });

  @override
  State<RequestPayOptionsWg> createState() => _RequestPayOptionsWgState();
}

class _RequestPayOptionsWgState extends State<RequestPayOptionsWg> {
  String? _payingMethod;

  Future<void> _pay(String paymentMethod) async {
    if (_payingMethod != null) return;
    setState(() => _payingMethod = paymentMethod);
    try {
      final order = await sl<CreateDataRequestOrderUseCase>()(
        CreateDataRequestOrderParams(
          requestId: widget.requestId,
          paymentMethod: paymentMethod,
        ),
      );
      if (!mounted) return;
      AppRoute.close();
      if (order.redirectUrl.isNotEmpty) {
        await launchUrl(
          Uri.parse(order.redirectUrl),
          mode: LaunchMode.externalApplication,
        );
      }
      widget.onSuccess();
    } catch (e) {
      if (!mounted) return;
      setState(() => _payingMethod = null);
      final localization = AppLocalizations.of(context)!;
      errorFlushBar(
        context,
        apiErrorMessage(e) ?? localization.savingError,
        details: apiErrorDetails(e),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            localization.requestPrice(formatPrice(widget.price)),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildPaymentMethod(
                  AppImages.clickPayment,
                  _paymentMethodClick,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPaymentMethod(
                  AppImages.paymePayment,
                  _paymentMethodPayme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(String imagePath, String paymentMethod) {
    final isLoading = _payingMethod == paymentMethod;
    return GestureDetector(
      onTap: isLoading ? null : () => _pay(paymentMethod),
      child: Container(
        padding: const EdgeInsets.all(15),
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.greyScale.grey50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.greyScale.grey200),
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : Image.asset(imagePath, fit: BoxFit.cover),
      ),
    );
  }
}
