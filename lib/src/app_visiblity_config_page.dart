import 'package:flutter/material.dart';

import 'core/core.dart' show AppInfo;
import 'widgets/daily_hour_selection_view.dart';
import 'widgets/monthday_selection_view.dart';
import 'widgets/weekday_selection_view.dart';

//TODO:  color map  per day*time for progress graph
enum AppVisiblityMode { daily(), weekly(), monthly() }

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
  AppVisiblityMode selectedMode = .weekly;

  Set<int> selectedWeekDays = {};
  Set<int> selectedDays = {};

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
        body: SingleChildScrollView(
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
                  selected: {selectedMode},
                  onSelectionChanged: (v) {
                    selectedMode = v.first;
                    setState(() {});
                  },
                  segments: AppVisiblityMode.values
                      .map((e) => ButtonSegment(value: e, label: Text(e.name)))
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
              if (selectedMode == .weekly)
                WeekDaySelectionView(
                  selectedDay: selectedWeekDays,
                  onChanged: (v) {
                    selectedWeekDays = v;
                    setState(() {});
                  },
                )
              else if (selectedMode == .monthly)
                MonthDaySelectionView(
                  selectedDays: selectedDays,
                  onChanged: (v) {
                    selectedDays = v;
                    setState(() {});
                  },
                ),

              DailyHourSelectionView(),
            ],
          ),
        ),
      ),
    );
  }
}
