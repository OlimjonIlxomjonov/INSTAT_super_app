import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_entity.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/widgets/detailed_online_book_header_items_wg.dart';
import 'package:my_template/features/online_library_app/features/home_lib/presentation/screens/lib_components/widgets/vertical_divider_wg.dart';

class DetailedOnlineBookHeaderWg extends StatelessWidget {
  final BookEntity data;

  const DetailedOnlineBookHeaderWg({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    logger.f("${ApiUrls.bookThumbnail}${data.bookThumbnails.first.file}");
    return Container(
      padding: .symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: .circular(20),
        gradient: LinearGradient(
          colors: [AppColors.white, AppColors.greyScale.grey100],
          stops: [0.3, 0.6],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          if (data.bookThumbnails.isNotEmpty)
            CarouselSlider(
              options: CarouselOptions(
                height: 300,
                viewportFraction: 0.8,
                enableInfiniteScroll: data.bookThumbnails.length > 1,
                enlargeCenterPage: true,
              ),
              items: data.bookThumbnails.map((thumbnail) {
                return ClipRRect(
                  borderRadius: .circular(12),
                  child: Image.network(
                    "${ApiUrls.bookThumbnail}${thumbnail.file}",
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, size: 50),
                  ),
                );
              }).toList(),
            )
          else
            ClipRRect(
              borderRadius: .circular(12),
              child: Image.asset(
                'assets/images/temp_book.jpg',
                fit: BoxFit.contain,
                height: 300,
              ),
            ),
          SizedBox(height: appH(16)),
          Container(
            margin: .only(bottom: 8),
            padding: .symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: .circular(6),
              color: AppColors.greyScale.grey200,
            ),
            child: Text(
              data.category.name,
              style: AppTextStyles.source.medium(fontSize: 13),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              data.name,
              textAlign: TextAlign.center,
              style: AppTextStyles.source.medium(fontSize: 22),
            ),
          ),
          SizedBox(height: appH(8)),
          Text(
            data.author.name,
            style: AppTextStyles.source.regular(fontSize: 13),
          ),
          SizedBox(height: appH(20)),

          Row(
            mainAxisAlignment: .spaceEvenly,
            children: [
              DetailedOnlineBookHeaderItemsWg(
                value: '4.7',
                label: 'Rating',
                icon: Icons.star,
              ),
              const VerticalDividerWg(),
              DetailedOnlineBookHeaderItemsWg(
                value: data.pagesCount.toString(),
                label: 'Sahifa',
              ),
              const VerticalDividerWg(),
              DetailedOnlineBookHeaderItemsWg(
                value: data.userBookCount.toString(),
                label: 'Sotuv',
              ),
              const VerticalDividerWg(),
              DetailedOnlineBookHeaderItemsWg(value: 'N/A', label: "O'lcham"),
              // Can be derived if needed
            ],
          ),
        ],
      ),
    );
  }
}
