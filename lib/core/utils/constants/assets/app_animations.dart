class AppAnimations {
  AppAnimations._();

  static const _path = 'assets/animation/';

  static const trophyAnimation = '${_path}Trophy.json';
  static const successCheck = '${_path}success_check.json';

  /// states
  static const emptyState = '${_path}empty_ghost.json'; // _state
  static const lostInternetConnectionState = '${_path}no_internet.json';
  static const errorState = '${_path}explanation_alert_error.json';
}
