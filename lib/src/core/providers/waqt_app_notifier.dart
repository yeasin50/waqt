import '../core.dart';
import 'app_filters.dart';
import 'app_visibility_provider_mixin.dart';
import 'error_handler_mixin.dart';
import 'screen_lock_provider_mixin.dart';

class WaqtAppNotifier extends AppNotifier
    with
        ScreenLockProviderMixin,
        AppVisibilityProviderMixin,
        UserPreferenceProvider,
        AppFilters,
        ErrorHandlerMixin {
  //...
  WaqtAppNotifier(
    AppDatabase _db,
    AppService service, {
    required super.screenLockApi,
    required super.appManagerApi,
  }) : super(_db, service) {
    checkLockPermission();
    checkIfDefaultLauncher();
  }
}
