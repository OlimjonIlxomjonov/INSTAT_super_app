import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/selected_file_container/selected_file_container_wg.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/request_formatters.dart';

/// So'rovni ko'rsatish uchun yagona ma'lumot to'plami.
/// Wizard'ning yakuniy bosqichi ham, faqat o'qish uchun sahifa ham shundan
/// foydalanadi.
class DataRequestSummaryData {
  final int? id;

  final String companyName;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String teamMembers;

  final String projectName;
  final String projectAim;
  final String benefit;
  final String aimToUse;

  final String dataReportName;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String whyNotEnough;
  final String notEnoughComment;

  final String processingEnvironment;
  final DateTime? entryDateFrom;
  final DateTime? entryDateTo;

  final String expectation;
  final String plan;

  final bool hasFile;
  final String fileName;
  final int? fileSize;

  final bool hasCompanyFile;
  final String companyFileName;
  final int? companyFileSize;

  const DataRequestSummaryData({
    this.id,
    this.companyName = '',
    this.fullName = '',
    this.phoneNumber = '',
    this.email = '',
    this.teamMembers = '',
    this.projectName = '',
    this.projectAim = '',
    this.benefit = '',
    this.aimToUse = '',
    this.dataReportName = '',
    this.dateFrom,
    this.dateTo,
    this.whyNotEnough = '',
    this.notEnoughComment = '',
    this.processingEnvironment = '',
    this.entryDateFrom,
    this.entryDateTo,
    this.expectation = '',
    this.plan = '',
    this.hasFile = false,
    this.fileName = '',
    this.fileSize,
    this.hasCompanyFile = false,
    this.companyFileName = '',
    this.companyFileSize,
  });
}

class RequestSummaryBodyWg extends StatelessWidget {
  const RequestSummaryBodyWg({
    super.key,
    required this.data,
    this.trailing,
    this.onFileTap,
    this.onCompanyFileTap,
  });

  final DataRequestSummaryData data;

  /// Sarlavha qatorining o'ng tomoni — masalan status belgisi.
  final Widget? trailing;

  final VoidCallback? onFileTap;
  final VoidCallback? onCompanyFileTap;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (trailing != null || data.id != null) ...[
          Row(
            children: [
              if (data.id != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.greyScale.grey50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'ID #${data.id}',
                    style: AppTextStyles.source.medium(
                      fontSize: 13,
                      color: AppColors.greyScale.grey700,
                    ),
                  ),
                ),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 16),
        ],

        /// SHAXSIY MA'LUMOT
        _SummaryCard(
          title: localization.requestPersonalInfoTitle,
          rows: [
            _Row(localization.requestOrganizationLabel, data.companyName),
            _Row(localization.requestResearcherLabel, data.fullName),
            _Row(
              localization.requestContactLabel,
              data.phoneNumber,
              inline: true,
            ),
            _Row(localization.emailLabel, data.email, inline: true),
            _Row(localization.requestTeamMembersLabel, data.teamMembers),
          ],
        ),

        /// TADQIQOT LOYIHASI
        _SummaryCard(
          title: localization.requestProjectSectionTitle,
          rows: [
            _Row(localization.requestProjectNameLabel, data.projectName),
            _Row(localization.requestProjectAimLabel, data.projectAim),
            _Row(localization.requestBenefitLabel, data.benefit),
            _Row(localization.requestAimToUseLabel, data.aimToUse),
          ],
        ),

        /// SO'RALADIGAN MA'LUMOT
        _SummaryCard(
          title: localization.requestRequestedDataTitle,
          rows: [
            _Row(localization.requestDataReportLabel, data.dataReportName),
            _Row(
              localization.requestPeriodSummary,
              _periodLabel(data.dateFrom, data.dateTo),
              inline: true,
            ),
            _Row(localization.requestWhyNotEnoughLabel, data.whyNotEnough),
            _Row(
              localization.requestNotEnoughCommentLabel,
              data.notEnoughComment,
            ),
          ],
        ),

        /// XAVFSIZLIK, MUHIT VA MUDDAT
        _SummaryCard(
          title: localization.requestStepSecurityEnv,
          rows: [
            _Row(
              localization.requestProcessingEnvLabel,
              data.processingEnvironment,
              inline: true,
            ),
            _Row(
              localization.requestEntryPeriodLabel,
              _periodLabel(data.entryDateFrom, data.entryDateTo),
              inline: true,
            ),
          ],
        ),

        /// NATIJALAR VA YAKUN
        _SummaryCard(
          title: localization.requestResultsSectionTitle,
          rows: [
            _Row(localization.requestExpectationLabel, data.expectation),
            _Row(localization.requestPlanLabel, data.plan),
          ],
        ),

        /// HUJJATLAR
        if (data.hasFile || data.hasCompanyFile)
          _SummaryCard(
            title: localization.requestDocuments,
            rows: const [],
            children: [
              if (data.hasFile) ...[
                Text(
                  localization.requestApprovalFileTitle,
                  style: AppTextStyles.source.regular(
                    fontSize: 13,
                    color: AppColors.greyScale.grey600,
                  ),
                ),
                const SizedBox(height: 8),
                SelectedFileContainerWg(
                  fileName: data.fileName,
                  fileSize: formatRequestFileSize(data.fileSize),
                  onTap: onFileTap,
                ),
              ],
              if (data.hasFile && data.hasCompanyFile)
                const SizedBox(height: 16),
              if (data.hasCompanyFile) ...[
                Text(
                  localization.requestCompanyFileTitle,
                  style: AppTextStyles.source.regular(
                    fontSize: 13,
                    color: AppColors.greyScale.grey600,
                  ),
                ),
                const SizedBox(height: 8),
                SelectedFileContainerWg(
                  fileName: data.companyFileName,
                  fileSize: formatRequestFileSize(data.companyFileSize),
                  onTap: onCompanyFileTap,
                ),
              ],
            ],
          ),
      ],
    );
  }

  String _periodLabel(DateTime? from, DateTime? to) {
    final start = formatRequestDate(from);
    final end = formatRequestDate(to);
    if (start.isEmpty) return end;
    if (end.isEmpty) return start;
    return '$start — $end';
  }
}

class _Row {
  final String label;
  final String value;

  /// Qisqa qiymatlar (sana, telefon, e-pochta) yorliq bilan bir qatorda.
  final bool inline;

  const _Row(this.label, this.value, {this.inline = false});
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.rows,
    this.children = const [],
  });

  final String title;
  final List<_Row> rows;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: CustomTextStyles.h3),
          const SizedBox(height: 12),
          for (final row in rows)
            _SummaryRow(label: row.label, value: row.value, inline: row.inline),
          if (children.isNotEmpty) ...children,
          const SizedBox(height: 12),
          Divider(height: 1, color: AppColors.greyScale.grey200),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.inline,
  });

  final String label;
  final String value;
  final bool inline;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final trimmed = value.trim();
    final hasValue = trimmed.isNotEmpty;
    final shown = hasValue ? trimmed : localization.requestNotEntered;

    final labelStyle = AppTextStyles.source.regular(
      fontSize: 13,
      color: AppColors.greyScale.grey600,
    );
    final valueStyle = AppTextStyles.source.medium(
      fontSize: 14,
      color: hasValue
          ? AppColors.greyScale.grey900
          : AppColors.greyScale.grey400,
    );

    if (inline) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: labelStyle),
            const SizedBox(width: 12),
            Expanded(
              child: Text(shown, textAlign: TextAlign.right, style: valueStyle),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: labelStyle),
          const SizedBox(height: 4),
          Text(shown, style: valueStyle),
        ],
      ),
    );
  }
}
