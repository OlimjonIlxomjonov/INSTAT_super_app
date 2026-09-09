import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';
import 'package:my_template/core/utils/general_widgets/selected_file_container/selected_file_container_wg.dart';
import 'package:my_template/core/utils/widgets/detail_tabs/detail_tabs_wg.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/sheet_drag_area_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/home/presentation/widgets/status_container_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_info_body_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_info_field_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_process_item.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_processes_tab_wg.dart';
import 'package:my_template/features/vacancy_app/features/presentation/widgets/vacancies/vacancy_details/vacancy_section_card_wg.dart';

class VacancyApplicationDetailWg extends StatefulWidget {
  const VacancyApplicationDetailWg({super.key});

  @override
  State<VacancyApplicationDetailWg> createState() =>
      _VacancyApplicationDetailWgState();
}

class _VacancyApplicationDetailWgState
    extends State<VacancyApplicationDetailWg> {
  int _selectedTab = 0;

  static const _detailDescription =
      'Ushbu maqolada O‘zbekiston iqtisodiyotining raqamlashuv jarayonlari, '
      'uning bugungi holati va kelajakdagi rivojlanish istiqbollari tahlil '
      'qilinadi. Raqamli texnologiyalarning iqtisodiy o‘sishga ta’siri va '
      'innovatsion yondashuvlar muhimligi yoritilgan. Shuningdek, sohadagi '
      'mavjud muammolar va ularni bartaraf etish bo‘yicha tavsiyalar keltirilgan.';

  static const _fields = [
    VacancyProcessField(label: 'Manzil', value: 'Shoxruh Toshpo’latov'),
    VacancyProcessField(label: 'Kontakt', value: 's.toshpulatov@example.uz'),
    VacancyProcessField(label: 'Test sanasi', value: '25.02.2026'),
    VacancyProcessField(label: 'Test vaqti', value: '13:20'),
  ];

  static const _commission = [
    VacancyCommissionMember(name: 'Afzal Pulatov', phone: '+99899 889 90 90'),
  ];

  static const _processes = [
    VacancyProcessItem(
      cycle: 1,
      title: 'Qoshimcha suhbat',
      description: '#3310 raqamli qo’lyozma taqriz uchun yuborildi.',
      date: '12:00 25.02.2026',
      detailTitle: 'Testga taklif',
      detailDescription: _detailDescription,
      fields: _fields,
      commission: _commission,
    ),
    VacancyProcessItem(
      cycle: 1,
      title: 'Suhbat',
      description: '#3310 raqamli qo’lyozma tekshirilmoqda',
      date: '13:20 25.02.2026',
      detailTitle: 'Testga taklif',
      detailDescription: _detailDescription,
      fields: _fields,
      commission: _commission,
    ),
    VacancyProcessItem(
      cycle: 1,
      title: 'Test',
      description: '#3310 raqamli qo’lyozma tekshirilmoqda',
      date: '13:20 25.02.2026',
      isDone: true,
      detailTitle: 'Testga taklif',
      detailDescription: _detailDescription,
      fields: _fields,
      commission: _commission,
    ),
    VacancyProcessItem(
      cycle: 1,
      title: 'Saralash',
      description: '#3310 raqamli qo’lyozma tekshirilmoqda',
      date: '13:20 25.02.2026',
      isDone: true,
      detailTitle: 'Testga taklif',
      detailDescription: _detailDescription,
      fields: _fields,
      commission: _commission,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          //! App Bar
          SliverToBoxAdapter(
            child: SheetDragAreaWg(
              child: CustomAppBarWg(
                myTitle: 'Ariza tafsilotlari',
                isFamily: true,
              ),
            ),
          ),

          //! Tabs
          SliverToBoxAdapter(
            child: DetailTabsWg(
              tabs: const [
                DetailTabItem(
                  label: 'Ariza ma’lumotlari',
                  icon: FlutterRemix.file_list_2_line,
                ),
                DetailTabItem(
                  label: 'Jarayonlar',
                  icon: FlutterRemix.list_check_2,
                ),
              ],
              selectedIndex: _selectedTab,
              onChanged: (index) => setState(() => _selectedTab = index),
            ),
          ),

          //! Body
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            sliver: SliverToBoxAdapter(
              child: _selectedTab == 0
                  ? _buildInfoTab()
                  : VacancyProcessesTabWg(
                      items: _processes,
                      emptyTitle: 'Jarayonlar hali boshlanmagan',
                      cycleLabel: (cycle) => '$cycle-tsikl',
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //! Sana va status
        Row(
          children: [
            Icon(
              FlutterRemix.calendar_line,
              size: 18,
              color: AppColors.greyScale.grey600,
            ),
            const SizedBox(width: 6),
            Text(
              '19.02.2025',
              style: AppTextStyles.source.medium(
                fontSize: 14,
                color: AppColors.greyScale.grey700,
              ),
            ),
            const Spacer(),
            StatusContainerWg(
              icon: FlutterRemix.loader_2_line,
              statusTitle: ' Tekshirilmoqda',
              iconColor: AppColors.orange500,
              backgroundColor: AppColors.orange50,
            ),
          ],
        ),
        const SizedBox(height: 16),

        const VacancyInfoBodyWg(),
        const SizedBox(height: 16),

        //! Shaxsiy ma’lumotlar
        VacancySectionCardWg(
          title: 'Shaxsiy ma’lumotlarim',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VacancyInfoFieldWg(
                label: 'F.I.SH.',
                value: 'Shoxruh Toshpo’latov',
              ),
              const SizedBox(height: 16),
              VacancyInfoFieldWg(label: 'Tug’ilgan sana', value: '12.01.2001'),
              const SizedBox(height: 16),
              VacancyInfoFieldWg(
                label: 'Email manzili',
                value: 's.toshpulatov@example.uz',
              ),
              const SizedBox(height: 16),
              VacancyInfoFieldWg(
                label: 'Telefon raqam',
                value: '+998 90 123 45 67',
              ),
              const SizedBox(height: 20),

              //! Hujjatlar
              VacancySectionTitleWg(title: 'Briktirilgan hujjatlar'),
              const SizedBox(height: 12),
              SelectedFileContainerWg(
                fileName: 'Tahlil, taqqoslash va prognozlash',
                fileSize: '3.4 MB',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
