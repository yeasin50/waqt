import 'app_notifier.dart';

/// All  the AppVisiblity config will be handled from  here
/// this is specially used to store config from  [AppVisiblityCreator] and show on ui
mixin ErrorHandlerMixin on AppNotifier {
  void handleError() {
    setErr("");
    //TODO: Let's observe and then gonna decide
  }
}
