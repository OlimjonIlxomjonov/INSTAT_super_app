import 'package:flutter/material.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/widgets_edu/status_achievements_card_wg.dart';

class HomeAchievementsWg extends StatelessWidget {
  const HomeAchievementsWg({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: 8,
      children: [
        Expanded(child: StatusAchievementsCardWg(descText: 'Darajangiz')),
        Expanded(child: StatusAchievementsCardWg(descText: 'Medalingiz')),
        Expanded(
          child: StatusAchievementsCardWg(descText: "To’plagan ballingiz"),
        ),
      ],
    );
  }
}
