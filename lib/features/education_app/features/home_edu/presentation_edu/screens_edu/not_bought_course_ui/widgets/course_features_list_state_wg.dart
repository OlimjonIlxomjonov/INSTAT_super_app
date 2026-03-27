import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/education_app/features/home_edu/presentation_edu/screens_edu/not_bought_course_ui/widgets/study_item_wg.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/about_course_features/about_cours_features_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/about_course_features/about_course_features_state.dart';

class CourseFeaturesList extends StatefulWidget {
  final int courseId;

  const CourseFeaturesList({super.key, required this.courseId});

  @override
  State<CourseFeaturesList> createState() => CourseFeaturesListState();
}

class CourseFeaturesListState extends State<CourseFeaturesList> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AboutCourseFeaturesBloc, AboutCourseFeaturesState>(
      buildWhen: (previous, current) {
        // only rebuild if the data for THIS course changed
        return previous.cachedResponses[widget.courseId] !=
            current.cachedResponses[widget.courseId];
      },
      builder: (context, state) {
        final cached = state.cachedResponses[widget.courseId];
        if (cached != null) {
          final data = cached.data;
          if (data.isEmpty) return const SizedBox.shrink();

          final count = _isExpanded
              ? data.length
              : (data.length > 5 ? 5 : data.length);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...List.generate(count, (index) => StudyItemWg(data[index].text)),
              if (data.length > 5)
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () => setState(() => _isExpanded = !_isExpanded),
                    child: Text(
                      _isExpanded
                          ? "Kamroq ko'rish"
                          : "Barchasini ko'rish (${data.length})",
                      style: AppTextStyles.source.medium(
                        fontSize: 14,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
