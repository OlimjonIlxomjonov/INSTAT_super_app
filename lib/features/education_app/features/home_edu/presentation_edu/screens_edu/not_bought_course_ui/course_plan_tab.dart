import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class CoursePlanTab extends StatelessWidget {
  const CoursePlanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: .only(bottom: appH(20)),
      children: [
        Container(
          margin: .symmetric(horizontal: appW(20)),
          decoration: BoxDecoration(
            border: .all(color: AppColors.greyScale.grey200),
            borderRadius: .circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(8, (index) {
              return Column(
                children: [
                  ExpansionTile(
                    shape: Border(),
                    collapsedShape: Border(),
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      "Tarmoqlar bo‘yicha statistika asoslariasoslari",
                    ),
                    initiallyExpanded: index == 0 ? true : false,
                    tilePadding: .only(
                      top: appH(5),
                      bottom: appH(5),
                      left: appW(10),
                    ),
                    children: [
                      Divider(color: AppColors.greyScale.grey200, height: 1),
                      ...List.generate(
                        3,
                        (i) => ListTile(
                          leading: Icon(Icons.video_collection),
                          title: Text(
                            'Statistik ko‘rsatkichlar va ularning turlari',
                          ),
                          tileColor: AppColors.greyScale.grey100,
                        ),
                      ),
                    ],
                  ),

                  // Divider between sections
                  if (index != 5)
                    Divider(color: AppColors.greyScale.grey200, height: 1),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
