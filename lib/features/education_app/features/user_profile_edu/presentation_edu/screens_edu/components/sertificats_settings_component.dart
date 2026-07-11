import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/common/ui_states/empty_state.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/home_edu_event.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/user_certificate/certificate_bloc.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/user_certificate/certificate_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../../core/utils/widgets/image_viewer/image_viewer_wg.dart';
import '../../../../statistics_edu/presentation_edu/widgets_edu/avatar_view_wg.dart';

class SertificatsSettingsComponent extends StatefulWidget {
  const SertificatsSettingsComponent({super.key});

  @override
  State<SertificatsSettingsComponent> createState() =>
      _SertificatsSettingsComponentState();
}

class _SertificatsSettingsComponentState
    extends State<SertificatsSettingsComponent> {
  @override
  void initState() {
    super.initState();
    context.read<CertificateBloc>().add(UserCertificateEvent());
  }

  void _openCertificateViewer(String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            ImageViewerPage(image: NetworkImage(imageUrl), heroTag: imageUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWg(myTitle: 'Sertifikatlar'),
      body: CustomRefreshIndicator(
        onRefresh: () async {
          context.read<CertificateBloc>().add(UserCertificateEvent());
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: AppPadding.hAndV20x20(),
              sliver: BlocBuilder<CertificateBloc, CertificateState>(
                builder: (context, state) {
                  if (state is CertificateLoaded) {
                    if (state.response.data.isEmpty) {
                      return SliverToBoxAdapter(
                        child: AppEmptyState(
                          title: 'Sizda hali sertifikatlar yoʻq',
                          subtitle:
                              'Ilk sertifikatingizni qoʻlga kiritish uchun yangi oʻquv yoʻnalishini boshlang.',
                        ),
                      );
                    }

                    return SliverList.builder(
                      itemCount: state.response.data.length,
                      itemBuilder: (context, index) {
                        final certificate = state.response.data[index];
                        final imageUrl =
                            'https://test.avacoder.uz${certificate.certificateImage}';

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.greyScale.grey200,
                              ),
                              color: AppColors.greyScale.grey50,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  certificate.course?.category?.name ?? '',
                                  style: AppTextStyles.source.medium(
                                    fontSize: 14,
                                    color: AppColors.greyScale.grey600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  certificate.course?.name ?? '',
                                  style: AppTextStyles.source.semiBold(
                                    fontSize: 17,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                GestureDetector(
                                  onTap: () => _openCertificateViewer(imageUrl),
                                  child: Hero(
                                    tag: imageUrl,
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return SliverList.builder(
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return Skeletonizer(
                        enabled: true,
                        child: Container(
                          padding: .all(12),
                          decoration: BoxDecoration(
                            borderRadius: .circular(16),
                            border: .all(color: AppColors.greyScale.grey200),
                            color: AppColors.greyScale.grey50,
                          ),
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              Text(
                                'Frontend Dasturlash',
                                style: AppTextStyles.source.medium(
                                  fontSize: 14,
                                  color: AppColors.greyScale.grey600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Statistika (Tarmoqlar va sohalar bo’yicha)',
                                style: AppTextStyles.source.semiBold(
                                  fontSize: 17,
                                ),
                              ),
                              SizedBox(height: 16),
                              Image.asset('assets/images/sertificat_temp.png'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
