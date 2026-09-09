import 'package:flutter/material.dart';

import '../../../../../../../core/utils/app_utils.dart';

class VacancyProvidedWg extends StatelessWidget {
  const VacancyProvidedWg({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _containerWg(
          FlutterRemix.money_dollar_circle_line,
          'Maosh summasi:',
          '25.000.000 so’m',
        ),
        _containerWg(FlutterRemix.map_pin_line, 'Ish joyi:', 'Toshkent shahri'),
        _containerWg(FlutterRemix.briefcase_line, 'Ish turi:', 'To’liq stavka'),
        _containerWg(FlutterRemix.briefcase_line, 'Ish staji:', '3-4 yil'),
      ],
    );
  }

  Widget _containerWg(IconData icon, String title, String trailing) {
    return Container(
      margin: const .only(bottom: 8),
      padding: const .all(12),
      decoration: BoxDecoration(
        borderRadius: .circular(12),
        color: AppColors.greyScale.grey50,
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(title, style: AppTextStyles.source.medium(fontSize: 14)),
          const Spacer(),
          Text(trailing, style: AppTextStyles.source.medium(fontSize: 16)),
        ],
      ),
    );
  }
}
