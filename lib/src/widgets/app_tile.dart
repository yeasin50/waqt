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

    final titleWidget = Align(
      alignment: titleAlign == .start || titleAlign == .left
          ? .centerLeft
          : .center,
      child: Text(
        title,
        textAlign: titleAlign,
        style: style.bodyLarge?.copyWith(),
      ),
    );
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const .symmetric(vertical: 12),
        child: tralling == null
            ? titleWidget
            : Row(
                mainAxisAlignment: .spaceBetween,
                spacing: 24,
                children: [titleWidget, tralling!],
              ),
      ),
    );
  }
}
