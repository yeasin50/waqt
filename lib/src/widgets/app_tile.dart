import 'package:flutter/material.dart';

class AppTile extends StatelessWidget {
  const AppTile({
    super.key,
    required this.title,
    required this.onTap,
    this.onLongPress,
    this.titleAlign = .center,
  });

  final String title;
  final TextAlign titleAlign;
  final VoidCallback? onTap, onLongPress;

  @override
  Widget build(BuildContext context) {
    final style = TextTheme.of(context);

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const .symmetric(vertical: 12),
        child: Text(
          title,
          textAlign: titleAlign,
          style: style.bodyLarge?.copyWith(),
        ),
      ),
    );
  }
}
