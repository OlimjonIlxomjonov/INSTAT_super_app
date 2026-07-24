import 'package:flutter/material.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/assets/app_animations.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sub_bottom_sheet_opener.dart';
import 'package:my_template/features/main_app/home/presentation/screens/drawer/components/log_out_options_component.dart';

/// Full-app blocking screen shown to users whose account is not a resident
/// (i.e. signed in through Google/Apple/Facebook rather than OneID). Placed
/// at the top of HomePage so it replaces the entire app shell — no drawer,
/// no mini-app buttons reachable underneath it.
class ForeignUserComingSoonPage extends StatelessWidget {
  const ForeignUserComingSoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: AppEmptyState(
            animationAsset: AppAnimations.workFuv,
            title: localization.foreignUserComingSoonTitle,
            subtitle: localization.foreignUserComingSoonMessage,
            buttonLabel: localization.leaveAccount,
            onAction: () {
              subBottomSheetOpener(
                context,
                child: const LogOutOptionsComponent(),
                isExpanded: false,
              );
            },
          ),
        ),
      ),
    );
  }
}
