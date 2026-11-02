import 'package:flutter/material.dart';

import 'app_tile.dart';

/// All are [AppTile.setting]
class AppSegmentedButtonTile<T> extends StatelessWidget {
  const new({
    super.key,
    required this.title,
    required this.selectedValue,
    required this.items,
    required this.onTap,
  });

  final String title;
  final T selectedValue;
  final List<T> items;
  final ValueChanged<T>? onTap;

  @override
  Widget build(BuildContext context) {
    assert(T is! int || T is! String);

    final style = TextTheme.of(context);

    return Row(
      spacing: 8,
      mainAxisAlignment: .spaceBetween,
      children: [
        Align(
          alignment: .topLeft,
          child: Text(title, style: style.bodyLarge),
        ),

        SegmentedButton<T>(
          segments: <ButtonSegment<T>>[
            for (final b in items)
              ButtonSegment<T>(value: b, label: Text(b.toString())),
          ],
          selected: <T>{selectedValue},
          onSelectionChanged: onTap == null
              ? null
              : (seletectItems) => onTap!(seletectItems.first),
          selectedIcon: SizedBox.shrink(),
        ),
      ],
    );
  }
}
