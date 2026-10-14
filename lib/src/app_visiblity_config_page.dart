import 'dart:collection';

import 'package:flutter/material.dart';

import 'core/core.dart' show AppInfo;
import 'widgets/daily_hour_selection_view.dart';
import 'widgets/monthday_selection_view.dart';
import 'widgets/weekday_selection_view.dart';

//TODO:  color map  per day*time for progress graph
enum AppVisiblityMode { daily(), weekly(), monthly() }

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

  List<(TimeOfDay start, TimeOfDay end)> _dailyTime = [];
  UnmodifiableListView<(TimeOfDay start, TimeOfDay end)> get dailyTime =>
      UnmodifiableListView(_dailyTime);

  void updateTimeOfDay(int index, TimeOfDay start, TimeOfDay end) {
    _dailyTime[index] = (start, end);
    print(_dailyTime[index]);
    notifyListeners();
  }
}

class AppVisiblityConfigPage extends StatefulWidget {
  const new({super.key, required this.appInfo});

  final AppInfo appInfo;

  static MaterialPageRoute route(AppInfo app) {
    return MaterialPageRoute(
      builder: (context) => AppVisiblityConfigPage(appInfo: app),
    );
  }

  @override
  State<AppVisiblityConfigPage> createState() => _AppVisiblityConfigPageState();
}

class _AppVisiblityConfigPageState extends State<AppVisiblityConfigPage> {
  final AppVisiblityCreator creator = AppVisiblityCreator();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Theme(
      data: Theme.of(context).copyWith(
        segmentedButtonTheme: SegmentedButtonThemeData(
          selectedIcon: SizedBox(),
          style: SegmentedButton.styleFrom(
            selectedForegroundColor: color.onPrimaryContainer,
            selectedBackgroundColor: color.primaryContainer,
            fixedSize: const Size(100, 40),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(),
        body: ListenableBuilder(
          listenable: creator,

          builder: (context, child) => SingleChildScrollView(
            padding: const .symmetric(horizontal: 24.0),
            child: Column(
              spacing: 12,
              crossAxisAlignment: .stretch,
              children: [
                Text("${widget.appInfo.name} visibility"),
                Align(
                  alignment: .centerLeft,
                  child: SegmentedButton<AppVisiblityMode>(
                    multiSelectionEnabled: false,
                    emptySelectionAllowed: true,
                    selected: {creator.selectedMode},
                    onSelectionChanged: (v) => creator.changeMode(v.first),
                    segments: AppVisiblityMode.values
                        .map(
                          (e) => ButtonSegment(value: e, label: Text(e.name)),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  height: 24,
                  child: Placeholder(child: Text("12 h of 24h")),
                ),

                SizedBox(height: 8),

                /// Week days
                if (creator.selectedMode == .weekly)
                  WeekDaySelectionView(
                    selectedDay: creator.selectedWeekDays,
                    onChanged: creator.updateWeekDays,
                  )
                else if (creator.selectedMode == .monthly)
                  MonthDaySelectionView(
                    selectedDays: creator.selectedMonthDays,
                    onChanged: (v) => creator.updateMonthDays(v),
                  ),

                DailyHourSelectionView(creator: creator),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
