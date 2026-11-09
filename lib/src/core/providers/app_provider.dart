import 'package:flutter/material.dart';

import '../core.dart' show WaqtAppNotifier;

class AppProvider extends InheritedWidget {
  const AppProvider({super.key, required super.child, required this.notifier});

  final WaqtAppNotifier notifier;

  @Deprecated("use notifier instead")
  WaqtAppNotifier get service => notifier;

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

// Like to pass down single object
class InheritedProvider<T> extends InheritedWidget {
  const InheritedProvider({
    super.key,
    required super.child,
    required this.notifier,
  });

  final T notifier;

  static T of<T>(BuildContext context) {
    final InheritedProvider<T>? result = context
        .dependOnInheritedWidgetOfExactType<InheritedProvider<T>>();

    assert(result != null, 'No InheritedProvider<$T> found in context');
    return result!.notifier;
  }

  @override
  bool updateShouldNotify(InheritedProvider<T> oldWidget) {
    return notifier != oldWidget.notifier;
  }
}
