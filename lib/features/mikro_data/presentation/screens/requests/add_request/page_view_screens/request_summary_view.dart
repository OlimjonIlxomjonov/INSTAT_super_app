import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/utils/app_utils.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/add_data_request/add_data_request_bloc.dart';
import 'package:my_template/features/mikro_data/presentation/bloc/add_data_request/add_data_request_state.dart';
import 'package:my_template/features/mikro_data/presentation/screens/requests/add_request/request_file_opener.dart';
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
                RequestSummaryBodyWg(
                  data: state.toSummaryData(),
                  onFileTap: () => openRequestFile(
                    context,
                    url: state.fileUrl,
                    fileName: state.fileName,
                  ),
                  onCompanyFileTap: () => openRequestFile(
                    context,
                    url: state.companyFileUrl,
                    fileName: state.companyFileName,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            );
          },
        ),
      ),
    );
  }
}

extension SummaryMapping on AddDataRequestState {
  DataRequestSummaryData toSummaryData() {
    return DataRequestSummaryData(
      id: requestId,
      companyName: companyName,
      fullName: fullName,
      phoneNumber: phoneNumber,
      email: email,
      teamMembers: teamMembers,
      projectName: projectName,
      projectAim: projectAim,
      benefit: benefit,
      aimToUse: aimToUse,
      dataReportName: dataReport?.name ?? '',
      dateFrom: dateFrom,
      dateTo: dateTo,
      whyNotEnough: whyNotEnough,
      notEnoughComment: notEnoughComment,
      processingEnvironment: processingEnvironmentName,
      entryDateFrom: entryDateFrom,
      entryDateTo: entryDateTo,
      expectation: expectation,
      plan: plan,
      hasFile: hasFile,
      fileName: fileName,
      fileSize: fileSize,
      hasCompanyFile: hasCompanyFile,
      companyFileName: companyFileName,
      companyFileSize: companyFileSize,
    );
  }
}
