import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/common/skeletonizer_shimmer/data_requests/data_requests_skeletonizer.dart';
import 'package:my_template/core/common/ui_states/app_empty_state.dart';
import 'package:my_template/core/common/ui_states/error_page.dart';
import 'package:my_template/core/di/service_locator.dart';
import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/widgets/open_mini_app/open_mini_app_package_family.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/data_requests/data_requests_bloc.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/data_requests/data_requests_state.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/micro_data_event.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/add_data_request_page.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/widgets/sliver_data_requests_list_wg.dart';

class UserRequestsWithBlocWg extends StatelessWidget {
  const UserRequestsWithBlocWg({super.key, this.limit});

  final int? limit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DataRequestsBloc>(
      create: (_) =>
          sl<DataRequestsBloc>()
            ..add(const DataRequestsEvent(status: '', search: '')),
      child: _UserRequestsSliver(limit: limit),
    );
  }
}

class _UserRequestsSliver extends StatelessWidget {
  const _UserRequestsSliver({this.limit});

  final int? limit;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return BlocBuilder<DataRequestsBloc, DataRequestsState>(
      builder: (context, state) {
        if (state is DataRequestsLoaded) {
          final data = state.response.data;

          if (data.isEmpty) {
            return SliverToBoxAdapter(
              child: AppEmptyState(
                title: localization.noRequestsTitle,
                subtitle: localization.noRequestsSubtitle,
              ),
            );
          }

          final displayed = limit != null ? data.take(limit!).toList() : data;

          return SliverDataRequestsListWg(
            items: displayed,
            onRequestUpdated: () => context.read<DataRequestsBloc>().add(
              const DataRequestsEvent(status: '', search: ''),
            ),
          );
        }

        if (state is DataRequestsError) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: SizedBox(height: 150, child: ErrorPage()),
              ),
            ),
          );
        }

        return DataRequestsSkeletonizer(itemCount: limit ?? 3);
      },
    );
  }
}
