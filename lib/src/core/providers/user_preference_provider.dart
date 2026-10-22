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
}
