import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/common/ui_states/section_error_wg.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/files/remote_file_opener.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/image_viewer/image_viewer_wg.dart';
import 'package:my_template/features/education_app/features/statistics_edu/domain/entity/student_rating/student_rating_entity.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/bloc/student_rating/student_rating_cubit.dart';
import 'package:my_template/features/education_app/features/statistics_edu/presentation_edu/widgets_edu/body_container.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserSertificatsTab extends StatelessWidget {
  const UserSertificatsTab({super.key});

  static const _skeletonItems = [
    StudentRatingCertificateEntity(id: 1, courseName: 'Course name'),
    StudentRatingCertificateEntity(id: 2, courseName: 'Course name'),
  ];

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return BlocBuilder<StudentRatingCubit, StudentRatingState>(
      builder: (context, state) {
        final padding = AppPadding.horizontal20x().copyWith(bottom: appH(20));
        final error = state.error;
        if (error != null) {
          return ListView(
            padding: padding,
            children: [
              SectionErrorWg(
                title: error.isEmpty ? null : error,
                onRetry: context.read<StudentRatingCubit>().retry,
              ),
            ],
          );
        }

        final items = state.data?.certificates ?? _skeletonItems;
        if (items.isEmpty) {
          return ListView(
            padding: padding,
            children: [
              AppEmptyState(
                title: localization.studentNoCertificatesTitle,
                subtitle: localization.studentNoCertificatesSubtitle,
                illustrationSize: 120,
              ),
            ],
          );
        }

        return Skeletonizer(
          enabled: state.isLoading,
          child: ListView(
            padding: padding,
            children: [
              BodyContainer(
                title: localization.certificates,
                body: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) =>
                      _CertificateCard(item: items[index]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CertificateCard extends StatelessWidget {
  final StudentRatingCertificateEntity item;

  const _CertificateCard({required this.item});

  void _open(BuildContext context, String url) {
    showImageViewer(
      context,
      image: NetworkImage(url),
      heroTag: 'student-certificate-${item.id}',
      onOpenExternal: () =>
          openRemoteFile(context, url: url, fileName: 'certificate_${item.id}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final url = item.imageUrl;

    return GestureDetector(
      onTap: url == null ? null : () => _open(context, url),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: url == null
                  ? ColoredBox(
                      color: AppColors.greyScale.grey100,
                      child: const SizedBox.expand(),
                    )
                  : Hero(
                      tag: 'student-certificate-${item.id}',
                      child: Image.network(
                        url,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => ColoredBox(
                          color: AppColors.greyScale.grey100,
                          child: Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              color: AppColors.greyScale.grey400,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
