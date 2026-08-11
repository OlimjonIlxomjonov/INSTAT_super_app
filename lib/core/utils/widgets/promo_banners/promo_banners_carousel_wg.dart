import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/main_app/home/domain/entity/banner/banner_entity.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/banner/banner_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/banner/banner_state.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

const double _bannerAspectRatio = 342 / 184;

class PromoBannersCarouselWg extends StatelessWidget {
  const PromoBannersCarouselWg({super.key});

  Future<void> _openBanner(BannerEntity banner) async {
    if (banner.link.isEmpty) return;
    try {
      await launchUrl(
        Uri.parse(banner.link),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      logger.e('Failed to open banner link: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerBloc, BannerState>(
      builder: (context, state) {
        if (state is BannerLoading || state is BannerInitial) {
          return Padding(
            padding: const .symmetric(horizontal: 20),
            child: Skeletonizer(
              enabled: true,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: _bannerAspectRatio,
                  child: ColoredBox(color: AppColors.greyScale.grey200),
                ),
              ),
            ),
          );
        }

        if (state is BannerError) {
          return const SizedBox.shrink();
        }

        if (state is! BannerLoaded || state.banners.isEmpty) {
          return const _NoBannersYetCard();
        }

        final banners = state.banners;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CarouselSlider.builder(
                itemCount: banners.length,
                itemBuilder: (context, index, realIndex) {
                  final banner = banners[index];
                  return GestureDetector(
                    onTap: () => _openBanner(banner),
                    child: Image.network(
                      banner.image,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                          ColoredBox(color: AppColors.greyScale.grey200),
                    ),
                  );
                },
                options: CarouselOptions(
                  aspectRatio: _bannerAspectRatio,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: banners.length > 1,
                  autoPlay: banners.length > 1,
                  autoPlayInterval: const Duration(seconds: 5),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NoBannersYetCard extends StatelessWidget {
  const _NoBannersYetCard();

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Padding(
      padding: AppPadding.horizontal20x(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: _bannerAspectRatio,
          child: ColoredBox(
            color: AppColors.greyScale.grey100,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.campaign_rounded,
                      size: 32,
                      color: AppColors.greyScale.grey400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      localization.noBannersYetTitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.source.medium(
                        fontSize: 14,
                        color: AppColors.greyScale.grey700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      localization.noBannersYetSubtitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.source.regular(
                        fontSize: 12,
                        color: AppColors.greyScale.grey500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
