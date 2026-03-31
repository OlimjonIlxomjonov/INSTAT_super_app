import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/user/user_me_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/user/user_me_state.dart';
import 'package:my_template/features/main_app/home/presentation/screens/drawer/components/user_avatar_component.dart';

class DraggableAppBarWg extends StatelessWidget implements PreferredSize {
  final VoidCallback onProfileTap;

  const DraggableAppBarWg({super.key, required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    final userName = context.select<UserMeBloc, String>((bloc) {
      final state = bloc.state;
      return state is UserMeLoaded
          ? '${state.entity.firstName.capitalize()} ${state.entity.lastName.capitalize()}'
          : 'Loading...';
    });

    final localization = AppLocalizations.of(context)!;
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
                  '${localization.goodDay} ✌️',
                  style: AppTextStyles.source.regular(fontSize: 14),
                ),
                Text(
                  userName,
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
