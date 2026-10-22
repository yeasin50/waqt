import '../core.dart' show AppNotifier, AppVisiblityCreator, AppVisiblityInfo;

import 'package:collection/collection.dart';

/// All  the AppVisiblity config will be handled from  here
/// this is specially used to store config from  [AppVisiblityCreator] and show on ui
mixin AppVisibilityProviderMixin on AppNotifier {
  void updateVibilityConfig(AppVisiblityInfo info) {
    db.updateVisiblity(info);
    final app = apps.toList().firstWhereOrNull(
      (e) => e.packageName == info.packageName,
    );

    if (app == null) return;

    final temp = app.copyWith(visiblityInfo: info);
    removeApp(app);
    addApp(temp);
    notifyListeners();
  }
}
