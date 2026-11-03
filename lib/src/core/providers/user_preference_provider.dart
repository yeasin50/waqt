import '../core.dart' show AppNotifier;
import '../models/user_preference.dart';

/// handles user settings for  [AppNotifier] which  directly interact with db
mixin UserPreferenceProvider on AppNotifier {
  late UserPreference _preference = db.preference();
  UserPreference get preference => _preference;

  void updatePreference(UserPreference pref) {
    _preference = pref;
    db.updatePreference(pref);
    notifyListeners();
  }

  void updateAppearance({
    String? theme,
    String? language,
    bool? useSystemFont,
    String? customFont,
    int? itemSpacing,
    int? fontSize,
    bool? showClock,
    int? clockAlignment,
    bool? isLargeClock,
    bool? showDate,
    int? appsNameAlignment,
  }) {
    AppearanceSetting appearance = preference.appearance.copyWith();
    final updateValue = appearance.copyWith(
      language: language ?? appearance.language,
      theme: theme ?? appearance.theme,
      useSystemFont: useSystemFont ?? appearance.useSystemFont,
      customFont: customFont ?? appearance.customFont,
      itemSpacing: itemSpacing ?? appearance.itemSpacing,
      fontSize: fontSize ?? appearance.fontSize,
      showClock: showClock ?? appearance.showClock,
      clockAlignment: clockAlignment ?? appearance.clockAlignment,
      isLargeClock: isLargeClock ?? appearance.isLargeClock,
      showDate: showDate ?? appearance.showDate,
      appsNameAlignment: appsNameAlignment ?? appearance.appsNameAlignment,
    );

    _preference = _preference.copyWith(appearance: updateValue);
    db.updatePreference(_preference);
    notifyListeners();
  }

  void updateSearch(SearchConfigs pref) {
    updatePreference(preference.copyWith(search: pref));
  }

  void toggleDoubleTapLoc(bool enable) {
    final updateValue = preference.copyWith(enableDoubleTapLock: enable);
    updatePreference(updateValue);
  }

  bool _isDefaultLaucher = false;
  bool get isDefaultLauncher => _isDefaultLaucher;

  Future<void> checkIfDefaultLauncher() async {
    _isDefaultLaucher = await appManagerApi.isDefaultLauncher();
    notifyListeners();
  }

  Future<void> requestDefaultLauncher() async {
    await appManagerApi.requestDefaultLauncher();
  }

  // ISSUE #22  FIXME: NOT SMOOTH +  toggle initial value
  void _toggleStatusBar(bool show) {
    throw UnimplementedError();
  }
}
