import 'package:flutter/material.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/api_urls/api_urls.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/general_widgets/custom_rating_star/custom_rating_star_wg.dart';
import 'package:my_template/core/utils/general_widgets/online_book_wg/short_book_details_wg.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/widgets_edu/edu_custom_text_area_wg.dart';
import 'package:my_template/features/online_library_app/features/home_lib/domain/entity/book/book_entity.dart';

class LeaveCommentSection extends StatelessWidget {
  final BookEntity data;

  const LeaveCommentSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final thumbnail = data.bookThumbnails.isNotEmpty
        ? '${ApiUrls.baseUrl.replaceAll('api/', 'media/')}${data.bookThumbnails.first.file}'
        : '';
    return SafeArea(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          ShortBookDetailsWg(
            imagePath: thumbnail,
            bookName: data.name,
            bookAuthor: data.author.name,
            bookType: data.category.name,
          ),
          SizedBox(height: 16),
          Text('Baholash', style: AppTextStyles.source.medium(fontSize: 13)),
          SizedBox(height: 4),
          CustomRatingStarWg(starRating: 4, starSize: 30),
          SizedBox(height: 16),
          EduCustomTextAreaWg(hintText: 'Mavzuni yozing...'),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.transparent,
                    foregroundColor: AppColors.greyScale.grey600,
                    shape: RoundedRectangleBorder(
                      borderRadius: .circular(12),
                      side: BorderSide(color: AppColors.greyScale.grey200),
                    ),
                  ),
                  onPressed: () {
                    AppRoute.close();
                  },
                  child: Text('Bekor qilish'),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Tasdiqlash'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
