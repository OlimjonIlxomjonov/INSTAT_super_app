import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/html_content_wg/html_content_wg.dart';
import 'package:my_template/features/vacancy_app/features/domain/entity/vacancy/vacancy_entity.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_provided_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_section_card_wg.dart';

class VacancyInfoBodyWg extends StatelessWidget {
  final VacancyEntity item;

  const VacancyInfoBodyWg({super.key, required this.item});

  bool _hasContent(String html) =>
      html.replaceAll(RegExp(r'<[^>]*>'), '').trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //! Lavozim
        Text(item.title, style: AppTextStyles.source.semiBold(fontSize: 18)),
        if (item.subtitle.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(item.subtitle, style: AppTextStyles.source.medium(fontSize: 16)),
        ],
        const SizedBox(height: 16),

        //! Shartlar
        VacancyProvidedWg(item: item),
        const SizedBox(height: 16),

        //! Talablar
        if (_hasContent(item.requirements)) ...[
          VacancySectionCardWg(
            title: l.requirementsTitle,
            child: HtmlContentWg(htmlData: item.requirements),
          ),
          const SizedBox(height: 16),
        ],

        //! Vazifalar
        if (_hasContent(item.responsibilities)) ...[
          VacancySectionCardWg(
            title: l.responsibilitiesTitle,
            child: HtmlContentWg(htmlData: item.responsibilities),
          ),
          const SizedBox(height: 16),
        ],

        //! Taklif
        if (_hasContent(item.offer))
          VacancySectionCardWg(
            title: l.offerTitle,
            child: HtmlContentWg(htmlData: item.offer),
          ),
      ],
    );
  }
}
