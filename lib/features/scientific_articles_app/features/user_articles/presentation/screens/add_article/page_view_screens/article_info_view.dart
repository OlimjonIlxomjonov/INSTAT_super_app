import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/article_params/article_params.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/custom_drop_down_menu_wg.dart';
import 'package:my_template/core/utils/logger/logger.dart';
import 'package:my_template/features/auth/presentation/widgets/auth_text_field_wg.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/widgets_edu/edu_custom_text_area_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/drop_down/article_type/article_type_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/drop_down/article_type/article_type_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/drop_down/journal_sections/journal_section_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/drop_down/journal_sections/journal_sections_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/udk/udk_bloc.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/add_article/udk/udk_state.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/bloc/articles_home_event.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ArticleInfoView extends StatefulWidget {
  const ArticleInfoView({super.key});

  @override
  State<ArticleInfoView> createState() => _ArticleInfoViewState();
}

class _ArticleInfoViewState extends State<ArticleInfoView> {
  final udkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ArticleTypeBloc>().add(ArticleTypeEvent());
    context.read<JournalSectionBloc>().add(JournalSectionsEvent());
  }

  @override
  void dispose() {
    udkController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.horizontal20x(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            /// TEXT AREA
            Text('Sarlavha', style: CustomTextStyles.h3half),
            SizedBox(height: 8),
            EduCustomTextAreaWg(hintText: 'Maqola sarlavhasini kiriting...'),

            SizedBox(height: 14),

            /// UDK RAQAMI
            Text('UDK', style: CustomTextStyles.h3half),
            SizedBox(height: 8),
            BlocBuilder<UdkBloc, UdkState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: .start,
                  children: [
                    AuthTextFieldWg(
                      label: 'UDK raqamini kiriting',
                      controller: udkController,
                      isTypeNum: true,
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
                      Skeletonizer(
                        enabled: true,
                        child: Text(
                          'This field is trying to find valid UDK,\nplease wait!...',
                        ),
                      ),
                    if (state is UdkLoaded &&
                        udkController.text.trim().isNotEmpty)
                      Text(state.entity.title, style: CustomTextStyles.h4),
                    if (state is UdkError) Text('Invalid UDK!'),
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
                return CustomDropDownMenuWg(
                  title: 'Maqola turi',
                  hintText: 'Turini tanlang',
                  options: loaded,
                );
              },
            ),
            SizedBox(height: 14),

            // Maqola tili
            CustomDropDownMenuWg(
              title: 'Maqolani tili',
              hintText: 'O\'zbek tili',
            ),
            SizedBox(height: 14),

            // Jurnal bolimi
            BlocBuilder<JournalSectionBloc, JournalSectionsState>(
              builder: (context, state) {
                final loaded = state is JournalSectionsLoaded
                    ? state.entity
                    : null;

                return CustomDropDownMenuWg(
                  title: 'Jurnal bo’limi',
                  hintText: 'Bo\'limni tanlang',
                  options: loaded,
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
