import 'dart:math';

import 'package:flutter/material.dart';

/// to update the footer text
class AppTextUpdateField extends StatefulWidget {
  const AppTextUpdateField._({required this.initalText, required this.isBold});

  final String initalText;
  final bool isBold;

  static Widget settingTile({
    required String title,
    required String text,
    required VoidCallback? onTap,
  }) {
    return _SettingTile(title: title, text: text, onTap: onTap);
  }

  static Future<String?> show({
    required BuildContext context,
    required String initalText,
    required bool isBold,
  }) async {
    return await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: .vertical(top: .circular(24)),
      ),
      builder: (context) {
        return AppTextUpdateField._(initalText: initalText, isBold: isBold);
      },
    );
  }

  @override
  State<AppTextUpdateField> createState() => _AppTextUpdateFieldState();
}

class _AppTextUpdateFieldState extends State<AppTextUpdateField> {
  late final TextEditingController controller = .fromValue(
    .new(text: widget.initalText),
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;

    final colors = theme.colorScheme;
    final viewPadding = MediaQuery.viewPaddingOf(context).bottom;
    final bottomPadding = MediaQuery.viewInsetsOf(context).bottom;

    TextStyle? textStyle = widget.isBold
        ? style.titleMedium?.copyWith(letterSpacing: 2, color: colors.onSurface)
        : style.bodySmall?.copyWith(color: colors.onSurfaceVariant);

    return AnimatedPadding(
      duration: .zero,
      padding: .only(bottom: max(viewPadding, bottomPadding)),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          Row(
            children: [
              CloseButton(),
              Text("update_footer"),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(controller.text);
                },
                child: Text("save"),
              ),
            ],
          ),
          Padding(
            padding: const .symmetric(horizontal: 12, vertical: 16),
            child: TextFormField(
              controller: controller,
              style: textStyle,
              maxLines: 4,
              minLines: 1,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const new({required this.title, required this.text, required this.onTap});

  final String title;
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final style = TextTheme.of(context);

    final titleWidget = Align(
      alignment: .centerLeft,
      child: Text(title, textAlign: .left, style: style.bodyLarge),
    );

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: .symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          spacing: 24,
          children: [titleWidget, Text(text)],
        ),
      ),
    );
  }
}
