import 'package:flutter/material.dart';

class SectionBuilder extends StatelessWidget {
  const new({super.key, required this.label, required this.children});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final color = ColorScheme.of(context);
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Padding(
          padding: const .only(left: 16.0),
          child: Text(label, style: TextTheme.of(context).titleMedium),
        ),
        Material(
          shape: RoundedRectangleBorder(borderRadius: .circular(9)),
          color: color.surfaceDim, //TODO: COLOR FIX
          child: Padding(
            padding: const .symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              crossAxisAlignment: .stretch,
              spacing: 12,
              children: children,
            ),
          ),
        ),
      ],
    );
  }
}
