import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';

class SavedBooksComponent extends StatelessWidget {
  const SavedBooksComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBarWg(myTitle: localization.savedItems),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: Padding(
              padding: AppPadding.hAndV20x20(),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    localization.books,
                    style: AppTextStyles.source.semiBold(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
