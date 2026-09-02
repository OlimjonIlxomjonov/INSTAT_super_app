import 'package:flutter/material.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/tickets/show_tickets/show_tickets_entity.dart';

import '../../../../../../../core/utils/app_utils.dart';
import '../../../../../../../core/utils/widgets/app_widgets.dart';
import '../../screens_edu/components/edu_tickets/edu_tickets_chat_component.dart';
import '../tickets_status_switch_case_wg.dart';

class TicketsItemWg extends StatelessWidget {
  final ShowTicketsEntity item;

  const TicketsItemWg({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        openMiniAppSheetFamily(
          context,
          showHandler: false,
          child: EduTicketsChatComponent(ticketId: item.id),
        );
      },
      minVerticalPadding: 10,
      shape: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.greyScale.grey200),
      ),
      titleAlignment: .top,
      contentPadding: AppPadding.horizontal20x(),
      title: Text(
        item.title,
        maxLines: 1,
        overflow: .ellipsis,
        style: AppTextStyles.source.medium(fontSize: 15),
      ),
      subtitle: Text(
        item.desc,
        style: AppTextStyles.source.regular(
          fontSize: 12,
          color: AppColors.greyScale.grey600,
        ),
      ),
      trailing: ticketsStatusSwitchCase(context, TicketStatus.open),
    );
  }
}
