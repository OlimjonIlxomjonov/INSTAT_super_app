import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:my_template/core/utils/constants/textstyles/app_text_style.dart';
import 'package:page_flip/page_flip.dart';
// import 'package:turnable_page/turnable_page.dart';

class BoughtBookOpenerWg extends StatefulWidget {
  const BoughtBookOpenerWg({super.key});

  @override
  State<BoughtBookOpenerWg> createState() => _BoughtBookOpenerWgState();
}

class _BoughtBookOpenerWgState extends State<BoughtBookOpenerWg> {
  final _controller = GlobalKey<PageFlipWidgetState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PageFlipWidget(
          key: _controller,
          backgroundColor: Colors.white,
          lastPage: Container(
            color: Colors.white,
            child: const Center(child: Text('Last Page!')),
          ),
          children: List.generate(
            10,
            (index) => Center(child: PlaceHolderBookInner(index: index)),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.navigate_next_outlined),
        onPressed: () {
          _controller.currentState?.nextPage();
        },
      ),
    );
  }
}

class PlaceHolderBookInner extends StatelessWidget {
  final int index;

  const PlaceHolderBookInner({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(height: 40),
          Text('Title $index', style: AppTextStyles.source.bold(fontSize: 20)),
          SizedBox(height: 10),
          Text('Sub Title', style: AppTextStyles.source.semiBold(fontSize: 18)),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: .start,
            children: [
              Expanded(
                child: Text(
                  'lit, sed do eiusmod tempor lat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                ),
              ),
              Expanded(
                child: Container(
                  height: 200,
                  color: AppColors.greyScale.grey600,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
          ),
          SizedBox(height: 10),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
          ),
        ],
      ),
    );
  }
}
