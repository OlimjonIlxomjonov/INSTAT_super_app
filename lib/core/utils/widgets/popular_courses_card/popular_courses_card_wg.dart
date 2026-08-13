import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/glass_badge/glass_badge_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';

// Card height
double _measureLineHeight(BuildContext context, TextStyle style) {
  final painter = TextPainter(
    text: TextSpan(text: 'Ag', style: style),
    textDirection: TextDirection.ltr,
    textScaler: MediaQuery.textScalerOf(context),
  )..layout();
  return painter.height;
}

double popularCoursesCardHeight(BuildContext context) {
  final orientation = MediaQuery.orientationOf(context);
  final isLandscape = orientation == Orientation.landscape;
  final cardWidth = !isLandscape ? 312 : appW(180);
  final imageHeight = cardWidth / 2;

  final categoryLineHeight = _measureLineHeight(
    context,
    AppTextStyles.source.medium(fontSize: 12),
  );
  final nameLineHeight = _measureLineHeight(
    context,
    AppTextStyles.source.medium(fontSize: 15),
  );
  final metaRowHeight = _measureLineHeight(
    context,
    AppTextStyles.source.regular(fontSize: 13),
  ).clamp(18.0, double.infinity);

  return imageHeight +
      appH(12) +
      categoryLineHeight +
      appH(4) +
      (nameLineHeight * 2) +
      appH(8) +
      metaRowHeight +
      16;
}

class PopularCoursesCardWg extends StatefulWidget {
  final VoidCallback onTap;
  final CourseEntity data;
  final String categoryName;

  const PopularCoursesCardWg({
    super.key,
    required this.onTap,
    required this.data,
    required this.categoryName,
  });

  @override
  State<PopularCoursesCardWg> createState() => _PopularCoursesCardWgState();
}

class _PopularCoursesCardWgState extends State<PopularCoursesCardWg> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return GestureDetector(
      behavior: .opaque,
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Stack(
            children: [
              //! Thumbnail
              AspectRatio(
                aspectRatio: 12 / 6, //? 12 / 6 default
                child: ClipRRect(
                  borderRadius: .circular(12),
                  child: Image.network(
                    widget.data.thumbnail,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              //! Star
              Positioned(
                left: 8,
                top: 8,
                child: GlassBadgeWg(
                  child: Row(
                    children: [
                      Icon(
                        IconlyBold.star,
                        color: AppColors.orange500,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.data.ratingsCount.toString(),
                        style: AppTextStyles.source.medium(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              //! Price
              Positioned(
                left: 8,
                bottom: 8,
                child: GlassBadgeWg(
                  child: Text(
                    widget.data.price == "0"
                        ? localization.freePrice
                        : "${formatPrice(widget.data.price)} UZS",
                    style: AppTextStyles.source.medium(
                      fontSize: 13,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          //! category
          AutoSizeText(
            widget.categoryName,
            style: AppTextStyles.source.medium(
              fontSize: 12,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          //! Title
          Text(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            widget.data.displayName(
              Localizations.localeOf(context).languageCode,
            ),
            style: AppTextStyles.source.medium(fontSize: 15),
          ),
          const Spacer(),
          //! course duration / lesson count
          Row(
            spacing: 5,
            children: [
              Icon(IconlyLight.time_circle, size: 18),
              AutoSizeText(
                formatDuration(widget.data.totalDuration),
                style: AppTextStyles.source.regular(fontSize: 13),
              ),
              const SizedBox(width: 12),
              Icon(IconlyLight.document, size: 18),
              AutoSizeText(
                "${widget.data.lessonsCount} ta dars",
                style: AppTextStyles.source.regular(fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
