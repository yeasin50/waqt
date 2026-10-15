import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'app_visiblity.dart';

class AppVisiblityCreator extends ChangeNotifier {
  AppVisiblityMode _selectedMode = .weekly;
  AppVisiblityMode get selectedMode => _selectedMode;

  void changeMode(AppVisiblityMode mode) {
    _selectedMode = mode;
    notifyListeners();
  }

  Set<int> _selectedWeekDays = {};
  UnmodifiableSetView<int> get selectedWeekDays =>
      UnmodifiableSetView(_selectedWeekDays);

  void updateWeekDays(Set<int> data) {
    _selectedWeekDays = data;
    notifyListeners();
  }

  Set<int> _selectedMonthDays = {};
  UnmodifiableSetView<int> get selectedMonthDays =>
      UnmodifiableSetView(_selectedMonthDays);

  void updateMonthDays(Set<int> data) {
    _selectedMonthDays = data;
    notifyListeners();
  }

  /// each  bloc gonna represent in [dailyTime] with  [_dayBlocIntervavl] minutes
  int _dayBlocIntervavl = 60;

  int get numberOfDaySlot => 24;
  int get interval => _dayBlocIntervavl;

  final List<TimeOfDay> _dailyTime = [];
  UnmodifiableListView<TimeOfDay> get dailyTime =>
      UnmodifiableListView(_dailyTime);

  bool isTimeBlocTaken(TimeOfDay value) {
    return _dailyTime.any(
      (e) => value.hour == e.hour && value.minute == e.minute,
    );
  }

  void clearDayBlocs() {
    _dailyTime.clear();
    notifyListeners();
  }

  void toggleDayBloc(TimeOfDay value) {
    isTimeBlocTaken(value) ? _dailyTime.remove(value) : _dailyTime.add(value);

    notifyListeners();
  }

  AppVisiblityInfo toSaveModel(String pkgName) {
    return AppVisiblityInfo(
      packageName: pkgName,
      mode: selectedMode,
      weekDays: selectedMode == .weekly ? _selectedWeekDays.toList() : [],
      monthDays: selectedMode == .monthly ? _selectedMonthDays.toList() : [],
      dailyBlocksDurationInMin: interval,
      dailyblocks: dailyTime
          .map((e) => (e.hour * 60 + e.minute) ~/ interval)
          .toList(),
    );
  }
}
