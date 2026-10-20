import 'package:flutter/material.dart';

import '../core.dart' show AppNotifier;

class AppProvider extends InheritedWidget {
  const AppProvider({super.key, required super.child, required this.notifier});

  final AppNotifier notifier;

  @Deprecated("use notifier instead")
  AppNotifier get service => notifier;

  static AppProvider of(BuildContext context) {
    final AppProvider? result = maybeOf(context);
    assert(result != null, 'No AppProvider found in context');
    return result!;
  }

  static AppProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppProvider>();
  }

  @override
  bool updateShouldNotify(AppProvider oldWidget) =>
      notifier != oldWidget.notifier;
}
