import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/dotted_container/dotted_cotnainer_wg.dart';
import 'package:my_template/core/utils/general_widgets/selected_file_container/selected_file_container_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_files/review_files_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/widgets/article_file_picker_helper.dart';

class ArticleMultiFileUploadSectionWg extends StatelessWidget {
  final String title;
  final String formatsHint;
  final bool isUploading;
  final VoidCallback? onPickTap;
  final List<ReviewFilesEntity> files;

  const ArticleMultiFileUploadSectionWg({
    super.key,
    required this.title,
    required this.formatsHint,
    required this.isUploading,
    required this.onPickTap,
    required this.files,
  });

  @override
  Widget build(BuildContext context) {
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
        if (files.isNotEmpty) ...[
          const SizedBox(height: 15),
          ...files.map(
            (file) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SelectedFileContainerWg(
                fileName: file.fileName ?? _fileNameFromUrl(file.file),
                fileSize: file.fileSize != null
                    ? ArticleFilePickerHelper.formatFileSize(file.fileSize!)
                    : null,
              ),
            ),
          ),
        ],
      ],
    );
  }

  String? _fileNameFromUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    return Uri.parse(url).pathSegments.last;
  }
}
