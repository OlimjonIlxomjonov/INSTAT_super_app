import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/services/banners/banner_source_cubit.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/assets/app_images.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/main_app/home/domain/entity/banner/banner_entity.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/banner/banner_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/banner/banner_event.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/banner/banner_state.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

const double _bannerAspectRatio = 342 / 184;

class PromoBannersCarouselWg extends StatelessWidget {
  final List<String> localAssets;

  const PromoBannersCarouselWg({
    super.key,
    this.localAssets = AppImages.allBanners,
  });

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
    //! Lokal yoki reklama
    final useRemote = context.watch<BannerSourceCubit>().state;
    if (!useRemote) {
      return _LocalBannersCarousel(assets: localAssets);
    }

    return BlocBuilder<BannerBloc, BannerState>(
      builder: (context, state) {
        if (state is BannerInitial) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              context.read<BannerBloc>().add(const FetchBannersEvent());
            }
          });
        }

        if (state is BannerLoading || state is BannerInitial) {
          return Padding(
            padding: AppPadding.horizontal20x(),
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
          return _BannerErrorCard(
            message: state.message,
            onRetry: () =>
                context.read<BannerBloc>().add(const FetchBannersEvent()),
          );
        }

        if (state is! BannerLoaded || state.banners.isEmpty) {
          return const _NoBannersYetCard();
        }

        final banners = state.banners;

        return CarouselSlider.builder(
          itemCount: banners.length,
          itemBuilder: (context, index, realIndex) {
            final banner = banners[index];
            return _BannerSlide(
              child: GestureDetector(
                onTap: () => _openBanner(banner),
                child: Image.network(
                  banner.image,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                      ColoredBox(color: AppColors.greyScale.grey200),
                ),
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
        );
      },
    );
  }
}

class _BannerSlide extends StatelessWidget {
  final Widget child;

  const _BannerSlide({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(horizontal: 20),
      child: ClipRRect(borderRadius: BorderRadius.circular(16), child: child),
    );
  }
}

class _LocalBannersCarousel extends StatelessWidget {
  final List<String> assets;

  const _LocalBannersCarousel({required this.assets});

  @override
  Widget build(BuildContext context) {
    if (assets.isEmpty) return const SizedBox.shrink();

    if (assets.length == 1) {
      return AspectRatio(
        aspectRatio: _bannerAspectRatio,
        child: _BannerSlide(
          child: Image.asset(assets.first, fit: BoxFit.cover),
        ),
      );
    }

    return CarouselSlider.builder(
      itemCount: assets.length,
      itemBuilder: (context, index, realIndex) => _BannerSlide(
        child: Image.asset(assets[index], fit: BoxFit.cover, width: .infinity),
      ),
      options: CarouselOptions(
        aspectRatio: _bannerAspectRatio,
        viewportFraction: 1.0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
      ),
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

class _BannerErrorCard extends StatelessWidget {
  final VoidCallback onRetry;
  final String? message;

  const _BannerErrorCard({required this.onRetry, this.message});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Padding(
      padding: AppPadding.horizontal20x(),
      child: AspectRatio(
        aspectRatio: _bannerAspectRatio,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.redBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.redFailedTaskCard.withValues(alpha: 0.4),
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 32,
                    color: AppColors.redFailedTaskCard,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    (message != null && message!.trim().isNotEmpty)
                        ? message!
                        : localization.bannersLoadError,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.source.medium(
                      fontSize: 14,
                      color: AppColors.greyScale.grey800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextButton.icon(
                    onPressed: onRetry,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.redFailedTaskCard,
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: Text(
                      localization.retry,
                      style: AppTextStyles.source.medium(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
