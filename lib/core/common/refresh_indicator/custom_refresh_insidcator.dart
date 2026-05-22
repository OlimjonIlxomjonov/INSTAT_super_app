import 'package:flutter/material.dart';
import 'package:my_template/core/utils/constants/colors/app_colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomRefreshIndicator extends StatefulWidget {
  final Widget child;
  final RefreshCallback onRefresh;

  const CustomRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  State<CustomRefreshIndicator> createState() => _CustomRefreshIndicatorState();
}

class _CustomRefreshIndicatorState extends State<CustomRefreshIndicator> {
  late final RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    try {
      await widget.onRefresh();
      _refreshController.refreshCompleted();
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      header: WaterDropMaterialHeader(
        color: AppColors.primaryColor,
        backgroundColor: AppColors.white,
      ),
      controller: _refreshController,
      onRefresh: _handleRefresh,
      child: widget.child,
    );
  }
}
