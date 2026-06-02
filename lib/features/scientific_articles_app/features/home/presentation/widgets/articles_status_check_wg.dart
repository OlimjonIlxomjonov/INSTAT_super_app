import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/status_container_wg.dart';

class ArticlesStatusCheckWg extends StatelessWidget {
  final ArticleStatus status;

  const ArticlesStatusCheckWg({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case ArticleStatus.draft:
        return StatusContainerWg(
          icon: Icons.drafts,
          statusTitle: ' Qoralama',
          iconColor: AppColors.greyScale.grey600,
          backgroundColor: AppColors.greyNewCard,
        );
      case ArticleStatus.confirmed:
        return StatusContainerWg(
          icon: Icons.check_circle,
          statusTitle: ' Tasdiqlangan',
          iconColor: AppColors.greenDoneTaskCard,
          backgroundColor: AppColors.greenBackground,
        );
      case ArticleStatus.pending:
        return StatusContainerWg(
          icon: Icons.warning_amber,
          statusTitle: ' Tekshirilmoqda',
          iconColor: AppColors.orange500,
          backgroundColor: AppColors.orange50,
        );
      case ArticleStatus.rejected:
        return StatusContainerWg(
          icon: IconlyLight.danger,
          statusTitle: ' Rad etilgan',
          iconColor: AppColors.redFailedTaskCard,
          backgroundColor: AppColors.redBackground,
        );
    }
  }
}
