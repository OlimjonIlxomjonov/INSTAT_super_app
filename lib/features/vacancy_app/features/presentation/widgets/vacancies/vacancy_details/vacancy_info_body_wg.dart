import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_bullet_section_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_provided_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_score_row_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_section_card_wg.dart';

class VacancyInfoBodyWg extends StatelessWidget {
  const VacancyInfoBodyWg({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //! Lavozim
        Text(
          'Senior Frontend Developer',
          style: AppTextStyles.source.semiBold(fontSize: 18),
        ),
        const SizedBox(height: 4),
        Text('Operator', style: AppTextStyles.source.medium(fontSize: 16)),
        const SizedBox(height: 16),

        //! Shartlar
        VacancyProvidedWg(),
        const SizedBox(height: 16),

        //! Talablar
        VacancyBulletSectionWg(
          title: localization.requirementsTitle,
          items: const [
            'JavaScript, TypeScript va React yoki Vue bo’yicha kuchli bilim',
            'Frontend yo’nalishida kamida 3 yil ish tajribasi',
            'REST API bilan ishlash tajribasi',
            'Git va jamoa bilan ishlash ko’nikmasi',
            'Responsive va zamonaviy UI yaratish tajribasi',
            'Mas’uliyatli, mustaqil va muammolarni tez hal qila olish',
          ],
        ),
        const SizedBox(height: 16),

        //! Vazifalar
        VacancyBulletSectionWg(
          title: localization.responsibilitiesTitle,
          items: const [
            'Web-platforma uchun yangi interfeyslarni ishlab chiqish',
            'Dizayn asosida sahifalarni sifatli va responsive holatda tayyorlash',
            'Backend API’lar bilan integratsiya qilish',
            'Kod sifatini saqlash va mavjud modullarni optimallashtirish',
            'Jamoa bilan birgalikda yangi funksiyalarni rejalashtirish va joriy etish',
            'Texnik xatolarni aniqlash va ularni bartaraf etish',
          ],
        ),
        const SizedBox(height: 16),

        //! Yo’nalishlar
        VacancySectionCardWg(
          title: localization.testDirectionsTitle,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    localization.directionNameLabel,
                    style: AppTextStyles.source.regular(
                      fontSize: 13,
                      color: AppColors.greyScale.grey600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    localization.passingScoreLabel,
                    style: AppTextStyles.source.regular(
                      fontSize: 13,
                      color: AppColors.greyScale.grey600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              VacancyScoreRowWg(
                name: 'Matematika',
                minLabel: 'Min - 70ball',
                maxLabel: '(max - 100ball)',
              ),
              const SizedBox(height: 8),
              VacancyScoreRowWg(
                name: 'Ona tili',
                minLabel: 'Min - 70ball',
                maxLabel: '(max - 100ball)',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
