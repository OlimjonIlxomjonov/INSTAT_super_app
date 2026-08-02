import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/core/utils/constants/custom_text_styles/custom_text_styles.dart';
import 'package:my_template/features/mikro_data/domain/entity/regions/region_entity.dart';

/*
Hudud tanlash: bitta bottom sheet ichida ikki bosqichli drill-down.

  1-ekran — viloyatlar ro'yxati + "Respublika bo'yicha"
  2-ekran — tanlangan viloyatning tumanlari + "Butun viloyat bo'yicha"

Qidiruv ikkala darajada ham ishlaydi: 1-ekranda yozilgan matn viloyat va
tuman nomlari bo'yicha birdan qidiradi, ya'ni foydalanuvchi tuman qaysi
viloyatda ekanini bilmasa ham topa oladi (natijada viloyat nomi izoh
sifatida ko'rsatiladi).
*/

Future<SelectedArea?> showAreaPickerSheet(
  BuildContext context, {
  required List<RegionEntity> regions,
  SelectedArea? initial,
}) {
  return showModalBottomSheet<SelectedArea>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _AreaPickerSheet(regions: regions, initial: initial),
  );
}

class _AreaPickerSheet extends StatefulWidget {
  const _AreaPickerSheet({required this.regions, this.initial});

  final List<RegionEntity> regions;
  final SelectedArea? initial;

  @override
  State<_AreaPickerSheet> createState() => _AreaPickerSheetState();
}

class _AreaPickerSheetState extends State<_AreaPickerSheet> {
  final _searchController = TextEditingController();

  RegionEntity? _openedRegion;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _localeCode => Localizations.localeOf(context).languageCode;

  void _openRegion(RegionEntity region) {
    setState(() {
      _openedRegion = region;
      _query = '';
      _searchController.clear();
    });
  }

  void _goBack() {
    setState(() {
      _openedRegion = null;
      _query = '';
      _searchController.clear();
    });
  }

  bool _matches(String value) =>
      value.toLowerCase().contains(_query.toLowerCase());

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final opened = _openedRegion;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.8,
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  if (opened != null)
                    IconButton(
                      onPressed: _goBack,
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    )
                  else
                    const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      opened?.localizedName(_localeCode) ??
                          localization.requestAreaLabel,
                      style: CustomTextStyles.h3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            /// SEARCH
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.greyScale.grey200,
                ),
                child: Row(
                  children: [
                    Icon(
                      IconlyLight.search,
                      color: AppColors.greyScale.grey600,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) => setState(() => _query = value),
                        style: AppTextStyles.source.regular(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: localization.requestSearchHint,
                          hintStyle: AppTextStyles.source.regular(
                            fontSize: 14,
                            color: AppColors.greyScale.grey500,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: opened == null
                  ? _buildRegionLevel(localization)
                  : _buildDistrictLevel(localization, opened),
            ),
          ],
        ),
      ),
    );
  }

  /// 1-daraja: viloyatlar + qidiruvda topilgan tumanlar.
  Widget _buildRegionLevel(AppLocalizations localization) {
    final selected = widget.initial;
    final searching = _query.trim().isNotEmpty;

    final regions = widget.regions
        .where((r) => !searching || _matches(r.localizedName(_localeCode)))
        .toList();

    // Qidiruvda tumanlarni ham ko'rsatamiz — foydalanuvchi viloyatni
    // bilmasdan to'g'ridan-to'g'ri tumanni topa olishi uchun.
    final districtHits = <({RegionEntity region, DistrictEntity district})>[];
    if (searching) {
      for (final region in widget.regions) {
        for (final district in region.districts) {
          if (_matches(district.localizedName(_localeCode))) {
            districtHits.add((region: region, district: district));
          }
        }
      }
    }

    if (regions.isEmpty && districtHits.isEmpty) {
      return Center(
        child: Text(localization.nothingFound, style: CustomTextStyles.h4),
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 20),
      children: [
        if (!searching) ...[
          _OptionTile(
            label: localization.requestWholeRepublic,
            isSelected: selected != null && selected.isWholeRepublic,
            onTap: () => Navigator.of(context).pop(const SelectedArea()),
          ),
          const Divider(height: 1),
        ],
        ...regions.map(
          (region) => _RegionTile(
            label: region.localizedName(_localeCode),
            onTap: () => _openRegion(region),
          ),
        ),
        ...districtHits.map(
          (hit) => _OptionTile(
            label: hit.district.localizedName(_localeCode),
            subtitle: hit.region.localizedName(_localeCode),
            isSelected: selected?.district?.code == hit.district.code,
            onTap: () => Navigator.of(
              context,
            ).pop(SelectedArea(region: hit.region, district: hit.district)),
          ),
        ),
      ],
    );
  }

  /// 2-daraja: tanlangan viloyatning tumanlari.
  Widget _buildDistrictLevel(
    AppLocalizations localization,
    RegionEntity region,
  ) {
    final selected = widget.initial;
    final districts = region.districts
        .where((d) => _matches(d.localizedName(_localeCode)))
        .toList();

    return ListView(
      padding: const EdgeInsets.only(bottom: 20),
      children: [
        if (_query.trim().isEmpty) ...[
          _OptionTile(
            label: localization.requestWholeRegion,
            isSelected:
                selected?.region?.code == region.code &&
                selected?.district == null,
            onTap: () =>
                Navigator.of(context).pop(SelectedArea(region: region)),
          ),
          const Divider(height: 1),
        ],
        if (districts.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                localization.nothingFound,
                style: CustomTextStyles.h4,
              ),
            ),
          ),
        ...districts.map(
          (district) => _OptionTile(
            label: district.localizedName(_localeCode),
            isSelected: selected?.district?.code == district.code,
            onTap: () => Navigator.of(
              context,
            ).pop(SelectedArea(region: region, district: district)),
          ),
        ),
      ],
    );
  }
}

/// Ichkariga kiradigan qator (viloyat).
class _RegionTile extends StatelessWidget {
  const _RegionTile({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(label, style: CustomTextStyles.h3half),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.greyScale.grey500,
      ),
    );
  }
}

/// Yakuniy tanlanadigan qator.
class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.subtitle,
  });

  final String label;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(label, style: CustomTextStyles.h3half),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: AppTextStyles.source.regular(
                fontSize: 12,
                color: AppColors.greyScale.grey500,
              ),
            ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primaryColor)
          : Icon(Icons.circle_outlined, color: AppColors.greyScale.grey300),
    );
  }
}
