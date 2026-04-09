import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/flush_bar/error_flush_bar.dart';
import 'package:my_template/core/common/flush_bar/success_flush_bar.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/check_final_test/check_final_test_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/check_final_test/check_final_test_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/other/final_test_access_dialog_wg.dart';

class FinalCourseTestWg extends StatelessWidget {
  final int courseId;

  const FinalCourseTestWg({super.key, required this.courseId});

  void _onFinalTestCheck(BuildContext context) {
    logger.f(courseId);
    context.read<CheckFinalTestBloc>().add(
      CheckFinalTestEvent(
        params: CheckFinalTestAccessParams(courseId: courseId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckFinalTestBloc, CheckFinalTestState>(
      builder: (context, state) {
        return GestureDetector(
          behavior: .opaque,
          onTap: () => _onFinalTestCheck(context),
          child: Container(
            padding: const .symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: .circular(12),
              border: .all(color: AppColors.greyScale.grey200),
            ),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text('Umumiy test savollari', style: CustomTextStyles.h3),
                Icon(
                  IconlyLight.arrow_right_2,
                  color: AppColors.greyScale.grey400,
                ),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is CheckFinalTestLoaded && state.entity.ok == true) {
          /// text: Would u like to start the Final Test?
          /// show dialog with opens such as "start" or "nevermined"
          showDialog(
            context: context,
            builder: (context) => FinalTestAccessDialogWg(),
          );
        } else if (state is CheckFinalTestLoaded && state.entity.ok == false) {
          errorFlushBar(context, 'Darsliklarni barchasi tugatish shart!');
        }
      },
    );
  }
}
