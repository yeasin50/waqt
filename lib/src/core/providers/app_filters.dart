import 'package:diacritic/diacritic.dart';

import '../models/app_info.dart';
import 'app_notifier.dart';

/// TODO: it will be better to split as separate notifier with ProxyProvider
mixin AppFilters on AppNotifier {
  late List<AppInfo> _filteredApps = [];
  List<AppInfo> get filteredApps => _filteredApps;

  String _normalize(String value) {
    return removeDiacritics(value)
        .toLowerCase()
        .replaceAll(RegExp(r'[^\p{L}\p{N}]', unicode: true), '');
  }

  void onSearch(String query) {
    if (query.trim().isEmpty) {
      _filteredApps = apps.toList();
    } else {
      _filteredApps = apps
          .where((e) => _normalize(e.name).contains(_normalize(query)))
          .toList();
    }
    notifyListeners();
  }

  Future<void> refresh() async {
    await getApps();
    onSearch("");
  }
}
