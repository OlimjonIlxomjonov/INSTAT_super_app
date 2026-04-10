import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/responsiveness/app_responsiveness.dart';

class MiniAppBottomNavTabItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  MiniAppBottomNavTabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class BottomNavBarCustomMiniApp extends StatefulWidget {
  final List<Widget> Function(void Function(int)) innerPageBuilder;
  final int? openPageByIndex;
  final List<MiniAppBottomNavTabItem> tabs;
  final bool Function(BuildContext, int)? onTabChangeOverride;

  const BottomNavBarCustomMiniApp({
    super.key,
    this.openPageByIndex,
    required this.tabs,
    required this.innerPageBuilder,
    this.onTabChangeOverride,
  });

  @override
  State<BottomNavBarCustomMiniApp> createState() =>
      _BottomNavBarCustomMiniAppState();
}

class _BottomNavBarCustomMiniAppState extends State<BottomNavBarCustomMiniApp> {
  late int _currentIndex;
  late List<bool> _loadedPages;
  late List<Widget> _innerPages;
  Key _navKey = UniqueKey();

  void _goToTab(int index) => setState(() {
    _currentIndex = index;
    _loadedPages[index] = true;
  });

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.openPageByIndex ?? 0;
    _loadedPages = List.generate(
      widget.tabs.length,
      (index) => index == _currentIndex,
    );
    _innerPages = widget.innerPageBuilder(_goToTab);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: List.generate(_innerPages.length, (index) {
          if (!_loadedPages[index]) return const SizedBox.shrink();
          return _innerPages[index];
        }),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(24),
            topLeft: Radius.circular(24),
          ),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -1),
              color: AppColors.greyScale.grey200,
              blurRadius: 20,
            ),
          ],
        ),
        child: SafeArea(
          child: GNav(
            key: _navKey,
            selectedIndex: _currentIndex,
            onTabChange: (newIndex) {
              if (widget.onTabChangeOverride != null &&
                  widget.onTabChangeOverride!(context, newIndex)) {
                setState(() {
                  _navKey = UniqueKey();
                });
                return;
              }
              setState(() {
                _currentIndex = newIndex;
                _loadedPages[newIndex] = true;
              });
            },
            tabBorderRadius: 12,
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 200),
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            gap: 8,
            color: AppColors.greyScale.grey600,
            activeColor: AppColors.white,
            iconSize: 24,
            tabBackgroundColor: AppColors.primaryColor,
            padding: EdgeInsets.all(appW(12)),
            tabs: List.generate(widget.tabs.length, (index) {
              final tab = widget.tabs[index];
              return GButton(
                icon: _currentIndex == index ? tab.activeIcon : tab.icon,
                text: tab.label,
              );
            }),
          ),
        ),
      ),
    );
  }
}
