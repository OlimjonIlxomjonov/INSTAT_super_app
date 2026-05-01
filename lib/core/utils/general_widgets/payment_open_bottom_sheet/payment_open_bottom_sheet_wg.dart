import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/flush_bar/success_flush_bar.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/assets/app_images.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/buy_course/buy_course_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/buy_course/buy_course_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';

class PaymentOpenBottomSheetWg extends StatelessWidget {
  final int courseId;

  const PaymentOpenBottomSheetWg({super.key, required this.courseId});

  void _buyCourse(BuildContext context) {
    context.read<BuyCourseBloc>().add(
      BuyCourseEvent(params: BuyCourseParams(courseId: courseId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BuyCourseBloc, BuyCourseState>(
      listener: (context, state) {
        if (state is BuyCourseLoaded) {
          AppRoute.close();
          successFlushBar(context, 'Kurs sotip olindi!');
        }
      },
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildPaymentMethod(AppImages.clickPayment, context),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPaymentMethod(AppImages.paymePayment, context),
                ),
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(String imagePath, BuildContext context) =>
      BlocBuilder<BuyCourseBloc, BuyCourseState>(
        builder: (context, state) {
          final isLoading = state is BuyCourseLoading;
          return GestureDetector(
            onTap: isLoading ? null : () => _buyCourse(context),
            child: Container(
              // height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                color: AppColors.greyScale.grey50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.greyScale.grey200),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryColor,
                        ),
                      )
                    : Expanded(
                        child: Image.asset(
                          imagePath,
                          key: ValueKey(imagePath),
                          fit: BoxFit.fill,
                        ),
                      ),
              ),
            ),
          );
        },
      );
}
