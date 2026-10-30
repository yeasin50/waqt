import 'package:flutter/material.dart';

import 'app_tile.dart';

/// All are [AppTile.setting]
class AppCheckboxTile extends StatelessWidget {
  const new({
    super.key,
    required this.title,
    required this.isChecked,
    required this.onTap,
  });

  final String title;
  final bool isChecked;
  final ValueChanged<bool> onTap;
  @override
  Widget build(BuildContext context) {
    return AppTile.setting(
      title: title,
      tralling: Flexible(
        child: Switch(value: isChecked, onChanged: onTap),
      ),
      onTap: () => onTap(!isChecked),
    );
  }
}
