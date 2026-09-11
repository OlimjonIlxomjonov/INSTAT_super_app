import 'package:my_template/core/l10n/app_localizations.dart';
import 'package:my_template/core/utils/enums/app_enums.dart';

String lessonTestErrorText(
  AppLocalizations localization,
  LessonTestErrorKind kind,
  String message,
) {
  switch (kind) {
    case LessonTestErrorKind.faceNotFound:
      return localization.faceNotFoundError;
    case LessonTestErrorKind.faceNotVerified:
      return localization.faceNotVerifiedError;
    case LessonTestErrorKind.server:
      return localization.serverErrorWithCode(message);
    case LessonTestErrorKind.unknown:
      return message.isNotEmpty
          ? message
          : localization.somethingWentWrongTryAgain;
  }
}
