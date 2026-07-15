import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';

class EduTicketsChatComponent extends StatelessWidget {
  const EduTicketsChatComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    TDeviceUtils.systemNavigationBar(AppColors.white);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: CustomScrollView(
        slivers: [
          SliverDefaultAppBarWg(myTitle: localization.chatTitle),
          SliverPadding(
            padding: AppPadding.hAndV20x20(),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  // messages
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          child: Row(
            children: [
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 140),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: AppColors.greyScale.grey50,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.attach_file, size: 25),
                        ),
                        hintText: localization.messageHint,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              IconButton(
                style: IconButton.styleFrom(
                  padding: .symmetric(vertical: 15, horizontal: 15),
                  shape: RoundedRectangleBorder(borderRadius: .circular(12)),
                  backgroundColor: AppColors.primaryColor,
                ),
                onPressed: () {},
                icon: Icon(IconlyBold.send, color: AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
