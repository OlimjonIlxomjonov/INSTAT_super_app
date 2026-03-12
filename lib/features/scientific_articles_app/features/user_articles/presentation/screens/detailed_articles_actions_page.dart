import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/features/scientific_articles_app/dummy_data_source/last_actions_source.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/last_actions/sliver_last_actions_wg.dart';

class DetailedArticlesActionsPage extends StatelessWidget {
  const DetailedArticlesActionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text('2-tsikl', style: CustomTextStyles.h2),
        SliverLastActionsWg(items: lastActions),
      ],
    );
  }
}
