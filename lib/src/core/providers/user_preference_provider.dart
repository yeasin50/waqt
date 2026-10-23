import '../core.dart' show AppNotifier;
import '../models/user_preference.dart';

/// handles user settings for  [AppNotifier] which  directly interact with db
mixin UserPreferenceProvider on AppNotifier {
  late UserPreference _preference = db.preference();
  UserPreference get preference => _preference;

  void updatePreference(UserPreference pref) {
    _preference = pref;
    notifyListeners();
  }

  void toggleDoubleTapLoc(bool enable) {
    final updateValue = preference.copyWith(enableDoubleTapLock: enable);
    db.updatePreference(updateValue);
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
}
