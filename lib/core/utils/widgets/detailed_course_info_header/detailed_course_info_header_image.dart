import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/widgets/family_bottom_sheet_navigation/family_bottom_sheet_navigation.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';

class DetailedCourseInfoHeaderImage extends StatelessWidget {
  final String imagePath;

  const DetailedCourseInfoHeaderImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: false,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: [.zoomBackground],
        background: RepaintBoundary(
          child: Image.network(imagePath, fit: .cover),
        ),
      ),
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: 0,
      toolbarHeight: 68,
      title: SheetDragAreaWg(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: .only(left: 10, top: 10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    FamilyNavigation.familyClose(context); // main
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(borderRadius: .circular(50)),
                  ),
                  icon: const Icon(IconlyLight.arrow_left_2, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: Container(
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: .only(
              topLeft: .circular(32),
              topRight: .circular(32),
            ),
          ),
        ),
      ),
    );
  }
}
