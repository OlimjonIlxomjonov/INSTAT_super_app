import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/selected_file_container/selected_file_container_wg.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_category_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/regions/region_entity.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/request_formatters.dart';

/// So'rovni ko'rsatish uchun yagona ma'lumot to'plami.
/// Wizard'ning 3-bosqichi ham, faqat o'qish uchun sahifa ham shundan
/// foydalanadi — ko'rinish bir joyda ta'riflanadi.
class DataRequestSummaryData {
  final int? id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String companyName;
  final DataRequestCategoryEntity? category;
  final SelectedArea? area;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String description;
  final String aim;
  final bool hasFile;
  final String fileName;
  final int? fileSize;

  const DataRequestSummaryData({
    this.id,
    this.fullName = '',
    this.email = '',
    this.phoneNumber = '',
    this.companyName = '',
    this.category,
    this.area,
    this.dateFrom,
    this.dateTo,
    this.description = '',
    this.aim = '',
    this.hasFile = false,
    this.fileName = '',
    this.fileSize,
  });
}

class RequestSummaryBodyWg extends StatelessWidget {
  const RequestSummaryBodyWg({
    super.key,
    required this.data,
    this.trailing,
    this.onFileTap,
  });

  final DataRequestSummaryData data;

  /// Sarlavha qatorining o'ng tomoni — masalan status belgisi.
  /// Berilmasa ID ko'rsatiladi.
  final Widget? trailing;

  /// Biriktirilgan faylni ochish. Wizard'da fayl hali yuklanmagan bo'lishi
  /// mumkin, shuning uchun ixtiyoriy.
  final VoidCallback? onFileTap;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// SHAXSIY MA'LUMOTLAR
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                localization.requestPersonalInfoTitle,
                style: CustomTextStyles.h2,
              ),
            ),
            if (trailing != null)
              trailing!
            else if (data.id != null)
              Text('ID #${data.id}', style: CustomTextStyles.h3),
          ],
        ),
        const SizedBox(height: 16),
        _SummaryRow(
          label: localization.requestFullNameLabel,
          value: data.fullName,
        ),
        _SummaryRow(label: localization.emailLabel, value: data.email),
        _SummaryRow(
          label: localization.phoneNumberLabel,
          value: data.phoneNumber,
        ),
        _SummaryRow(
          label: localization.requestCompanyLabel,
          value: data.companyName,
        ),

        const SizedBox(height: 20),

        /// SO'ROV TAFSILOTLARI
        Text(localization.requestDetailsTitle, style: CustomTextStyles.h2),
        const SizedBox(height: 16),
        _SummaryRow(
          label: localization.requestCategoryLabel,
          value: data.category?.localizedName(localeCode) ?? '',
        ),
        _SummaryRow(
          label: localization.requestAreaSummaryLabel,
          value: _areaLabel(data.area, localization, localeCode),
        ),
        _SummaryRow(
          label: localization.requestPeriodSummaryLabel,
          value: _periodLabel(),
        ),
        _SummaryRow(
          label: localization.requestDescriptionSummaryLabel,
          value: data.description,
        ),
        _SummaryRow(
          label: localization.requestAimSummaryLabel,
          value: data.aim,
        ),

        /// BIRIKTIRILGAN FAYL
        if (data.hasFile) ...[
          const SizedBox(height: 4),
          Text(
            localization.requestAttachedFileLabel,
            style: CustomTextStyles.h3half,
          ),
          const SizedBox(height: 8),
          SelectedFileContainerWg(
            fileName: data.fileName,
            fileSize: formatRequestFileSize(data.fileSize),
            onTap: onFileTap,
          ),
        ],
      ],
    );
  }

  String _areaLabel(
    SelectedArea? area,
    AppLocalizations localization,
    String localeCode,
  ) {
    if (area == null) return '';
    if (area.isWholeRepublic) return localization.requestWholeRepublic;
    final regionName = area.region!.localizedName(localeCode);
    final district = area.district;
    if (district == null) {
      return '$regionName, ${localization.requestWholeRegion}';
    }
    return '$regionName, ${district.localizedName(localeCode)}';
  }

  String _periodLabel() {
    final from = formatRequestDate(data.dateFrom);
    final to = formatRequestDate(data.dateTo);
    if (from.isEmpty) return '';
    return to.isEmpty ? from : '$from - $to';
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final hasValue = value.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: CustomTextStyles.h3half),
          const SizedBox(height: 4),
          Text(
            hasValue ? value : localization.requestNotEntered,
            style: AppTextStyles.source.regular(
              fontSize: 14,
              color: hasValue
                  ? AppColors.greyScale.grey700
                  : AppColors.greyScale.grey400,
            ),
          ),
        ],
      ),
    );
  }
}
