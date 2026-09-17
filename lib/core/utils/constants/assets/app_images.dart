abstract class AppImages {
  // Base params
  static const basePath = 'assets/images/';
  static const baseOnboardingPath = 'assets/onboarding_images/';
  static const format = '.png';

  // baseHome params
  static const baseHomePath = 'assets/home_page/';

  // onboarding
  static const firstOnboarding = '${baseOnboardingPath}online_edu_onboarding$format';
  static const secondOnboarding = '${baseOnboardingPath}library_onboarding$format';
  static const thirdOnboarding = '${baseOnboardingPath}articles_onboarding$format';
  static const fourthOnboarding = '${baseOnboardingPath}micro_data_onboarding$format';
  static const fifthOnboarding = '${baseOnboardingPath}vacancy_onboarding$format';

  /// HOME PAGE

  // mini app section surface images
  static const onlineEdu = "${baseHomePath}online_talim_section.png";
  static const bookSection = "${baseHomePath}online_lib_section.png";
  static const mikroMalumotlar = "${baseHomePath}hr_section.png";
  static const elektronJurnal = "${baseHomePath}electron_jurnal_section.png";
  static const ilmiyMaqola = '${baseHomePath}maqolalar_section.png';

  /// finished the lesson test
  static const profileBackground = "${basePath}profile_background.png";

  /// payment method logos
  static const clickPayment = "${basePath}click_logo.png";
  static const paymePayment = "${basePath}payme_logo.png";
}
