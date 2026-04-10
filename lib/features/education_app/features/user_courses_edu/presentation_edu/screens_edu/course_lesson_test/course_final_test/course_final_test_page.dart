import 'package:flutter/material.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/screens_edu/course_lesson_test/regular_test/widgets/regular_test_header_wg.dart';

class CourseFinalTestPage extends StatelessWidget {
  const CourseFinalTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [RegularTestHeaderWg(progress: 0.4), ]),
    );
  }
}
