import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/widgets_edu/status_achievements_card_wg.dart';

class HomeAchievementsWg extends StatelessWidget {
  const HomeAchievementsWg({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: StatusAchievementsCardWg(descText: localization.yourLevel),
        ),
        Expanded(
          child: StatusAchievementsCardWg(descText: localization.yourMedals),
        ),
        Expanded(
          child: StatusAchievementsCardWg(descText: localization.pointsEarned),
        ),
      ],
    );
  }
}
