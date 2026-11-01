import 'package:my_template/features/education_app/features/user_courses_edu/domain/usecase/course_final_test/get_course_final_test_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/network/dio_error_classifier.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/usecase/per_course/per_course_use_case.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/check_final_test_access/check_final_test_access_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/check_final_test_access/check_final_test_access_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_topics/course_lesson_topics_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_lesson_topics/course_lesson_topics_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/course_lesson_test/course_final_test/course_final_test_page.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/user/user_me_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/user/user_me_state.dart';

class FinalCourseTestWg extends StatelessWidget {
  final int courseId;

  const FinalCourseTestWg({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CheckFinalTestAccessBloc>(
      create: (_) => sl<CheckFinalTestAccessBloc>(),
      child: _FinalTestBar(courseId: courseId),
    );
  }
}

class _FinalTestBar extends StatefulWidget {
  final int courseId;

  const _FinalTestBar({required this.courseId});

  @override
  State<_FinalTestBar> createState() => _FinalTestBarState();
}

class _FinalTestBarState extends State<_FinalTestBar> {
  bool _openAfterCheck = false;
  bool _isOpening = false;

  bool? _lastOk;
  bool? _hasTests;

  @override
  void initState() {
    super.initState();
    _loadTestsAvailability();
    _checkAccess();
  }

  Future<void> _loadTestsAvailability() async {
    try {
      final tests = await sl<GetCourseFinalTestUseCase>()(
        params: CourseLessonTestParams(
          courseId: widget.courseId,
          blockId: 0,
          lessonId: 0,
        ),
      );
      if (mounted) setState(() => _hasTests = tests.isNotEmpty);
    } catch (_) {
      if (mounted) setState(() => _hasTests = true);
    }
  }

  void _checkAccess({bool open = false}) {
    final bloc = context.read<CheckFinalTestAccessBloc>();
    if (bloc.state is CheckFinalTestAccessLoading) {
      if (open) setState(() => _openAfterCheck = true);
      return;
    }
    _openAfterCheck = open;
    bloc.add(
      CheckFinalTestAccessEvent(
        params: CheckFinalTestAccessParams(courseId: widget.courseId),
      ),
    );
  }

  void _onTap() {
    if (_isOpening) return;
    _checkAccess(open: true);
  }

  void _onAccessResult(CheckFinalTestAccessState state) {
    if (state is CheckFinalTestAccessLoaded && state.entity.ok != _lastOk) {
      setState(() => _lastOk = state.entity.ok);
    }
    if (!_openAfterCheck) return;
    if (state is CheckFinalTestAccessLoaded) {
      _openAfterCheck = false;
      if (state.entity.ok) {
        _openFinalTest();
      } else {
        errorFlushBar(
          context,
          AppLocalizations.of(context)!.noAccessToFinalTestYet,
        );
      }
    } else if (state is CheckFinalTestAccessError) {
      _openAfterCheck = false;
      errorFlushBar(context, AppLocalizations.of(context)!.sectionLoadError);
    }
  }

  Future<void> _openFinalTest() async {
    final localization = AppLocalizations.of(context)!;
    setState(() => _isOpening = true);

    bool isFaceIdEnabled;
    try {
      final course = await sl<PerCourseUseCase>()(
        params: PerCourseParams(courseId: widget.courseId),
      );
      isFaceIdEnabled = course.isFaceIdEnabled;
    } catch (e) {
      if (mounted) {
        errorFlushBar(
          context,
          apiErrorMessage(e) ?? localization.sectionLoadError,
        );
      }
      return;
    } finally {
      if (mounted) setState(() => _isOpening = false);
    }
    if (!mounted) return;

    final userState = context.read<UserMeBloc>().state;
    final isVerified = userState is UserMeLoaded && userState.entity.isVerified;
    if (isFaceIdEnabled && !isVerified) {
      errorFlushBar(context, localization.verificationRequiredMessage);
      return;
    }

    await Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CourseFinalTestPage(
              courseId: widget.courseId,
              isFaceIdEnabled: isFaceIdEnabled,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOutCubic));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
    if (mounted) _checkAccess();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return MultiBlocListener(
      listeners: [
        BlocListener<CheckFinalTestAccessBloc, CheckFinalTestAccessState>(
          listener: (_, state) => _onAccessResult(state),
        ),
        BlocListener<CourseLessonTopicsBloc, CourseLessonTopicsState>(
          listenWhen: (previous, current) =>
              previous is CourseLessonTopicsLoading &&
              current is CourseLessonTopicsLoaded,
          listener: (_, _) => _checkAccess(),
        ),
      ],
      child: BlocBuilder<CheckFinalTestAccessBloc, CheckFinalTestAccessState>(
        builder: (context, state) {
          if (_hasTests == false) return const _NoFinalTestBar();
          final isPending =
              state is CheckFinalTestAccessInitial ||
              state is CheckFinalTestAccessLoading;
          final isChecking =
              _isOpening ||
              _hasTests == null ||
              (isPending && (_lastOk == null || _openAfterCheck));
          final isLocked = _lastOk == false;

          return _BarContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: isChecking ? null : _onTap,
                    style: isLocked
                        ? ElevatedButton.styleFrom(
                            backgroundColor: AppColors.greyScale.grey100,
                            foregroundColor: AppColors.greyScale.grey500,
                            elevation: 0,
                          )
                        : null,
                    icon: isChecking
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            isLocked ? IconlyBold.lock : IconlyLight.document,
                            size: 20,
                          ),
                    label: Text(
                      localization.finalTestButton,
                      style: AppTextStyles.source.medium(fontSize: 15),
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  child: isLocked
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            localization.finalTestLockedHint,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.source.regular(
                              fontSize: 12,
                              color: AppColors.greyScale.grey500,
                            ),
                          ),
                        )
                      : const SizedBox(width: double.infinity),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NoFinalTestBar extends StatelessWidget {
  const _NoFinalTestBar();

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return _BarContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: AppColors.greyScale.grey100,
                disabledForegroundColor: AppColors.greyScale.grey500,
                elevation: 0,
              ),
              icon: const Icon(IconlyLight.timeCircle, size: 20),
              label: Text(
                localization.finalTestButton,
                style: AppTextStyles.source.medium(fontSize: 15),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              localization.finalTestNotAddedHint,
              textAlign: TextAlign.center,
              style: AppTextStyles.source.regular(
                fontSize: 12,
                color: AppColors.greyScale.grey500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarContainer extends StatelessWidget {
  final Widget child;

  const _BarContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1),
            color: AppColors.greyScale.grey200,
            blurRadius: 20,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
          child: child,
        ),
      ),
    );
  }
}
