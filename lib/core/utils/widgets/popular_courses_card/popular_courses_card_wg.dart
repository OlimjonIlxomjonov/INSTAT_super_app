import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/domain/entity/courses/courses_entity.dart';

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
    return GestureDetector(
      behavior: .opaque,
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 12 / 6,
                child: ClipRRect(
                  borderRadius: .circular(12),
                  child: Image.network(
                    widget.data.thumbnail,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: .only(left: 8, top: 8),
                    decoration: BoxDecoration(
                      borderRadius: .circular(12),
                      color: AppColors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: AppColors.yellow),
                        Text(widget.data.ratingsCount.toString()),
                      ],
                    ),
                  ),
                  // Container(
                  //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  //   margin: .only(right: 20, top: 8),
                  //   decoration: BoxDecoration(
                  //     borderRadius: .circular(12),
                  //     color: AppColors.white,
                  //   ),
                  //   child: Icon(IconlyLight.heart),
                  // ),
                ],
              ),
            ],
          ),
          SizedBox(height: appH(12)),

          AutoSizeText(
            widget.categoryName,
            style: AppTextStyles.source.medium(
              fontSize: 12,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: appH(4)),
          AutoSizeText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            widget.data.name,
            style: AppTextStyles.source.medium(fontSize: 15),
          ),
          SizedBox(height: appH(8)),
          Row(
            spacing: 5,
            children: [
              Icon(IconlyLight.time_circle),
              AutoSizeText(
                formatDuration(widget.data.totalDuration),
                style: AppTextStyles.source.regular(fontSize: 13),
              ),
              SizedBox(width: appW(12)),
              Icon(IconlyLight.document),
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
