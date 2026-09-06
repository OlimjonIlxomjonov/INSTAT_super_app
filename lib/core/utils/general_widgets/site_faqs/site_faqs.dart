import 'package:flutter/material.dart';
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
                child: CustomAppBarWg(myTitle: 'Ko’p beriladigan savollar'),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              sliver: SliverToBoxAdapter(child: AppSearchbarWg()),
            ),
            BlocBuilder<SiteFaqsBloc, SiteFaqsState>(
              builder: (context, state) {
                final isLoading = state is! SiteFaqsLoaded;
                final data = isLoading ? _fakeFaqItems : state.listEntity;

                if (data.isEmpty) {
                  return SliverToBoxAdapter(
                    child: AppEmptyState(
                      title: 'Savollar mavjud emas',
                      subtitle: "Iltimos, keyinroq qayta urinib ko'ring",
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
                                        item.questionUz,
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
                            AnimatedCrossFade(
                              firstChild: const SizedBox.shrink(),
                              secondChild: Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  item.answerUz,
                                  style: AppTextStyles.source.regular(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              crossFadeState: isOpen
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              duration: const Duration(milliseconds: 200),
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
