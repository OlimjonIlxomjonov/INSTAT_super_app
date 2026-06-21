import 'package:flutter/material.dart';
import 'package:my_template/core/utils/general_widgets/custom_app_bar/custom_app_bar_wg.dart';

class MicroDataRequets extends StatelessWidget {
  const MicroDataRequets({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWg(myTitle: 'Mening so‘rovlarim', showArrow: false),
    );
  }
}
