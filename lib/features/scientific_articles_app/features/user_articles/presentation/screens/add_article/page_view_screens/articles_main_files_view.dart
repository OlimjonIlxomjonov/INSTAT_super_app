import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/common/params/article_params/article_params.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_files/review_files_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/add_article_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/add_article_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/antiplagiat_file/antiplagiat_file_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/antiplagiat_file/antiplagiat_file_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/main_file/main_file_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/main_file/main_file_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/upload_review_file/upload_review_file_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/upload_review_file/upload_review_file_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_files/review_files_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_files/review_files_state.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/widgets/article_file_picker_helper.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/widgets/article_multi_file_upload_section_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/user_articles/presentation/widgets/article_single_file_upload_section_wg.dart';

class ArticlesMainFilesView extends StatefulWidget {
  const ArticlesMainFilesView({super.key});

  @override
  State<ArticlesMainFilesView> createState() => _ArticlesMainFilesViewState();
}

class _ArticlesMainFilesViewState extends State<ArticlesMainFilesView> {
  static const _mainFileExtensions = {
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
  static const _antiplagiatExtensions = {'pdf'};
  static const _imageExtensions = {'jpg', 'jpeg', 'png'};
  static const _excelExtensions = {'xlsx'};

  List<ReviewFilesEntity> _imageFiles = [];
  List<ReviewFilesEntity> _excelFiles = [];
  int? _loadedReviewFilesForId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadReviewFiles(context.read<AddArticleBloc>().state.reviewId);
    });
  }

  void _loadReviewFiles(int? reviewId) {
    if (reviewId == null ||
        reviewId == 0 ||
        reviewId == _loadedReviewFilesForId) {
      return;
    }
    _loadedReviewFilesForId = reviewId;
    context.read<ReviewFilesBloc>().add(
      ReviewFilesEvent(params: ArticleProcessParams(articleId: reviewId)),
    );
  }

  void _showReviewIdRequiredError() {
    errorFlushBar(
      context,
      'Avval maqola ma\'lumotlarini saqlang (Saqlash tugmasi)',
    );
  }

  bool _requireReviewId(int? reviewId) {
    if (reviewId == null || reviewId == 0) {
      _showReviewIdRequiredError();
      return false;
    }
    return true;
  }

  void _updateUploadedFileDisplay({
    String? mainFileName,
    int? mainFileSize,
    String? antiplagiatFileName,
    int? antiplagiatFileSize,
  }) {
    context.read<AddArticleBloc>().add(
      UpdateArticleUploadedFileEvent(
        mainFileName: mainFileName,
        mainFileSize: mainFileSize,
        antiplagiatFileName: antiplagiatFileName,
        antiplagiatFileSize: antiplagiatFileSize,
      ),
    );
  }

  void _refreshArticleFilesFromServer() {
    context.read<AddArticleBloc>().add(const RefreshArticleFilesEvent());
  }

  Future<void> _validateAndUploadFile({
    required File file,
    required void Function() onUpload,
  }) async {
    final fileSize = await file.length();
    if (fileSize > ArticleFilePickerHelper.maxFileSizeBytes) {
      if (!mounted) return;
      errorFlushBar(context, 'Fayl hajmi 50 MB dan oshmasligi kerak');
      return;
    }
    if (!mounted) return;
    onUpload();
  }

  Future<void> _pickAndUploadMainFile(int reviewId) async {
    try {
      final picked = await ArticleFilePickerHelper.pickFiles(
        allowedExtensions: _mainFileExtensions,
        allowMultiple: false,
        invalidExtensionMessage:
            'Faqat PDF, Office va rasm fayllari qabul qilinadi',
        useImagePickerFallback: true,
      );
      if (picked.isEmpty || !mounted) return;

      final item = picked.first;
      final fileSize = await item.file.length();
      if (!mounted) return;

      _updateUploadedFileDisplay(
        mainFileName: item.name,
        mainFileSize: fileSize,
      );

      await _validateAndUploadFile(
        file: item.file,
        onUpload: () {
          context.read<MainFileBloc>().add(
            MainFileArticleEvent(
              params: AddMainFileParams(
                reviewId: reviewId,
                mainFile: item.file,
              ),
            ),
          );
        },
      );
    } on ArticleFilePickerException catch (e) {
      if (!mounted) return;
      errorFlushBar(context, e.message);
    }
  }

  Future<void> _pickAndUploadAntiplagiatFile(int reviewId) async {
    try {
      final picked = await ArticleFilePickerHelper.pickFiles(
        allowedExtensions: _antiplagiatExtensions,
        allowMultiple: false,
        invalidExtensionMessage:
            'Antiplagiat uchun faqat PDF fayl qabul qilinadi',
      );
      if (picked.isEmpty || !mounted) return;

      final item = picked.first;
      final fileSize = await item.file.length();
      if (!mounted) return;

      _updateUploadedFileDisplay(
        antiplagiatFileName: item.name,
        antiplagiatFileSize: fileSize,
      );

      await _validateAndUploadFile(
        file: item.file,
        onUpload: () {
          context.read<AntiplagiatFileBloc>().add(
            AntiplagiatFileEvent(
              params: AddAntiplagiatFileParams(
                reviewId: reviewId,
                file: item.file,
              ),
            ),
          );
        },
      );
    } on ArticleFilePickerException catch (e) {
      if (!mounted) return;
      errorFlushBar(context, e.message);
    }
  }

  Future<void> _pickAndUploadReviewFiles({
    required int reviewId,
    required Set<String> allowedExtensions,
    required String type,
    required String invalidExtensionMessage,
    bool useImagePickerFallback = false,
  }) async {
    try {
      final picked = await ArticleFilePickerHelper.pickFiles(
        allowedExtensions: allowedExtensions,
        allowMultiple: true,
        invalidExtensionMessage: invalidExtensionMessage,
        useImagePickerFallback: useImagePickerFallback,
      );
      if (picked.isEmpty || !mounted) return;

      final uploadBloc = context.read<UploadReviewFileBloc>();

      for (final item in picked) {
        if (!mounted) return;

        final fileSize = await item.file.length();
        if (!mounted) return;
        if (fileSize > ArticleFilePickerHelper.maxFileSizeBytes) {
          errorFlushBar(context, 'Fayl hajmi 50 MB dan oshmasligi kerak');
          return;
        }

        final uploadFuture = uploadBloc.stream.firstWhere(
          (state) =>
              state is UploadReviewFileLoaded ||
              (state is UploadReviewFileError && state.type == type),
        );

        uploadBloc.add(
          UploadReviewFileEvent(
            params: AddReviewFileParams(
              reviewId: reviewId,
              file: item.file,
              type: type,
            ),
          ),
        );

        final uploadState = await uploadFuture;
        if (!mounted) return;

        if (uploadState is UploadReviewFileError) {
          errorFlushBar(context, 'Faylni yuklashda xatolik yuz berdi');
          return;
        }
        if (uploadState is UploadReviewFileLoaded) {
          successFlushBar(context, 'Fayl muvaffaqiyatli yuklandi');
          setState(() {
            if (type == ReviewFileType.image) {
              _imageFiles = [..._imageFiles, uploadState.entity];
            } else {
              _excelFiles = [..._excelFiles, uploadState.entity];
            }
          });
        }
      }
    } on ArticleFilePickerException catch (e) {
      if (!mounted) return;
      errorFlushBar(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MainFileBloc, MainFileState>(
          listener: (context, state) {
            if (state is MainFileLoaded) {
              successFlushBar(context, 'Asosiy fayl muvaffaqiyatli yuklandi');
              _refreshArticleFilesFromServer();
            } else if (state is MainFileError) {
              errorFlushBar(context, 'Faylni yuklashda xatolik yuz berdi');
            }
          },
        ),
        BlocListener<AntiplagiatFileBloc, AntiplagiatFileState>(
          listener: (context, state) {
            if (state is AntiplagiatFileLoaded) {
              successFlushBar(
                context,
                'Antiplagiat fayli muvaffaqiyatli yuklandi',
              );
              _refreshArticleFilesFromServer();
            } else if (state is AntiplagiatFileError) {
              errorFlushBar(context, 'Faylni yuklashda xatolik yuz berdi');
            }
          },
        ),
        BlocListener<AddArticleBloc, AddArticleState>(
          listenWhen: (prev, curr) => prev.reviewId != curr.reviewId,
          listener: (context, state) {
            _loadedReviewFilesForId = null;
            _loadReviewFiles(state.reviewId);
          },
        ),
        BlocListener<ReviewFilesBloc, ReviewFilesState>(
          listener: (context, state) {
            if (state is ReviewFilesLoaded) {
              setState(() {
                _imageFiles = state.entity
                    .where((f) => f.type == ReviewFileType.image)
                    .toList();
                _excelFiles = state.entity
                    .where((f) => f.type == ReviewFileType.excel)
                    .toList();
              });
            }
          },
        ),
      ],
      child: BlocBuilder<AddArticleBloc, AddArticleState>(
        buildWhen: (prev, curr) =>
            prev.reviewId != curr.reviewId ||
            prev.existingMainFileUrl != curr.existingMainFileUrl ||
            prev.uploadedMainFileName != curr.uploadedMainFileName ||
            prev.existingAntiplagiatFileUrl != curr.existingAntiplagiatFileUrl ||
            prev.uploadedAntiplagiatFileName != curr.uploadedAntiplagiatFileName,
        builder: (context, articleState) {
          final reviewId = articleState.reviewId;

          return BlocBuilder<MainFileBloc, MainFileState>(
            builder: (context, mainFileState) {
              return BlocBuilder<AntiplagiatFileBloc, AntiplagiatFileState>(
                builder: (context, antiplagiatState) {
                  return BlocBuilder<
                    UploadReviewFileBloc,
                    UploadReviewFileState
                  >(
                    builder: (context, uploadReviewFileState) {
                      final isMainUploading = mainFileState is MainFileLoading;
                      final isAntiplagiatUploading =
                          antiplagiatState is AntiplagiatFileLoading;
                      final isImageUploading =
                          uploadReviewFileState is UploadReviewFileLoading &&
                          uploadReviewFileState.type == ReviewFileType.image;
                      final isExcelUploading =
                          uploadReviewFileState is UploadReviewFileLoading &&
                          uploadReviewFileState.type == ReviewFileType.excel;

                      return Padding(
                        padding: AppPadding.horizontal20x(),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ArticleSingleFileUploadSectionWg(
                                title: 'Asosiy fayl',
                                formatsHint:
                                    'JPEG, PNG, .DOC, .DOCX, .XLS, .XLSX, .PDF, .PPT, .PPTX up to 50 MB.',
                                isUploading: isMainUploading,
                                onPickTap: () {
                                  if (_requireReviewId(reviewId)) {
                                    _pickAndUploadMainFile(reviewId!);
                                  }
                                },
                                selectedFileName: articleState.hasMainFile
                                    ? articleState.displayMainFileName
                                    : null,
                                selectedFileSize:
                                    articleState.displayMainFileSize != null
                                    ? ArticleFilePickerHelper.formatFileSize(
                                        articleState.displayMainFileSize!,
                                      )
                                    : null,
                              ),

                              const SizedBox(height: 24),

                              ArticleSingleFileUploadSectionWg(
                                title: 'Antiplagiat fayli',
                                formatsHint: 'Faqat PDF format, 50 MB gacha.',
                                isUploading: isAntiplagiatUploading,
                                onPickTap: () {
                                  if (_requireReviewId(reviewId)) {
                                    _pickAndUploadAntiplagiatFile(reviewId!);
                                  }
                                },
                                selectedFileName: articleState.hasAntiplagiatFile
                                    ? articleState.displayAntiplagiatFileName
                                    : null,
                                selectedFileSize:
                                    articleState.displayAntiplagiatFileSize !=
                                        null
                                    ? ArticleFilePickerHelper.formatFileSize(
                                        articleState
                                            .displayAntiplagiatFileSize!,
                                      )
                                    : null,
                              ),

                              const SizedBox(height: 24),

                              ArticleMultiFileUploadSectionWg(
                                title: 'Rasmlar',
                                formatsHint:
                                    'PNG va JPEG formatlar, 50 MB gacha.',
                                isUploading: isImageUploading,
                                files: _imageFiles,
                                onPickTap: () {
                                  if (_requireReviewId(reviewId)) {
                                    _pickAndUploadReviewFiles(
                                      reviewId: reviewId!,
                                      allowedExtensions: _imageExtensions,
                                      type: ReviewFileType.image,
                                      invalidExtensionMessage:
                                          'Rasmlar uchun faqat PNG va JPEG qabul qilinadi',
                                      useImagePickerFallback: true,
                                    );
                                  }
                                },
                              ),

                              const SizedBox(height: 24),

                              ArticleMultiFileUploadSectionWg(
                                title: 'Jadvallar',
                                formatsHint: 'Faqat XLSX format, 50 MB gacha.',
                                isUploading: isExcelUploading,
                                files: _excelFiles,
                                onPickTap: () {
                                  if (_requireReviewId(reviewId)) {
                                    _pickAndUploadReviewFiles(
                                      reviewId: reviewId!,
                                      allowedExtensions: _excelExtensions,
                                      type: ReviewFileType.excel,
                                      invalidExtensionMessage:
                                          'Jadvallar uchun faqat XLSX qabul qilinadi',
                                    );
                                  }
                                },
                              ),

                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
