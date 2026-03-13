import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:turn_page_transition/turn_page_transition.dart';

/// WITH PACKAGE
class BoughtBookOpenerWg extends StatefulWidget {
  const BoughtBookOpenerWg({super.key});

  @override
  State<BoughtBookOpenerWg> createState() => _BoughtBookOpenerWgState();
}

class _BoughtBookOpenerWgState extends State<BoughtBookOpenerWg> {
  final List<Widget> pages = [
    Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFFFFBF0), Color(0xFFF3EFE3)],
        ),
      ),
      child: const Center(
        child: Text("Page 1", style: TextStyle(fontSize: 40)),
      ),
    ),
    Container(
      color: Colors.white,
      child: const Center(
        child: Text("Page 2", style: TextStyle(fontSize: 40)),
      ),
    ),
    Container(
      color: Colors.white,
      child: const Center(
        child: Text("Page 3", style: TextStyle(fontSize: 40)),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TurnPageView.builder(
        animationTransitionPoint: .35,
        overleafColorBuilder: (index) => AppColors.greyScale.grey400,
        overleafBorderColorBuilder: (index) => AppColors.greyScale.grey700,
        overleafBorderWidthBuilder: (index) => 1,
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return pages[index];
        },
      ),
    );
  }
}
