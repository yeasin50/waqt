import 'package:flutter/material.dart';

class AppTile extends StatelessWidget {
  const AppTile({
    super.key,
    required this.title,
    required this.onTap,
    this.onLongPress,
    this.titleAlign = .center,
    this.tralling,
  });

  final String title;
  final TextAlign titleAlign;
  final VoidCallback? onTap, onLongPress;
  final Widget? tralling;

  @override
  Widget build(BuildContext context) {
    final style = TextTheme.of(context);

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const .symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: .center,
          spacing: 8,
          children: [
            Text(
              title,
              textAlign: titleAlign,
              style: style.bodyLarge?.copyWith(),
            ),
            ?tralling,
          ],
        ),
      ),
    );
  }
}
