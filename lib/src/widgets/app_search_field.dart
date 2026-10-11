import 'package:flutter/material.dart';

class AppSearchField extends StatefulWidget {
  const new({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final theme = Theme.of(context);
    final style = theme.textTheme;

    final isKeyboardOpened = MediaQuery.viewInsetsOf(context).bottom > 0;

    print("rebuild"); //TODO: check  why  3x rebuilds
    return Container(
      width: width,
      alignment: .center,
      height: 96 + 24,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: .topCenter,
          end: .bottomCenter,
          colors: [Colors.transparent, theme.scaffoldBackgroundColor],
        ),
      ),

      child: Padding(
        padding: const .all(24.0),
        child: AnimatedContainer(
          duration: Durations.short3,
          width: (isKeyboardOpened ? .85 : .45) * width,
          height: 48,
          decoration: ShapeDecoration(
            shape: StadiumBorder(),
            color: theme.colorScheme.primaryContainer,
          ),
          padding: .symmetric(horizontal: 12),
          child: Stack(
            children: [
              Positioned(
                left: 8,
                top: 12,
                child: const Icon(Icons.search, color: Colors.black87),
              ),
              Positioned(
                left: 24,
                right: 24,
                bottom: 0,
                top: 10,
                child: TextFormField(
                  cursorColor: Colors.grey,
                  cursorHeight: 22,
                  onChanged: widget.onChanged,
                  textAlign: .center,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: style.bodyLarge?.copyWith(color: Colors.black87),
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                  style: style.bodyLarge?.copyWith(color: Colors.black),
                  textAlignVertical: .center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
