import 'package:flutter/material.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';

class UserAchievementsTab extends StatelessWidget {
  const UserAchievementsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return ListView(
      padding: AppPadding.horizontal20x(),
      children: [
        AppEmptyState(
          title: localization.noMedalsTitle,
          subtitle: localization.noMedalsSubtitle,
          illustrationSize: 120,
        ),
      ],
    );
  }
}
