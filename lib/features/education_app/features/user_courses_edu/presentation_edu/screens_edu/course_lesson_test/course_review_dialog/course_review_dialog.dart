import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/bloc/add_course_comment/add_course_comment_cubit.dart';

const int _maxReviewLength = 200;
const int _maxStars = 5;

/// Kurs yakunlangach izoh va baho so'raydi.
/// `true` — izoh yuborildi, `false`/`null` — o'tkazib yuborildi.
Future<bool?> showCourseReviewDialog(
  BuildContext context, {
  required int courseId,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => BlocProvider(
      create: (_) => sl<AddCourseCommentCubit>(),
      child: _CourseReviewDialog(courseId: courseId),
    ),
  );
}

class _CourseReviewDialog extends StatefulWidget {
  final int courseId;

  const _CourseReviewDialog({required this.courseId});

  @override
  State<_CourseReviewDialog> createState() => _CourseReviewDialogState();
}

class _CourseReviewDialogState extends State<_CourseReviewDialog> {
  final _controller = TextEditingController();
  int _stars = _maxStars;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final l = AppLocalizations.of(context)!;

    context.read<AddCourseCommentCubit>().submit(
      AddCourseCommentParams(
        courseId: widget.courseId,
        stars: _stars,
        text: _controller.text.trim(),
      ),
      onSuccess: () {
        if (!mounted) return;
        successFlushBar(context, l.reviewSentMessage);
        Navigator.of(context).pop(true);
      },
      onError: (message) {
        if (!mounted) return;
        errorFlushBar(context, message ?? l.sectionLoadError);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isSending = context.watch<AddCourseCommentCubit>().state;
    final canSubmit = _controller.text.trim().isNotEmpty && !isSending;

    return AlertDialog(
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      contentPadding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(AppVectors.finishFullCourseTestDialogImg),
            const SizedBox(height: 16),
            Text(
              l.courseFinishedTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.source.medium(fontSize: 22),
            ),
            const SizedBox(height: 12),
            Text(
              l.courseReviewSubtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.source.regular(
                fontSize: 14,
                color: AppColors.greyScale.grey600,
              ),
            ),
            const SizedBox(height: 20),

            //! Baho
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_maxStars, (index) {
                final value = index + 1;
                return IconButton(
                  onPressed: isSending
                      ? null
                      : () => setState(() => _stars = value),
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    IconlyBold.star,
                    size: 32,
                    color: value <= _stars
                        ? AppColors.yellow500
                        : AppColors.greyScale.grey300,
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),

            //! Izoh
            TextField(
              controller: _controller,
              enabled: !isSending,
              minLines: 3,
              maxLines: 5,
              maxLength: _maxReviewLength,
              style: AppTextStyles.source.regular(fontSize: 14),
              decoration: InputDecoration(
                hintText: l.courseReviewHint,
                hintStyle: AppTextStyles.source.regular(
                  fontSize: 14,
                  color: AppColors.greyScale.grey500,
                ),
                counterText:
                    '${_controller.text.characters.length}'
                    '/$_maxReviewLength',
                counterStyle: AppTextStyles.source.regular(
                  fontSize: 12,
                  color: AppColors.greyScale.grey500,
                ),
                contentPadding: const EdgeInsets.all(14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.greyScale.grey200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.greyScale.grey200),
                ),
              ),
            ),
            const SizedBox(height: 8),

            //! Tugmalar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canSubmit ? _submit : null,
                child: isSending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l.confirm),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.greyScale.grey100,
                  foregroundColor: AppColors.greyScale.grey800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: isSending
                    ? null
                    : () => Navigator.of(context).pop(false),
                child: Text(
                  l.skipButton,
                  style: AppTextStyles.source.medium(fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
