import '../models/app_info.dart';
import 'app_notifier.dart';

/// TODO: it will be better to split as separate notifier with ProxyProvider
mixin AppFilters on AppNotifier {
  late List<AppInfo> _filteredApps = [];
  List<AppInfo> get filteredApps => _filteredApps;

  void onSearch(String query) {
    if (query.trim().isEmpty) {
      _filteredApps = apps.toList();
    } else {
      _filteredApps = apps
          .where((e) => e.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<void> refresh() async {
    await getApps();
    onSearch("");
  }
}
