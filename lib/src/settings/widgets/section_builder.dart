import 'package:flutter/material.dart';

/// A common  wrapper widget used for grouping [children].
/// if [onTap] is not null, it will only trigger around the [children] unless any of children consume the gesture;
class SectionBuilder extends StatelessWidget {
  const new({
    super.key,
    required this.label,
    required this.children,
    this.onTap,
  });

  final String label;
  final List<Widget> children;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Padding(
          padding: const .only(left: 16.0),
          child: Text(label, style: TextTheme.of(context).titleMedium),
        ),

        GestureDetector(
          onTap: onTap,
          child: Material(
            shape: RoundedRectangleBorder(borderRadius: .circular(9)),
            child: Padding(
              padding: const .symmetric(horizontal: 16.0, vertical: 8),
              child: Column(
                crossAxisAlignment: .stretch,
                spacing: 12,
                children: children,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
