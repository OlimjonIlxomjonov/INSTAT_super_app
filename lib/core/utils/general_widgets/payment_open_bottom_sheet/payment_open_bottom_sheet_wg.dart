import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/routes/route_generator.dart';
import 'package:my_template/core/utils/constants/assets/app_images.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/buy_course/buy_course_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/buy_course/buy_course_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';

const String _paymentMethodClick = 'click';
const String _paymentMethodPayme = 'payme';

class PaymentOpenBottomSheetWg extends StatefulWidget {
  final int courseId;

  const PaymentOpenBottomSheetWg({super.key, required this.courseId});

  @override
  State<PaymentOpenBottomSheetWg> createState() =>
      _PaymentOpenBottomSheetWgState();
}

class _PaymentOpenBottomSheetWgState extends State<PaymentOpenBottomSheetWg> {
  String? _selectedPaymentMethod;

  void _buyCourse(BuildContext context, String paymentMethod) {
    setState(() => _selectedPaymentMethod = paymentMethod);
    context.read<BuyCourseBloc>().add(
      BuyCourseEvent(
        params: BuyCourseParams(
          courseId: widget.courseId,
          paymentMethod: paymentMethod,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BuyCourseBloc, BuyCourseState>(
      listener: (context, state) {
        if (state is BuyCourseLoaded) {
          AppRoute.close();
          // successFlushBar(context, 'Kurs sotip olindi!');
        } else if (state is BuyCourseError) {
          setState(() => _selectedPaymentMethod = null);
          errorFlushBar(context, state.message);
        }
      },
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildPaymentMethod(
                    AppImages.clickPayment,
                    _paymentMethodClick,
                    context,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPaymentMethod(
                    AppImages.paymePayment,
                    _paymentMethodPayme,
                    context,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(
    String imagePath,
    String paymentMethod,
    BuildContext context,
  ) => BlocBuilder<BuyCourseBloc, BuyCourseState>(
    builder: (context, state) {
      final isLoading =
          state is BuyCourseLoading && _selectedPaymentMethod == paymentMethod;
      return GestureDetector(
        onTap: isLoading ? null : () => _buyCourse(context, paymentMethod),
        child: Container(
          padding: const EdgeInsets.all(15),
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.greyScale.grey50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.greyScale.grey200),
          ),
          child: isLoading
              ? const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : Image.asset(imagePath, fit: BoxFit.cover),
        ),
      );
    },
  );
}
