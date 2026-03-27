import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_category_by_id/user_category_by_id_bloc.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/course_category_by_id/user_category_by_id_state.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/bloc/user_courses_event.dart';

class CourseCategoryBuilder extends StatefulWidget {
  final int categoryId;
  final Widget Function(BuildContext context, String categoryName) builder;
  final Widget Function(BuildContext context)? loadingBuilder;

  const CourseCategoryBuilder({
    super.key,
    required this.categoryId,
    required this.builder,
    this.loadingBuilder,
  });

  @override
  State<CourseCategoryBuilder> createState() => _CourseCategoryBuilderState();
}

class _CourseCategoryBuilderState extends State<CourseCategoryBuilder> {
  @override
  void initState() {
    super.initState();
    _fetchCategory(widget.categoryId);
  }

  @override
  void didUpdateWidget(CourseCategoryBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categoryId != widget.categoryId) {
      _fetchCategory(widget.categoryId);
    }
  }

  void _fetchCategory(int id) {
    context.read<UserCategoryByIdBloc>().add(
      UserCategoryByIdEvent(params: CourseCategoryByIdParams(id: id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCategoryByIdBloc, UserCategoryByIdState>(
      builder: (context, state) {
        final categories = state.categories;
        if (categories.containsKey(widget.categoryId)) {
          return widget.builder(context, categories[widget.categoryId]!.name);
        }

        if (widget.loadingBuilder != null) {
          return widget.loadingBuilder!(context);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
