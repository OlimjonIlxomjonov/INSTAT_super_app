import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/flush_bar/flush_bars.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/core/utils/general_widgets/custom_drop_down_menu_wg.dart';
import 'package:my_template/features/education_app/features/user_profile_edu/presentation_edu/widgets_edu/edu_custom_text_area_wg.dart';
import 'package:my_template/features/mikro_data/domain/entity/data_requests/data_request_category_entity.dart';
import 'package:my_template/features/mikro_data/domain/entity/regions/region_entity.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/add_data_request/add_data_request_bloc.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/add_data_request/add_data_request_state.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_categories/micro_data_categories_bloc.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_event.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/regions/regions_bloc.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/request_formatters.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/widgets/area_picker_sheet.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/widgets/date_picker_sheet.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/widgets/picker_field_wg.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/widgets/request_file_section_wg.dart';
import 'package:my_template/features/scientific_articles_app/features/home/domain/entity/add_article/drop_down/drop_down_entity.dart';

class RequestDetailsView extends StatefulWidget {
  const RequestDetailsView({super.key});

  @override
  State<RequestDetailsView> createState() => _RequestDetailsViewState();
}

class _RequestDetailsViewState extends State<RequestDetailsView> {
  final _descriptionController = TextEditingController();
  final _aimController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = context.read<AddDataRequestBloc>().state;
    _descriptionController.text = state.description;
    _aimController.text = state.aim;
    // Kategoriya/hudud ro'yxatlari wizard ochilganda bir marta yuklanadi
    // (AddDataRequestPage) — bu yerdan chaqirilsa, PageView bu sahifani
    // har safar qayta yaratgani uchun so'rovlar takrorlanib ketardi.
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _aimController.dispose();
    super.dispose();
  }

  String get _localeCode => Localizations.localeOf(context).languageCode;

  void _update(UpdateDataRequestFieldEvent event) {
    context.read<AddDataRequestBloc>().add(event);
  }

  /// Tanlangan hududni matnga aylantiradi: respublika / viloyat / tuman.
  String? _areaLabel(SelectedArea? area, AppLocalizations localization) {
    if (area == null) return null;
    if (area.isWholeRepublic) return localization.requestWholeRepublic;
    final regionName = area.region!.localizedName(_localeCode);
    final district = area.district;
    if (district == null) return regionName;
    return '$regionName, ${district.localizedName(_localeCode)}';
  }

  Future<void> _pickArea() async {
    final localization = AppLocalizations.of(context)!;
    final regionsState = context.read<RegionsBloc>().state;

    if (regionsState is! RegionsLoaded) {
      // Hali yuklanmagan yoki xato — qayta urinamiz va foydalanuvchini
      // bo'sh ro'yxat bilan qoldirmaymiz.
      context.read<RegionsBloc>().add(const RegionsEvent());
      technicalWorkFlushBar(context, localization.savingEllipsis);
      return;
    }

    final selected = await showAreaPickerSheet(
      context,
      regions: regionsState.items,
      initial: context.read<AddDataRequestBloc>().state.area,
    );
    if (selected == null || !mounted) return;
    _update(UpdateDataRequestFieldEvent(area: selected));
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final localization = AppLocalizations.of(context)!;
    final state = context.read<AddDataRequestBloc>().state;

    final picked = await showDatePickerSheet(
      context,
      title: isFrom
          ? localization.requestStartDateTitle
          : localization.requestEndDateTitle,
      initialDate: isFrom ? state.dateFrom : (state.dateTo ?? state.dateFrom),
      // Tugash sanasi boshlanishdan oldin bo'la olmaydi.
      firstDate: isFrom ? null : state.dateFrom,
    );
    if (picked == null || !mounted) return;

    if (isFrom) {
      _update(UpdateDataRequestFieldEvent(dateFrom: picked));
      // Boshlanish sanasi tugashdan keyinga surilsa, tugashni ham surib
      // qo'yamiz — aks holda yaroqsiz davr qolib ketardi.
      final currentTo = context.read<AddDataRequestBloc>().state.dateTo;
      if (currentTo != null && currentTo.isBefore(picked)) {
        _update(UpdateDataRequestFieldEvent(dateTo: picked));
      }
    } else {
      _update(UpdateDataRequestFieldEvent(dateTo: picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Padding(
      padding: AppPadding.horizontal20x(),
      child: SingleChildScrollView(
        child: BlocBuilder<AddDataRequestBloc, AddDataRequestState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// KATEGORIYA
                BlocBuilder<MicroDataCategoriesBloc, MicroDataCategoriesState>(
                  builder: (context, catState) {
                    final categories = catState is MicroDataCategoriesLoaded
                        ? catState.items
                        : const <DataRequestCategoryEntity>[];

                    return CustomDropDownMenuWg(
                      title: localization.requestCategoryLabel,
                      hintText: localization.requestCategoryHint,
                      options: categories.isEmpty
                          ? null
                          : categories
                                .map(
                                  (c) => DropDownEntity(
                                    id: c.id,
                                    name: c.localizedName(_localeCode),
                                    isActive: true,
                                    createdAt: c.createdAt ?? DateTime.now(),
                                  ),
                                )
                                .toList(),
                      value: state.categoryId,
                      onChanged: (value) {
                        if (value == null) return;
                        // Dropdown faqat id beradi, backend esa to'liq
                        // obyektni kutadi — ro'yxatdan topib uzatamiz.
                        for (final category in categories) {
                          if (category.id == value) {
                            _update(
                              UpdateDataRequestFieldEvent(category: category),
                            );
                            return;
                          }
                        }
                      },
                    );
                  },
                ),
                const SizedBox(height: 14),

                /// HUDUD
                PickerFieldWg(
                  title: localization.requestAreaLabel,
                  hintText: localization.requestAreaHint,
                  value: _areaLabel(state.area, localization),
                  isRequired: true,
                  onTap: _pickArea,
                ),
                const SizedBox(height: 14),

                /// SO'ROV TAVSIFI
                Text(
                  localization.requestDescriptionLabel,
                  style: CustomTextStyles.h3half,
                ),
                const SizedBox(height: 8),
                EduCustomTextAreaWg(
                  hintText: localization.requestDescriptionHint,
                  controller: _descriptionController,
                  onChanged: (value) =>
                      _update(UpdateDataRequestFieldEvent(description: value)),
                ),
                const SizedBox(height: 14),

                /// SO'ROV MAQSADI — tavsif bilan bir xil dizayn, limitsiz
                Text(
                  localization.requestAimLabel,
                  style: CustomTextStyles.h3half,
                ),
                const SizedBox(height: 8),
                EduCustomTextAreaWg(
                  hintText: localization.requestAimHint,
                  controller: _aimController,
                  onChanged: (value) =>
                      _update(UpdateDataRequestFieldEvent(aim: value)),
                ),
                const SizedBox(height: 14),

                /// DAVR
                Row(
                  children: [
                    Text(
                      localization.requestPeriodLabel,
                      style: CustomTextStyles.h3half,
                    ),
                    Text(
                      ' *',
                      style: CustomTextStyles.h3half.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: PickerFieldWg(
                        hintText: localization.requestDateFromHint,
                        value: formatRequestDate(state.dateFrom),
                        leadingIcon: Icons.calendar_today_outlined,
                        onTap: () => _pickDate(isFrom: true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PickerFieldWg(
                        hintText: localization.requestDateToHint,
                        value: formatRequestDate(state.dateTo),
                        leadingIcon: Icons.calendar_today_outlined,
                        onTap: () => _pickDate(isFrom: false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                /// FAYL
                const RequestFileSectionWg(),

                const SizedBox(height: 30),
              ],
            );
          },
        ),
      ),
    );
  }
}
