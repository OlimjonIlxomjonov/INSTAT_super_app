import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/annotation_language/annotation_language_wg.dart';
import 'package:my_template/features/auth/presentation/widgets/auth_text_field_wg.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/widgets_edu/edu_custom_text_area_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/add_article_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/add_article_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';

class ArticleAnnotationView extends StatefulWidget {
  const ArticleAnnotationView({super.key});

  @override
  State<ArticleAnnotationView> createState() => _ArticleAnnotationViewState();
}

class _ArticleAnnotationViewState extends State<ArticleAnnotationView> {
  AnnotationLanguageEnum _selectedLang = AnnotationLanguageEnum.uz;
  final annotationController = TextEditingController();
  final keywordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _syncAnnotationFromState();
  }

  void _syncAnnotationFromState() {
    final state = context.read<AddArticleBloc>().state;
    if (_selectedLang == AnnotationLanguageEnum.uz) {
      annotationController.text = state.annotationUz ?? '';
    } else if (_selectedLang == AnnotationLanguageEnum.en) {
      annotationController.text = state.annotationEn ?? '';
    } else {
      annotationController.text = state.annotationRu ?? '';
    }
  }

  @override
  void dispose() {
    annotationController.dispose();
    keywordController.dispose();
    super.dispose();
  }

  void _updateAnnotationText() {
    final state = context.read<AddArticleBloc>().state;
    if (_selectedLang == AnnotationLanguageEnum.uz) {
      annotationController.text = state.annotationUz ?? '';
    } else if (_selectedLang == AnnotationLanguageEnum.en) {
      annotationController.text = state.annotationEn ?? '';
    } else {
      annotationController.text = state.annotationRu ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final List<bool> isSelected = [
      _selectedLang == AnnotationLanguageEnum.uz,
      _selectedLang == AnnotationLanguageEnum.en,
      _selectedLang == AnnotationLanguageEnum.ru,
    ];

    String annotationTitle = localization.annotationUzTitle;
    if (_selectedLang == AnnotationLanguageEnum.en) {
      annotationTitle = localization.annotationEnTitle;
    } else if (_selectedLang == AnnotationLanguageEnum.ru) {
      annotationTitle = localization.annotationRuTitle;
    }

    return Padding(
      padding: AppPadding.horizontal20x(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LANGUAGE SELECTION
            SizedBox(
              height: 45,
              child: AnnotationLanguageWg(
                isSelected: isSelected,
                onChanged: (index) => setState(() {
                  _selectedLang = AnnotationLanguageEnum.values[index];
                  _updateAnnotationText();
                }),
              ),
            ),

            const SizedBox(height: 12),

            /// text area
            Text(annotationTitle, style: CustomTextStyles.h3half),
            const SizedBox(height: 8),
            EduCustomTextAreaWg(
              maxLength: 300,
              controller: annotationController,
              hintText: localization.annotationHint,
              helperText: localization.annotationWordCountHelper,
              onChanged: (val) {
                if (_selectedLang == AnnotationLanguageEnum.uz) {
                  context.read<AddArticleBloc>().add(
                        UpdateAddArticleFieldEvent(annotationUz: val),
                      );
                } else if (_selectedLang == AnnotationLanguageEnum.en) {
                  context.read<AddArticleBloc>().add(
                        UpdateAddArticleFieldEvent(annotationEn: val),
                      );
                } else {
                  context.read<AddArticleBloc>().add(
                        UpdateAddArticleFieldEvent(annotationRu: val),
                      );
                }
              },
            ),

            const SizedBox(height: 12),

            /// Key Words INPUT
            AuthTextFieldWg(
              title: localization.keywords,
              label: localization.keywordsHint,
              controller: keywordController,
              onEditingComplete: () {
                final text = keywordController.text.trim();
                if (text.isNotEmpty) {
                  final addBloc = context.read<AddArticleBloc>();
                  final currentKeywords = addBloc.state.keywords;
                  if (!currentKeywords.contains(text)) {
                    final updated = List<String>.from(currentKeywords)..add(text);
                    addBloc.add(UpdateAddArticleFieldEvent(keywords: updated));
                  }
                  keywordController.clear();
                }
              },
            ),

            const SizedBox(height: 12),

            /// Key words WRAP
            BlocBuilder<AddArticleBloc, AddArticleState>(
              builder: (context, addState) {
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: addState.keywords.map(
                    (keyword) => Container(
                      padding: const EdgeInsets.only(left: 10, right: 4, top: 4, bottom: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.greyScale.grey200),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            keyword,
                            style: AppTextStyles.source.medium(
                              fontSize: 13,
                              color: AppColors.greyScale.grey600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: () {
                              final updated = List<String>.from(addState.keywords)..remove(keyword);
                              context.read<AddArticleBloc>().add(
                                    UpdateAddArticleFieldEvent(keywords: updated),
                                  );
                            },
                            borderRadius: BorderRadius.circular(50),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Icon(
                                Icons.close,
                                size: 18,
                                color: AppColors.greyScale.grey600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).toList(),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
