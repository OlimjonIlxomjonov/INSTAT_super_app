import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/selected_file_container/selected_file_container_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_detail/review_detail_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_authors/review_author_entity.dart';

class DetailedArticleBodyWg extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    final parsedKeywords = _parseKeywords(detail?.keywords);
    final displayedAnnotation =
        detail?.annotationUz ??
        detail?.annotationRu ??
        detail?.annotationEn ??
        '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ID & UDK
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              detail != null ? '#${detail!.id}' : '#3465',
              style: AppTextStyles.source.medium(
                fontSize: 16,
                color: AppColors.greyScale.grey600,
              ),
            ),
            if (detail != null && detail!.udkCode.isNotEmpty)
              Text(
                'UDK: ${detail!.udkCode}',
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
          detail?.title ??
              'Sun\'iy intellekt yordamida ilmiy tadqiqot samaradorligini oshirish',
          style: CustomTextStyles.h2,
        ),

        const SizedBox(height: 24),

        /// Authors section
        Text('Mualliflar', style: CustomTextStyles.h2),
        const SizedBox(height: 16),

        if (authors == null || authors!.isEmpty)
          _AuthorCardWg(name: 'Author Name', phone: '+99899 889 90 90')
        else
          Column(
            children: authors!.map((author) {
              return _AuthorCardWg(
                name: '${author.firstName} ${author.lastName}',
                phone: '+998 ${author.phoneNumber}',
              );
            }).toList(),
          ),
        const SizedBox(height: 12),

        /// Annotatsiya
        Text('Annotatsiya', style: CustomTextStyles.h2),
        const SizedBox(height: 16),
        Text(
          displayedAnnotation,
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
          _KeywordChip(label: 'Kvant mexanikasi')
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

        if (detail == null)
          // Skeleton placeholder — looks like a real file card
          SelectedFileContainerWg(
            fileName: 'Tahlil, taqqoslash va prognozlash',
            fileSize: '3.4 MB',
          )
        else if (detail!.mainFile != null && detail!.mainFile!.isNotEmpty)
          SelectedFileContainerWg(
            fileName: _getFileName(detail!.mainFile),
            fileSize: _formatFileSize(detail!.mainFileSize),
            onTap: onFileOpen != null
                ? () => onFileOpen!(detail!.mainFile)
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
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Private helpers
// ---------------------------------------------------------------------------

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
