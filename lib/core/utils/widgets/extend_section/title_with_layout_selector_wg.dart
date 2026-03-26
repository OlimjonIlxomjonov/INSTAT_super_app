import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:my_template/core/services/layout/layout_prefs_service.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class TitleWithLayoutSelectorWg extends StatefulWidget {
  final String prefsKey;
  final ValueChanged<CoursesLayout> onChanged;

  const TitleWithLayoutSelectorWg({
    super.key,
    required this.onChanged,
    required this.prefsKey,
  });

  @override
  State<TitleWithLayoutSelectorWg> createState() =>
      _TitleWithLayoutSelectorWgState();
}

class _TitleWithLayoutSelectorWgState extends State<TitleWithLayoutSelectorWg> {
  CoursesLayout layout = CoursesLayout.grid;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final saved = await LayoutPrefsService.load(widget.prefsKey);
    setState(() => layout = saved);
    widget.onChanged(saved);
  }

  Future<void> _onTap(CoursesLayout newLayout) async {
    await LayoutPrefsService.save(widget.prefsKey, newLayout);
    setState(() => layout = newLayout);
    widget.onChanged(newLayout);
  }

  bool get isGrid => layout == CoursesLayout.grid;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: .center,
      mainAxisAlignment: .spaceBetween,
      children: [
        Text('Kurslar', style: AppTextStyles.source.semiBold(fontSize: 18)),
        Container(
          margin: const .symmetric(vertical: 10),
          padding: .all(4),
          decoration: BoxDecoration(
            borderRadius: .circular(10),
            color: AppColors.greyScale.grey50,
          ),
          child: Row(
            children: [
              _LayoutBtn(
                selected: isGrid,
                icon: IconlyLight.category,
                onTap: () => _onTap(CoursesLayout.grid),
              ),
              _LayoutBtn(
                selected: !isGrid,
                icon: Icons.list_alt,
                onTap: () => _onTap(CoursesLayout.list),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LayoutBtn extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final VoidCallback onTap;

  const _LayoutBtn({
    required this.selected,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: selected ? AppColors.primaryColor : Colors.transparent,
        foregroundColor: selected
            ? AppColors.white
            : AppColors.greyScale.grey400,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }
}
