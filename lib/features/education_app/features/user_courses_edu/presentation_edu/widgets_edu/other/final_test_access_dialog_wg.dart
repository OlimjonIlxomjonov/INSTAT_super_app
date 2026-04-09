import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';

class FinalTestAccessDialogWg extends StatelessWidget {
  const FinalTestAccessDialogWg({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(
        ' Would you like to start the Final Test?',
        style: CustomTextStyles.h2,
      ),
      actions: [
        ElevatedButton(onPressed: () {}, child: Text('data')),
        ElevatedButton(onPressed: () {}, child: Text('data')),
      ],
    );
  }
}
