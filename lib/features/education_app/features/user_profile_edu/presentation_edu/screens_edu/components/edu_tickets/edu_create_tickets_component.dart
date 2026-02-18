import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/devices/device_unitlity.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';
import 'package:my_template/core/utils/widgets/bottom_sheet_sliver_default_app_bar/sliver_default_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/custom_bottom_nav_container/custom_bottom_nav_container_wg.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/widgets_edu/edu_custom_text_area_wg.dart';

class EduCreateTicketsComponent extends StatelessWidget {
  const EduCreateTicketsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverDefaultAppBarWg(myTitle: 'Tikket yaratish'),

          SliverPadding(
            padding: AppPadding.hAndV20x20(),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'Ticket nomi*',
                    style: AppTextStyles.source.medium(fontSize: 14),
                  ),
                  SizedBox(height: appH(4)),
                  EduCustomTextAreaWg(
                    hintText: 'Tikket nomi...',
                    helperText: ' This is a hint text to help user.',
                  ),
                  SizedBox(height: appH(12)),
                  Text(
                    'Mavzu*',
                    style: AppTextStyles.source.medium(fontSize: 14),
                  ),
                  SizedBox(height: appH(4)),
                  EduCustomTextAreaWg(
                    hintText: 'Mavzu yozing...',
                    helperText: ' This is a hint text to help user.',
                  ),
                  SizedBox(height: appH(12)),
                  Text(
                    'Izoh*',
                    style: AppTextStyles.source.medium(fontSize: 14),
                  ),
                  SizedBox(height: appH(4)),
                  EduCustomTextAreaWg(
                    hintText: 'Izoh yozing...',
                    helperText: ' This is a hint text to help user.',
                  ),

                  SizedBox(height: appH(12)),
                  DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      dashPattern: [10, 5],
                      strokeWidth: 1.5,
                      color: AppColors.greyScale.grey400,
                      radius: .circular(12),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: .symmetric(vertical: 30),
                      decoration: BoxDecoration(
                        color: AppColors.greyScale.grey50,
                        borderRadius: .circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(IconlyLight.upload),
                          SizedBox(height: 20),
                          Text(
                            'Choose a file or drag & drop it here.',
                            style: AppTextStyles.source.medium(fontSize: 14),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'JPEG, PNG, PDF, and MP4 formats, up to 50 MB.',
                            style: AppTextStyles.source.regular(
                              fontSize: 12,
                              color: AppColors.greyScale.grey600,
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.white,
                            ),
                            onPressed: () {},
                            child: Text(
                              'Browse File',
                              style: AppTextStyles.source.medium(
                                fontSize: 13,
                                color: AppColors.greyScale.grey600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavContainerWg(
        buttonText: 'Tasdiqlash',
        anotherButton: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.greyScale.grey50,
          ),
          onPressed: () {
            AppRoute.close();
          },
          child: Text(
            'Bekor qilish',
            style: AppTextStyles.source.medium(
              fontSize: 14,
              color: AppColors.greyScale.grey600,
            ),
          ),
        ),
        onTap: () {},
      ),
    );
  }
}
