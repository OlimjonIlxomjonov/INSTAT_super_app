import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/article_params/article_params.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/custom_drop_down_menu_wg.dart';
import 'package:my_template/features/auth/presentation/widgets/auth_text_field_wg.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/widgets_edu/edu_custom_text_area_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/add_article/drop_down/drop_down_entity.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/drop_down/academic_degree/academic_degree_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/drop_down/article_type/article_type_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/drop_down/article_type/article_type_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/drop_down/journal_sections/journal_section_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/drop_down/journal_sections/journal_sections_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/udk/udk_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/udk/udk_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/add_article_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/add_article_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ArticleInfoView extends StatefulWidget {
  const ArticleInfoView({super.key});

  @override
  State<ArticleInfoView> createState() => _ArticleInfoViewState();
}

class _ArticleInfoViewState extends State<ArticleInfoView> {
  final titleController = TextEditingController();
  final udkController = TextEditingController();

  final List<DropDownEntity> languageOptions = [
    DropDownEntity(
      id: 1,
      name: "O'zbek tili",
      isActive: true,
      createdAt: DateTime.now(),
    ),
    DropDownEntity(
      id: 2,
      name: "Rus tili",
      isActive: true,
      createdAt: DateTime.now(),
    ),
    DropDownEntity(
      id: 3,
      name: "Ingliz tili",
      isActive: true,
      createdAt: DateTime.now(),
    ),
  ];

  int? _mapLanguageToId(String lang) {
    if (lang == 'uz') return 1;
    if (lang == 'ru') return 2;
    if (lang == 'en') return 3;
    return null;
  }

  String _mapIdToLanguage(int? id) {
    if (id == 1) return 'uz';
    if (id == 2) return 'ru';
    if (id == 3) return 'en';
    return 'uz';
  }

  @override
  void initState() {
    super.initState();
    context.read<ArticleTypeBloc>().add(ArticleTypeEvent());
    context.read<JournalSectionBloc>().add(JournalSectionsEvent());
    context.read<AcademicDegreeBloc>().add(AcademicDegreeEvent());

    final state = context.read<AddArticleBloc>().state;
    titleController.text = state.title;
    udkController.text = state.udkCode;
  }

  @override
  void dispose() {
    titleController.dispose();
    udkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.horizontal20x(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TEXT AREA
            Text('Sarlavha', style: CustomTextStyles.h3half),
            SizedBox(height: 8),
            EduCustomTextAreaWg(
              hintText: 'Maqola sarlavhasini kiriting...',
              controller: titleController,
              onChanged: (val) {
                context.read<AddArticleBloc>().add(
                  UpdateAddArticleFieldEvent(title: val),
                );
              },
            ),

            SizedBox(height: 14),

            /// UDK RAQAMI
            Text('UDK', style: CustomTextStyles.h3half),
            SizedBox(height: 8),
            BlocBuilder<UdkBloc, UdkState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AuthTextFieldWg(
                      label: 'UDK raqamini kiriting',
                      controller: udkController,
                      isTypeNum: true,
                      onChanged: (val) {
                        context.read<AddArticleBloc>().add(
                          UpdateAddArticleFieldEvent(udkCode: val),
                        );
                      },
                      onEditingComplete: () {
                        final text = udkController.text.trim();

                        if (text.isNotEmpty) {
                          context.read<UdkBloc>().add(
                            UdkEvent(params: UdkParams(udkCode: text)),
                          );
                        }
                      },
                    ),
                    if (state is UdkLoading)
                      const Skeletonizer(
                        enabled: true,
                        child: Text(
                          'This field is trying to find valid UDK,\nplease wait!...',
                        ),
                      ),
                    if (state is UdkLoaded &&
                        udkController.text.trim().isNotEmpty)
                      Text(state.entity.title, style: CustomTextStyles.h4),
                    if (state is UdkError) const Text('Invalid UDK!'),
                  ],
                );
              },
            ),

            SizedBox(height: 14),

            /// DROP DOWNS
            // Maqola turi
            BlocBuilder<ArticleTypeBloc, ArticleTypeState>(
              builder: (context, state) {
                final loaded = state is ArticleTypeLoaded ? state.entity : null;
                return BlocBuilder<AddArticleBloc, AddArticleState>(
                  builder: (context, addState) {
                    return CustomDropDownMenuWg(
                      title: 'Maqola turi',
                      hintText: 'Turini tanlang',
                      options: loaded,
                      value: addState.articleType,
                      onChanged: (val) {
                        context.read<AddArticleBloc>().add(
                          UpdateAddArticleFieldEvent(articleType: val),
                        );
                      },
                    );
                  },
                );
              },
            ),
            SizedBox(height: 14),

            // Maqola tili
            BlocBuilder<AddArticleBloc, AddArticleState>(
              builder: (context, addState) {
                return CustomDropDownMenuWg(
                  title: 'Maqolani tili',
                  hintText: 'O\'zbek tili',
                  options: languageOptions,
                  value: _mapLanguageToId(addState.language),
                  onChanged: (val) {
                    context.read<AddArticleBloc>().add(
                      UpdateAddArticleFieldEvent(
                        language: _mapIdToLanguage(val),
                      ),
                    );
                  },
                );
              },
            ),
            SizedBox(height: 14),

            // Jurnal bolimi
            BlocBuilder<JournalSectionBloc, JournalSectionsState>(
              builder: (context, state) {
                final loaded = state is JournalSectionsLoaded
                    ? state.entity
                    : null;

                return BlocBuilder<AddArticleBloc, AddArticleState>(
                  builder: (context, addState) {
                    return CustomDropDownMenuWg(
                      title: 'Jurnal bo’limi',
                      hintText: 'Bo\'limni tanlang',
                      options: loaded,
                      value: addState.journalSection,
                      onChanged: (val) {
                        context.read<AddArticleBloc>().add(
                          UpdateAddArticleFieldEvent(journalSection: val),
                        );
                      },
                    );
                  },
                );
              },
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
