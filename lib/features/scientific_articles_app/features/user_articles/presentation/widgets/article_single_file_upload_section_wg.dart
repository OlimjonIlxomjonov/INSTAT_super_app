import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/dotted_container/dotted_cotnainer_wg.dart';
import 'package:my_template/core/utils/general_widgets/selected_file_container/selected_file_container_wg.dart';

class ArticleSingleFileUploadSectionWg extends StatelessWidget {
  final String title;
  final String formatsHint;
  final bool isUploading;
  final VoidCallback? onPickTap;
  final String? selectedFileName;
  final String? selectedFileSize;
  final String? existingFileName;
  final String? existingFileSize;

  const ArticleSingleFileUploadSectionWg({
    super.key,
    required this.title,
    required this.formatsHint,
    required this.isUploading,
    required this.onPickTap,
    this.selectedFileName,
    this.selectedFileSize,
    this.existingFileName,
    this.existingFileSize,
  });

  @override
  Widget build(BuildContext context) {
    final showExisting =
        selectedFileName == null &&
        existingFileName != null &&
        existingFileName!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: CustomTextStyles.h3),
        const SizedBox(height: 20),
        DottedContainerWg(
          formatsHint: formatsHint,
          onTap: isUploading ? null : onPickTap,
        ),
        if (isUploading) ...[
          const SizedBox(height: 15),
          const Center(child: CircularProgressIndicator.adaptive()),
        ],
        if (selectedFileName != null) ...[
          const SizedBox(height: 15),
          SelectedFileContainerWg(
            fileName: selectedFileName,
            fileSize: selectedFileSize,
          ),
        ] else if (showExisting) ...[
          const SizedBox(height: 15),
          SelectedFileContainerWg(
            fileName: existingFileName,
            fileSize: existingFileSize,
          ),
        ],
      ],
    );
  }
}
