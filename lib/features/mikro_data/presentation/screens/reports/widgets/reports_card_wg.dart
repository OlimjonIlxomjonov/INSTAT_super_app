import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_event.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/reports/reports_bloc.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/reports/reports_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/utils/app_utils.dart';

class ReportsCardWg extends StatefulWidget {
  const ReportsCardWg({super.key});

  @override
  State<ReportsCardWg> createState() => _ReportsCardWgState();
}

class _ReportsCardWgState extends State<ReportsCardWg> {
  @override
  void initState() {
    super.initState();
    context.read<ReportsBloc>().add(ReportsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: AppPadding.horizontal20x(),
      sliver: SliverFillRemaining(
        child: BlocBuilder<ReportsBloc, ReportsState>(
          builder: (context, state) {
            if (state is ReportsLoaded) {
              final data = state.response.data;
              return GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];
                  return Container(
                    padding: const .all(12),
                    decoration: BoxDecoration(
                      borderRadius: .circular(16),
                      color: AppColors.greyScale.grey50,
                    ),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          item.category.nameUz,
                          style: AppTextStyles.source.medium(
                            fontSize: 12,
                            color: AppColors.splashBackgroundColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.name,
                          maxLines: 2,
                          overflow: .ellipsis,
                          style: AppTextStyles.source.medium(fontSize: 14),
                        ),
                        Spacer(),
                        _buildSectionRows(
                          icon: IconlyLight.location,
                          title: 'O‘zbekiston Respublikasi',
                        ),
                        const SizedBox(height: 4),
                        _buildSectionRows(
                          icon: IconlyLight.time_circle,
                          title: '2021–2024',
                        ),
                        const SizedBox(height: 4),
                        _buildSectionRows(
                          icon: IconlyLight.document,
                          title: 'Ecxel/PDF — 130MB',
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return Skeletonizer(
              enabled: true,
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const .all(12),
                    decoration: BoxDecoration(
                      borderRadius: .circular(16),
                      color: AppColors.greyScale.grey50,
                    ),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          'Category Name',
                          style: AppTextStyles.source.medium(
                            fontSize: 12,
                            color: AppColors.splashBackgroundColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Aholi sonining yosh bo‘yicha taqsimoti',
                          maxLines: 2,
                          overflow: .ellipsis,
                          style: AppTextStyles.source.medium(fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        _buildSectionRows(
                          icon: IconlyLight.location,
                          title: 'O‘zbekiston Respublikasi',
                        ),
                        const SizedBox(height: 4),
                        _buildSectionRows(
                          icon: IconlyLight.time_circle,
                          title: '2021–2024',
                        ),
                        const SizedBox(height: 4),
                        _buildSectionRows(
                          icon: IconlyLight.document,
                          title: 'Ecxel/PDF — 130MB',
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionRows({required IconData icon, required String title}) {
    return Row(
      spacing: 8,
      children: [
        Icon(icon, color: AppColors.greyScale.grey600, size: 20),
        Expanded(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.source.regular(
              fontSize: 12,
              color: AppColors.greyScale.grey600,
            ),
          ),
        ),
      ],
    );
  }
}
