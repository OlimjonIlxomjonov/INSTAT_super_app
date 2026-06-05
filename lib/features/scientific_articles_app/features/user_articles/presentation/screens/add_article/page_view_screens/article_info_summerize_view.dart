import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/features/scientific_articles_app/articles_widgets/detailed_article_body_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_authors/review_author_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/review_detail/review_detail_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/add_article_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/add_article_state.dart';

class ArticleInfoSummerizeView extends StatefulWidget {
  const ArticleInfoSummerizeView({super.key});

  @override
  State<ArticleInfoSummerizeView> createState() =>
      _ArticleInfoSummerizeViewState();
}

class _ArticleInfoSummerizeViewState extends State<ArticleInfoSummerizeView> {
  /// Build a lightweight ReviewDetailEntity from AddArticleState for preview.
  ReviewDetailEntity _buildPreviewDetail(AddArticleState state) {
    // Encode keywords list as JSON string (or empty array string if empty).
    final keywordsJson = state.keywords.isNotEmpty
        ? '[${state.keywords.map((k) => '"$k"').join(',')}]'
        : '[]';

    return ReviewDetailEntity(
      id: state.reviewId ?? 0,
      title: state.title.isEmpty ? "Maqola nomi kiritilmagan" : state.title,
      articleType: state.articleType ?? 1,
      journalSection: state.journalSection ?? 1,
      udkCode: state.udkCode,
      annotationUz: state.annotationUz ?? '',
      annotationEn: state.annotationEn ?? '',
      annotationRu: state.annotationRu ?? '',
      keywords: keywordsJson,
      mainFile: state.existingMainFileUrl,
      mainFileSize: state.existingMainFileSize,
      antiplagiatFile: null,
      antiplagiatFileSize: null,
      status: '',
      language: state.language,
      userId: 0,
    );
  }

  /// Merge localAuthors (not yet on server) + savedAuthors into one list for preview.
  List<ReviewAuthorEntity> _buildPreviewAuthors(AddArticleState state) {
    final fromLocal = state.localAuthors.map((a) {
      return ReviewAuthorEntity(
        id: 0,
        firstName: a.firstName,
        lastName: a.lastName,
        review: state.reviewId ?? 0,
        academicDegree: null,
        address: a.address,
        organization: a.organization,
        email: a.email,
        phoneNumber: a.phoneNumber,
        orcidCode: a.orcidCode ?? '',
        createdAt: null,
      );
    }).toList();

    return [...state.savedAuthors, ...fromLocal];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddArticleBloc, AddArticleState>(
      builder: (context, state) {
        final previewDetail = _buildPreviewDetail(state);
        final previewAuthors = _buildPreviewAuthors(state);

        return Padding(
          padding: AppPadding.horizontal20x(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ARTICLE BODY PREVIEW
                DetailedArticleBodyWg(
                  detail: previewDetail,
                  authors: previewAuthors,
                ),

                /// CONFIRMATION CHECKBOX
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.greyScale.grey50,
                    border: Border.all(color: AppColors.greyScale.grey200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Header
                      Row(
                        children: [
                          Icon(
                            Icons.corporate_fare,
                            color: AppColors.greyScale.grey600,
                          ),
                          Text(
                            ' Yakuniy tasdiqlash',
                            style: CustomTextStyles.h3,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// Checkbox + text
                      _approveSection(
                        "Originallik bayonoti: Maqola originalligini tasdiqlayman, ushbu qo'lyozma avval chop etilmagan va hozirda boshqa joyda ko'rib chiqilmayapti.Originallik bayonoti: Maqola originalligini tasdiqlayman, ushbu qo'lyozma avval chop etilmagan va hozirda boshqa joyda ko'rib chiqilmayapti.",
                      ),
                      _approveSection(
                        "Shartlar va qoidalar: Jurnal qoidalariga roziman, shuningdek ma'lumotlar siyosati va mualliflik huquqi shartnomasiga.",
                      ),
                      _approveSection(
                        "Axloqiy me'yorlar: Men barcha tadqiqotlar axloqiy ko'rsatmalarga javob berishini, shu jumladan tegishli institutsional ko'rib chiqish kengashlarining roziligini tasdiqlayman.",
                      ),
                    ],
                  ),
                ),

                /// FREE BOTTOM SPACE
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _approveSection(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox.adaptive(
            fillColor: WidgetStateProperty.all(AppColors.primaryColor),
            value: true,
            onChanged: (newValue) {},
          ),
          Expanded(
            child: Text(
              text,
              style: CustomTextStyles.h3half.copyWith(
                color: AppColors.greyScale.grey600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
