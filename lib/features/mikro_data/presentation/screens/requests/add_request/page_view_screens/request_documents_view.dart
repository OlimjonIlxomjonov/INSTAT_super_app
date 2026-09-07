import 'package:flutter/material.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/widgets/request_file_section_wg.dart';

class RequestDocumentsView extends StatelessWidget {
  const RequestDocumentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Padding(
      padding: AppPadding.horizontal20x(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RequestFileSectionWg(
              title: localization.requestApprovalFileTitle,
              subtitle: localization.requestApprovalFileSubtitle,
            ),
            RequestFileSectionWg(
              title: localization.requestCompanyFileTitle,
              subtitle: localization.requestCompanyFileSubtitle,
              isCompanyFile: true,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
