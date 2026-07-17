import 'package:flutter/cupertino.dart';
import 'package:my_template/features/education_app/features/home_edu/domain/entity/comments/comments_entity.dart';

import '../../constants/textstyles/app_text_style.dart';
import '../open_mini_app/sub_bottom_sheet_opener.dart';

void extendCommentWg(BuildContext context, CommentsEntity item) {
  subBottomSheetOpener(
    context,
    child: ConstrainedBox(
      constraints: BoxConstraints(minWidth: double.infinity, minHeight: 120),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Text(
          item.text,
          style: AppTextStyles.source.regular(fontSize: 14),
        ),
      ),
    ),
    isExpanded: false,
  );
}
