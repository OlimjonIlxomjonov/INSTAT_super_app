import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/general_widgets/dotted_container/dotted_cotnainer_wg.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/widgets_edu/edu_custom_text_area_wg.dart';

class EduCreateTicketsComponent extends StatelessWidget {
  const EduCreateTicketsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverDefaultAppBarWg(myTitle: localization.createTicketTitle),

          SliverPadding(
            padding: AppPadding.hAndV20x20(),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    localization.ticketNameLabel,
                    style: AppTextStyles.source.medium(fontSize: 14),
                  ),
                  SizedBox(height: appH(4)),
                  EduCustomTextAreaWg(
                    hintText: localization.ticketNameHint,
                    helperText: ' This is a hint text to help user.',
                  ),
                  SizedBox(height: appH(12)),
                  Text(
                    localization.subjectLabel,
                    style: AppTextStyles.source.medium(fontSize: 14),
                  ),
                  SizedBox(height: appH(4)),
                  EduCustomTextAreaWg(
                    hintText: localization.subjectHint,
                    helperText: ' This is a hint text to help user.',
                  ),
                  SizedBox(height: appH(12)),
                  Text(
                    localization.commentFieldLabel,
                    style: AppTextStyles.source.medium(fontSize: 14),
                  ),
                  SizedBox(height: appH(4)),
                  EduCustomTextAreaWg(
                    hintText: localization.commentHint,
                    helperText: ' This is a hint text to help user.',
                  ),

                  SizedBox(height: appH(12)),

                  /// DOTTED CONTAINER
                  DottedContainerWg(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavContainerWg(
        buttonText: localization.confirm,
        anotherButton: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.greyScale.grey50,
          ),
          onPressed: () {
            AppRoute.close();
          },
          child: Text(
            localization.cancel,
            style: AppTextStyles.source.medium(
              fontSize: 14,
              color: AppColors.greyScale.grey600,
            ),
          ),
        ),
        onTap: () {},
      ),
    );
  }
}
