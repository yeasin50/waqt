enum AppVisiblityMode { daily(), weekly(), monthly() }

class AppVisiblityInfo {
  const AppVisiblityInfo({
    required this.packageName,
    required this.mode,
    required this.weekDays,
    required this.monthDays,
    required this.dailyBlocksDurationInMin,
    required this.dailyblocks,
  });

  final String packageName;

  final AppVisiblityMode mode;

  final List<int> weekDays;
  final List<int> monthDays;

  final int dailyBlocksDurationInMin;
  final List<int> dailyblocks;
}
