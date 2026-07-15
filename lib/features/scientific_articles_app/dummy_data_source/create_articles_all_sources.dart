import 'package:my_template/core/l10n/app_localizations.dart';

List<String> getWizardTitles(AppLocalizations localization) => [
  localization.wizardStepNewArticle,
  localization.wizardStepAuthorInfo,
  localization.wizardStepSubmitArticle,
  localization.wizardStepUploadFiles,
  localization.wizardStepReviewSubmit,
];

List<String> getWizardStepsDesc(AppLocalizations localization) => [
  localization.wizardDescBasicInfo,
  localization.wizardDescAuthorInfo,
  localization.wizardDescAnnotationKeywords,
  localization.wizardStepUploadFiles,
  localization.wizardDescReviewBeforeFinish,
];

List<String> getArticlesHeaderData(AppLocalizations localization) => [
  localization.wizardHeaderArticleInfo,
  localization.wizardHeaderAddAuthor,
  localization.wizardHeaderArticleInfo,
  localization.wizardHeaderMainFile,
  localization.wizardHeaderSummary,
];
