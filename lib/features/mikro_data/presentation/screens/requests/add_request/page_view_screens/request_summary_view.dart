import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/add_data_request/add_data_request_bloc.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/add_data_request/add_data_request_state.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/widgets/request_summary_body_wg.dart';

class RequestSummaryView extends StatelessWidget {
  const RequestSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.horizontal20x(),
      child: SingleChildScrollView(
        child: BlocBuilder<AddDataRequestBloc, AddDataRequestState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RequestSummaryBodyWg(data: state.toSummaryData()),
                const SizedBox(height: 30),
              ],
            );
          },
        ),
      ),
    );
  }
}

extension _SummaryMapping on AddDataRequestState {
  DataRequestSummaryData toSummaryData() {
    return DataRequestSummaryData(
      id: requestId,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      companyName: companyName,
      category: category,
      area: area,
      dateFrom: dateFrom,
      dateTo: dateTo,
      description: description,
      aim: aim,
      hasFile: hasFile,
      fileName: fileName,
      fileSize: fileSize,
    );
  }
}
