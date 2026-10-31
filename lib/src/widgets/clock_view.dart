import 'package:flutter/material.dart';

import 'dart:async';

class ClockView extends StatefulWidget {
  const new({super.key});

  @override
  State<ClockView> createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  late DateTime now;
  late final Timer timer;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => now = DateTime.now());
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String get time {
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    return '${hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';
  }

  String get date {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${days[now.weekday - 1]}, '
        '${now.day} ${months[now.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final style = TextTheme.of(context);

    return Column(
      crossAxisAlignment: .stretch,
      mainAxisSize: .min,
      children: [
        Text(time, style: style.headlineLarge),

        const SizedBox(height: 8),

        Text(
          date,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white.withValues(alpha: 0.55),
          ),
        ),
      ],
    );
  }
}
