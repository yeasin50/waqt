import 'package:flutter/material.dart';

class FooterView extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'waqt',
          style: TextStyle(
            fontSize: 17,
            letterSpacing: 2,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
        Text(
          'Everything, in its time.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }
}
