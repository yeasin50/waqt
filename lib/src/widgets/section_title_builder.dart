import 'package:flutter/material.dart';

class SectionTitleBuilder extends StatelessWidget {
  const SectionTitleBuilder({super.key, required this.title, this.onClear});

  final String title;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(title),
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: onClear,
          color: Colors.grey,
        ),
      ],
    );
  }
}
