import 'package:flutter/material.dart';
import 'package:my_template/core/common/ui_states/section_error_wg.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/params/edu_params/params.dart';
import 'package:my_template/core/common/refresh_indicator/custom_refresh_insidcator.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/widgets/app_widgets.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/features/main_app/home/domain/entity/site_faqs/site_faqs_entity.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/home_event.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/site_faqs/site_faqs_bloc.dart';
import 'package:my_template/features/main_app/home/presentation/bloc/site_faqs/site_faqs_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SiteFaqsWg extends StatefulWidget {
  final String module;

  const SiteFaqsWg({super.key, required this.module});

  @override
  State<SiteFaqsWg> createState() => _SiteFaqsWgState();
}

class _SiteFaqsWgState extends State<SiteFaqsWg> {
  int? _openIndex;

  @override
  void initState() {
    super.initState();
    context.read<SiteFaqsBloc>().add(
      SiteFaqsEvent(params: SiteFaqsParams(module: widget.module)),
    );
  }

  final _fakeFaqItems = List.generate(
    6,
    (i) => SiteFaqsEntity(
      id: i,
      questionUz: 'This is a placeholder question that wraps',
      answerUz: 'This is a placeholder answer line to size the skeleton bone',
      questionRu: '',
      questionEn: '',
      answerRu: '',
      answerEn: '',
      module: '',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomRefreshIndicator(
        onRefresh: () async {
          context.read<SiteFaqsBloc>().add(
            SiteFaqsEvent(params: SiteFaqsParams(module: widget.module)),
          );
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              titleSpacing: 0,
              automaticallyImplyLeading: false,
              title: SheetDragAreaWg(
                child: CustomAppBarWg(
                  myTitle: AppLocalizations.of(context)!.faqTitle,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              sliver: SliverToBoxAdapter(child: AppSearchbarWg()),
            ),
            BlocBuilder<SiteFaqsBloc, SiteFaqsState>(
              builder: (context, state) {
                if (state is SiteFaqsError) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: SectionErrorWg(
                        title: state.message,
                        onRetry: () => context.read<SiteFaqsBloc>().add(
                          SiteFaqsEvent(
                            params: SiteFaqsParams(module: widget.module),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                final isLoading = state is! SiteFaqsLoaded;
                final data = isLoading ? _fakeFaqItems : state.listEntity;

                if (data.isEmpty) {
                  return SliverToBoxAdapter(
                    child: AppEmptyState(
                      title: AppLocalizations.of(context)!.faqEmptyTitle,
                      subtitle: AppLocalizations.of(context)!.faqEmptySubtitle,
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: Skeletonizer.sliver(
                    enabled: isLoading,
                    child: SliverList.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        final isOpen = _openIndex == index;
                        final localeCode = Localizations.localeOf(
                          context,
                        ).languageCode;

                        return Column(
                          children: [
                            InkWell(
                              onTap: isLoading
                                  ? null
                                  : () {
                                      setState(() {
                                        _openIndex = isOpen ? null : index;
                                      });
                                    },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.displayQuestion(localeCode),
                                        style: AppTextStyles.source.medium(
                                          fontSize: 15,
                                          color: isOpen
                                              ? AppColors.primaryColor
                                              : AppColors.greyScale.grey600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    AnimatedRotation(
                                      turns: isOpen ? 0.5 : 0,
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: isOpen
                                            ? AppColors.primaryColor
                                            : AppColors.greyScale.grey600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //! Javob ochilishi
                            _FaqAnswer(
                              isOpen: isOpen,
                              text: item.displayAnswer(localeCode),
                            ),
                            Divider(
                              height: 1,
                              color: AppColors.greyScale.grey200,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Javob tepadan pastga ochiladi: balandlik o'sadi, matn esa
/// ozgina sirg'alib paydo bo'ladi.
class _FaqAnswer extends StatelessWidget {
  final bool isOpen;
  final String text;

  const _FaqAnswer({required this.isOpen, required this.text});

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: ClipRect(
        child: Align(
          alignment: Alignment.topCenter,
          heightFactor: isOpen ? 1 : 0,
          child: AnimatedOpacity(
            opacity: isOpen ? 1 : 0,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            child: AnimatedSlide(
              offset: isOpen ? Offset.zero : const Offset(0, -0.08),
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  text,
                  style: AppTextStyles.source.regular(
                    fontSize: 14,
                    color: AppColors.greyScale.grey700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
