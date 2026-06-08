import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_template/core/common/flush_bar/error_flush_bar.dart';
import 'package:my_template/core/common/flush_bar/success_flush_bar.dart';
import 'package:my_template/core/common/params/article_params/article_params.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/dotted_container/dotted_cotnainer_wg.dart';
import 'package:my_template/core/utils/general_widgets/selected_file_container/selected_file_container_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/add_article_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/add_article_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/main_file/main_file_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/main_file/main_file_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';

class ArticlesMainFilesView extends StatefulWidget {
  const ArticlesMainFilesView({super.key});

  @override
  State<ArticlesMainFilesView> createState() => _ArticlesMainFilesViewState();
}

class _ArticlesMainFilesViewState extends State<ArticlesMainFilesView> {
  static const int _maxFileSizeBytes = 50 * 1024 * 1024;
  static const _allowedExtensions = {
    'pdf',
    'doc',
    'docx',
    'xls',
    'xlsx',
    'ppt',
    'pptx',
    'jpg',
    'jpeg',
    'png',
  };

  final ImagePicker _imagePicker = ImagePicker();

  String? _selectedFileName;
  String? _selectedFileSize;

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  bool _isAllowedExtension(String? extension) {
    if (extension == null || extension.isEmpty) return true;
    return _allowedExtensions.contains(extension.toLowerCase());
  }

  Future<File?> _pickWithFilePicker() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _allowedExtensions.toList(),
      allowMultiple: false,
      withData: false,
    );
    if (result == null || result.files.isEmpty) return null;

    final picked = result.files.first;
    if (!_isAllowedExtension(picked.extension)) {
      throw const _PickFileException(
        'Faqat PDF, Office va rasm fayllari qabul qilinadi',
      );
    }

    final path = picked.path;
    if (path == null) {
      throw const _PickFileException('Fayl tanlanmadi');
    }

    return File(path);
  }

  Future<File?> _pickWithImagePicker() async {
    final picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (picked == null) return null;
    return File(picked.path);
  }

  Future<({File file, String name})?> _pickMainFile() async {
    try {
      final file = await _pickWithFilePicker();
      if (file == null) return null;
      return (file: file, name: file.path.split('/').last);
    } on MissingPluginException {
      final file = await _pickWithImagePicker();
      if (file == null) return null;
      return (file: file, name: file.path.split('/').last);
    } on _PickFileException {
      rethrow;
    } catch (_) {
      throw const _PickFileException('Fayl tanlashda xatolik yuz berdi');
    }
  }

  Future<void> _pickAndUploadMainFile(int reviewId) async {
    ({File file, String name})? picked;
    try {
      picked = await _pickMainFile();
    } on _PickFileException catch (e) {
      if (!mounted) return;
      errorFlushBar(context, e.message);
      return;
    }

    if (picked == null || !mounted) return;

    final fileSize = await picked.file.length();

    if (fileSize > _maxFileSizeBytes) {
      if (!mounted) return;
      errorFlushBar(context, 'Fayl hajmi 50 MB dan oshmasligi kerak');
      return;
    }

    if (!mounted) return;

    setState(() {
      _selectedFileName = picked!.name;
      _selectedFileSize = _formatFileSize(fileSize);
    });

    context.read<MainFileBloc>().add(
      MainFileArticleEvent(
        params: AddMainFileParams(reviewId: reviewId, mainFile: picked.file),
      ),
    );
  }

  void _onPickMainFileTap(int? reviewId) {
    if (reviewId == null || reviewId == 0) {
      errorFlushBar(
        context,
        'Avval maqola ma\'lumotlarini saqlang (Saqlash tugmasi)',
      );
      return;
    }
    _pickAndUploadMainFile(reviewId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainFileBloc, MainFileState>(
      listener: (context, state) {
        if (state is MainFileLoaded) {
          successFlushBar(context, 'Asosiy fayl muvaffaqiyatli yuklandi');
        } else if (state is MainFileError) {
          errorFlushBar(context, 'Faylni yuklashda xatolik yuz berdi');
        }
      },
      child: BlocBuilder<AddArticleBloc, AddArticleState>(
        buildWhen: (prev, curr) =>
            prev.reviewId != curr.reviewId ||
            prev.existingMainFileUrl != curr.existingMainFileUrl,
        builder: (context, articleState) {
          final reviewId = articleState.reviewId;
          final existingUrl = articleState.existingMainFileUrl;
          final existingSize = articleState.existingMainFileSize;
          final existingFileName = existingUrl != null && existingUrl.isNotEmpty
              ? Uri.parse(existingUrl).pathSegments.last
              : null;
          final showExistingFile =
              _selectedFileName == null &&
              existingFileName != null &&
              existingFileName.isNotEmpty;

          return BlocBuilder<MainFileBloc, MainFileState>(
            builder: (context, mainFileState) {
              final isUploading = mainFileState is MainFileLoading;

              return Padding(
                padding: AppPadding.horizontal20x(),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DottedContainerWg(
                        onTap: isUploading
                            ? null
                            : () => _onPickMainFileTap(reviewId),
                      ),
                      if (isUploading) ...[
                        const SizedBox(height: 15),
                        const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ],
                      if (_selectedFileName != null) ...[
                        const SizedBox(height: 15),
                        SelectedFileContainerWg(
                          fileName: _selectedFileName,
                          fileSize: _selectedFileSize,
                        ),
                      ] else if (showExistingFile) ...[
                        const SizedBox(height: 15),
                        SelectedFileContainerWg(
                          fileName: existingFileName,
                          fileSize: existingSize != null
                              ? _formatFileSize(existingSize)
                              : null,
                        ),
                      ],

                      const SizedBox(height: 24),

                      /// ANTIPLAGIAT FILE
                      Text('Antipgaiat fayli', style: CustomTextStyles.h3),
                      const SizedBox(height: 20),
                      DottedContainerWg(),

                      const SizedBox(height: 24),

                      /// JADVAL
                      Text('Rasmlar', style: CustomTextStyles.h3),
                      const SizedBox(height: 20),
                      DottedContainerWg(),

                      const SizedBox(height: 24),

                      //! Jadvallar
                      Text('Jadvallar', style: CustomTextStyles.h3),
                      const SizedBox(height: 20),
                      DottedContainerWg(),

                      /// FREE BOTTOM SPACE
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _PickFileException implements Exception {
  final String message;

  const _PickFileException(this.message);
}
