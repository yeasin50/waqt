import 'package:flutter/material.dart';

class AppTile extends StatelessWidget {
  const AppTile({
    super.key,
    required this.title,
    required this.onTap,
    this.onLongPress,
    this.titleAlign = .center,
    this.tralling,
    this.isSetting = false,
  });

  factory AppTile.setting({
    required String title,
    VoidCallback? onTap,
    Widget? tralling,
  }) {
    return AppTile(
      title: title,
      onTap: onTap,
      titleAlign: .start,
      tralling: tralling,
      isSetting: true,
    );
  }

  final String title;
  final TextAlign titleAlign;
  final VoidCallback? onTap, onLongPress;
  final Widget? tralling;

  final bool isSetting;

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
        style: isSetting ? style.bodyLarge : style.bodyLarge?.copyWith(),
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
                children: [
                  Expanded(child: titleWidget),
                  tralling!,
                ],
              ),
      ),
    );
  }
}
