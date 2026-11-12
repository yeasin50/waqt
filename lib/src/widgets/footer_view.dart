import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../core/core.dart' show AppProvider;
import '../debug_screen.dart';
import 'app_text_update_field.dart';

class FooterView extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final color = ColorScheme.of(context);
    final style = TextTheme.of(context);

    return ListenableBuilder(
      listenable: AppProvider.of(context).notifier,
      builder: (context, child) {
        final provider = AppProvider.of(context).notifier;
        final preference = provider.preference;

        return Column(
          crossAxisAlignment: .stretch,
          mainAxisSize: .min,
          spacing: 8,
          children: [
            if (provider.err.isNotEmpty)
              TextButton(
                onPressed: () {
                  provider.handleError();
                  Navigator.of(context).push(DebugScreen.route());
                },
                child: Text(
                  provider.err,
                  textAlign: .center,
                  style: style.bodyMedium?.copyWith(
                    color: color.error,
                    fontStyle: .italic,
                  ),
                ),
              ),

            if (!provider.isDefaultLauncher)
              ElevatedButton(
                onPressed: provider.requestDefaultLauncher,
                child: Text(
                  "Set Default & Stay Focused",
                  textAlign: .center,
                  style: style.bodyMedium?.copyWith(
                    color: color.tertiary,
                    fontStyle: .italic,
                  ),
                ),
              ),

            FooterMotoView(
              boldText: preference.footerLeft,
              normalText: preference.footerRight,
              alignment: [
                MainAxisAlignment.start,
                MainAxisAlignment.spaceBetween,
                MainAxisAlignment.end,
              ].elementAt(preference.footerRowAlingment + 1),
            ),
          ],
        );
      },
    );
  }
}

/// render footer left[boldText] and right text[normalText], where user can their preference for [alignment]
/// Default  [onChanged] is null for homepage,
class FooterMotoView extends StatefulWidget {
  const new({
    super.key,
    required this.boldText,
    required this.normalText,
    this.alignment = .spaceBetween,
    this.onChanged,
  });

  final MainAxisAlignment alignment;

  final String boldText;
  final String normalText;

  final Function(String text)? onChanged;

  @override
  State<FooterMotoView> createState() => _FooterMotoViewState();
}

class _FooterMotoViewState extends State<FooterMotoView> {
  bool get isEditable => widget.onChanged != null;

  ///  this [initialText] also determine whether it is left or right
  Future<void> onTap(String initialText) async {
    final result = await AppTextUpdateField.show(
      context: context,
      initalText: initialText,
      isBold: initialText == widget.boldText,
    );

    if (result == null) return;
    widget.onChanged!(result);
  }

  @override
  Widget build(BuildContext context) {
    final color = ColorScheme.of(context);
    final style = TextTheme.of(context);

    final boldStyle = style.titleMedium?.copyWith(
      letterSpacing: 2,
      color: color.onSurface,
    );
    final normalStyle = style.bodySmall?.copyWith(
      color: color.onSurfaceVariant,
    );

    return Row(
      mainAxisAlignment: widget.alignment,
      spacing: 12,
      children: [widget.boldText, widget.normalText].mapIndexed((i, e) {
        final text = Text(e, style: i == 0 ? boldStyle : normalStyle);

        return !isEditable
            ? text
            : InkWell(
                onTap: () => onTap(e),
                child: Padding(
                  padding: const .symmetric(vertical: 8),
                  child: text,
                ),
              );
      }).toList(),
    );
  }
}
