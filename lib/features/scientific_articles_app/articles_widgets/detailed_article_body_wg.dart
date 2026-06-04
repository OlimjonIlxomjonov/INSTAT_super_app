import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/ui_states/empty_state.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/annotation_language/annotation_language_wg.dart';
import 'package:my_template/core/utils/general_widgets/selected_file_container/selected_file_container_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_detail/review_detail_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_authors/review_author_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_files/review_files_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/review_files/review_files_state.dart';

class DetailedArticleBodyWg extends StatefulWidget {
  final ReviewDetailEntity? detail;
  final List<ReviewAuthorEntity>? authors;

  /// Called with the file URL when the user taps the file card.
  /// Null means there is nothing to open yet (e.g. while loading).
  final void Function(String? url)? onFileOpen;

  const DetailedArticleBodyWg({
    super.key,
    this.detail,
    this.authors,
    this.onFileOpen,
  });

  @override
  State<DetailedArticleBodyWg> createState() => _DetailedArticleBodyWgState();
}

class _DetailedArticleBodyWgState extends State<DetailedArticleBodyWg> {
  String _formatFileSize(int? bytes) {
    if (bytes == null) return 'Noma\'lum hajm';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _getFileName(String? urlPath) {
    if (urlPath == null || urlPath.isEmpty) return 'Fayl nomi yo\'q';
    try {
      return Uri.parse(urlPath).pathSegments.last;
    } catch (_) {
      return 'Fayl';
    }
  }

  List<String> _parseKeywords(String? keywordsJson) {
    if (keywordsJson == null || keywordsJson.isEmpty) return [];
    try {
      final decoded = jsonDecode(keywordsJson);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {
      return keywordsJson
          .replaceAll('[', '')
          .replaceAll(']', '')
          .replaceAll('"', '')
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return [];
  }

  AnnotationLanguageEnum _selectedLang = AnnotationLanguageEnum.uz;

  String get _displayedAnnotation {
    switch (_selectedLang) {
      case AnnotationLanguageEnum.uz:
        return widget.detail?.annotationUz ??
            'Hech qanday annotatsiya mavjud emas!';
      case AnnotationLanguageEnum.en:
        return widget.detail?.annotationEn ??
            'Hech qanday annotatsiya mavjud emas!';
      case AnnotationLanguageEnum.ru:
        return widget.detail?.annotationRu ??
            'Hech qanday annotatsiya mavjud emas!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<bool> isSelected = [
      _selectedLang == AnnotationLanguageEnum.uz,
      _selectedLang == AnnotationLanguageEnum.en,
      _selectedLang == AnnotationLanguageEnum.ru,
    ];

    final parsedKeywords = _parseKeywords(widget.detail?.keywords);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ID & UDK
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.detail != null ? '#${widget.detail!.id}' : '#3465',
              style: AppTextStyles.source.medium(
                fontSize: 16,
                color: AppColors.greyScale.grey600,
              ),
            ),
            if (widget.detail != null && widget.detail!.udkCode.isNotEmpty)
              Text(
                'UDK: ${widget.detail!.udkCode}',
                style: AppTextStyles.source.medium(
                  fontSize: 14,
                  color: AppColors.greyScale.grey600,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),

        /// Title
        Text(
          widget.detail?.title ??
              'Sun\'iy intellekt yordamida ilmiy tadqiqot samaradorligini oshirish',
          style: CustomTextStyles.h2,
        ),

        const SizedBox(height: 24),

        /// Authors section
        Text('Mualliflar', style: CustomTextStyles.h2),
        const SizedBox(height: 16),

        if (widget.authors == null || widget.authors!.isEmpty)
          _AuthorCardWg(name: 'Muallif tanlanmagan!', phone: '---')
        else
          Column(
            children: widget.authors!.map((author) {
              return _AuthorCardWg(
                name: '${author.firstName} ${author.lastName}',
                phone: '+998 ${author.phoneNumber}',
              );
            }).toList(),
          ),
        const SizedBox(height: 12),

        /// Annotatsiya
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text('Annotatsiya', style: CustomTextStyles.h2),
            SizedBox(
              height: 45,
              child: AnnotationLanguageWg(
                isSelected: isSelected,
                onChanged: (index) => setState(() {
                  _selectedLang = AnnotationLanguageEnum.values[index];
                }),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          _displayedAnnotation,
          style: AppTextStyles.source.regular(
            fontSize: 14,
            color: AppColors.greyScale.grey600,
          ),
        ),
        const SizedBox(height: 24),

        /// Keywords
        Text('Kalit so\'zlar', style: CustomTextStyles.h2),
        const SizedBox(height: 16),
        if (parsedKeywords.isEmpty)
          _KeywordChip(label: 'Hech qanday kalit soz mavjud emas!')
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: parsedKeywords
                .map((kw) => _KeywordChip(label: kw))
                .toList(),
          ),
        const SizedBox(height: 24),

        /// Hujjatlar section
        Text('Hujjatlar', style: CustomTextStyles.h2),
        const SizedBox(height: 16),

        if (widget.detail == null)
          // Skeleton placeholder
          SelectedFileContainerWg(
            fileName: 'Tahlil, taqqoslash va prognozlash',
            fileSize: '3.4 MB',
          )
        else if (widget.detail!.mainFile != null &&
            widget.detail!.mainFile!.isNotEmpty)
          SelectedFileContainerWg(
            fileName: _getFileName(widget.detail!.mainFile),
            fileSize: _formatFileSize(widget.detail!.mainFileSize),
            onTap: widget.onFileOpen != null
                ? () => widget.onFileOpen!(widget.detail!.mainFile)
                : null,
          )
        else
          Text(
            'Hujjat biriktirilmagan',
            style: AppTextStyles.source.regular(
              fontSize: 14,
              color: AppColors.greyScale.grey600,
            ),
          ),
        const SizedBox(height: 20),

        /// Antiplagiat section
        Text('Antiplagiat fayli', style: CustomTextStyles.h2),
        const SizedBox(height: 15),
        if (widget.detail == null)
          SelectedFileContainerWg(fileName: 'Yuklanmoqda...', fileSize: '')
        else if (widget.detail!.antiplagiatFile != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: SelectedFileContainerWg(
              fileName: _getFileName(widget.detail!.antiplagiatFile),
              fileSize: _formatFileSize(widget.detail!.antiplagiatFileSize),
              onTap: widget.onFileOpen != null
                  ? () => widget.onFileOpen!(widget.detail!.antiplagiatFile)
                  : null,
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text("Fayl tanlanmagan", style: CustomTextStyles.h4),
          ),

        /// IMAGES AND EXCELS
        BlocBuilder<ReviewFilesBloc, ReviewFilesState>(
          builder: (context, state) {
            if (state is ReviewFilesLoaded) {
              final images =
                  state.entity?.where((f) => f.type == 'image').toList() ?? [];
              final excels =
                  state.entity?.where((f) => f.type == 'excel').toList() ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Rasmlar section
                  Text('Rasmlar', style: CustomTextStyles.h2),
                  const SizedBox(height: 15),
                  if (images.isEmpty)
                    Padding(
                      padding: const .only(bottom: 20),
                      child: Text(
                        "Rasm tanlanmagan",
                        style: CustomTextStyles.h4,
                      ),
                    )
                  else
                    ...images.map(
                      (f) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SelectedFileContainerWg(
                          fileName: f.fileName ?? '',
                          fileSize: _formatFileSize(f.fileSize),
                          onTap: widget.onFileOpen != null
                              ? () => widget.onFileOpen!(f.file)
                              : null,
                        ),
                      ),
                    ),

                  images.isEmpty || excels.isEmpty
                      ? const SizedBox(height: 0)
                      : const SizedBox(height: 15),

                  /// Jadvallar section
                  Text('Jadvallar', style: CustomTextStyles.h2),
                  const SizedBox(height: 15),
                  if (excels.isEmpty)
                    SizedBox(
                      height: 60,
                      child: Text(
                        "Jadval tanlanmagan",
                        style: CustomTextStyles.h4,
                      ),
                    )
                  else
                    ...excels.map(
                      (f) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SelectedFileContainerWg(
                          fileName: f.fileName ?? '',
                          fileSize: _formatFileSize(f.fileSize),
                          onTap: widget.onFileOpen != null
                              ? () => widget.onFileOpen!(f.file)
                              : null,
                        ),
                      ),
                    ),
                ],
              );
            }

            // loading state
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rasmlar', style: CustomTextStyles.h2),
                const SizedBox(height: 15),
                SelectedFileContainerWg(
                  fileName: 'Rasm tanlanmagan!',
                  fileSize: '',
                ),
                const SizedBox(height: 24),
                Text('Jadvallar', style: CustomTextStyles.h2),
                const SizedBox(height: 15),
                SelectedFileContainerWg(
                  fileName: 'Jadval tanlanmagan!',
                  fileSize: '',
                ),
                const SizedBox(height: 15),
              ],
            );
          },
        ),
      ],
    );
  }
}

// Private helpers
class _AuthorCardWg extends StatelessWidget {
  final String name;
  final String phone;

  const _AuthorCardWg({required this.name, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyScale.grey200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        spacing: 12,
        children: [
          const CircleAvatar(radius: 25, child: Icon(Icons.person)),
          Expanded(
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.source.medium(fontSize: 14)),
                Text(
                  phone,
                  style: AppTextStyles.source.regular(
                    fontSize: 12,
                    color: AppColors.greyScale.grey600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KeywordChip extends StatelessWidget {
  final String label;

  const _KeywordChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: AppColors.greyScale.grey50,
      ),
      child: Text(label),
    );
  }
}
