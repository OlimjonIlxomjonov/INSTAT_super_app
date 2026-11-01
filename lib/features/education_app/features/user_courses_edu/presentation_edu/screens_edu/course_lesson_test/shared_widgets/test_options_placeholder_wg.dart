import 'package:flutter/material.dart';
import 'package:my_template/features/education_app/features/user_courses_edu/presentation_edu/widgets_edu/default_custom_tile_wg.dart';

class TestOptionsPlaceholderWg extends StatelessWidget {
  const TestOptionsPlaceholderWg({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        4,
        (_) => DefaultCustomTileWg(
          onTap: () {},
          tileTitle: 'Javob varianti matni shu yerda',
          tileAction: const Icon(Icons.circle_outlined),
        ),
      ),
    );
  }
}
