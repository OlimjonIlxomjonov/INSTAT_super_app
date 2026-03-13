import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/utils/app_utils.dart';

class DraggableAppBarWg extends StatelessWidget implements PreferredSize {
  final VoidCallback onProfileTap;

  const DraggableAppBarWg({super.key, required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actionsPadding: .only(right: 5),
      automaticallyImplyLeading: false,
      title: GestureDetector(
        onTap: onProfileTap,
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: AppColors.greyScale.grey300,
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  'Hayrli kun! ✌️',
                  style: AppTextStyles.source.regular(fontSize: 14),
                ),
                Text(
                  'Afzal Pulatov',
                  style: AppTextStyles.source.medium(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(IconlyLight.notification)),
      ],
    );
  }

  @override
  Widget get child => throw UnimplementedError();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
