import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/flush_bar/error_flush_bar.dart';
import 'package:my_template/core/common/flush_bar/success_flush_bar.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/check_final_test_access/check_final_test_access_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/check_final_test_access/check_final_test_access_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';

class FinalCourseTestWg extends StatelessWidget {
  final int courseId;

  const FinalCourseTestWg({super.key, required this.courseId});

  void _checkFinalTestAccess(BuildContext context) {
    logger.f(courseId);
    context.read<CheckFinalTestAccessBloc>().add(
      CheckFinalTestAccessEvent(
        params: CheckFinalTestAccessParams(courseId: courseId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckFinalTestAccessBloc, CheckFinalTestAccessState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => _checkFinalTestAccess(context),
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
        if (state is CheckFinalTestAccessLoaded && state.entity.ok == true) {
          successFlushBar(context, 'Success');
        } else if (state is CheckFinalTestAccessLoaded &&
            state.entity.ok == false) {
          errorFlushBar(context, 'Yakuniy test ga hali ruxsat yo\'q!');
        }
      },
    );
  }
}
