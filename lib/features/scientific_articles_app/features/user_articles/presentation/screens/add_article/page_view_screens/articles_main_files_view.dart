import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/dotted_container/dotted_cotnainer_wg.dart';
import 'package:my_template/core/utils/general_widgets/selected_file_container/selected_file_container_wg.dart';

class ArticlesMainFilesView extends StatelessWidget {
  const ArticlesMainFilesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.horizontal20x(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            /// MAIN FILE
            DottedContainerWg(),
            const SizedBox(height: 15),
            SelectedFileContainerWg(),

            const SizedBox(height: 24),

            /// ANTIPLAGIAT FILE
            Text('Antipgaiat fayli', style: CustomTextStyles.h3),
            const SizedBox(height: 20),
            DottedContainerWg(),

            const SizedBox(height: 24),

            /// JADVAL
            Text('Antipgaiat fayli', style: CustomTextStyles.h3),
            const SizedBox(height: 20),
            DottedContainerWg(),

            /// FREE BOTTOM SPACE
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
