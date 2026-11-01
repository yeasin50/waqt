import 'package:flutter/material.dart';

import '../core/core.dart';

class AppSearchField extends StatefulWidget {
  const AppSearchField({
    super.key,
    required this.controller,
    this.autoFocus = false,
  });

  final TextEditingController controller;

  final bool autoFocus;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  final FocusNode focusNode = FocusNode();

  late PageController pageContoller = InheritedProvider.of<PageController>(
    context,
  );

  void pageListener() {
    assert(widget.autoFocus);

    //TODO: test on release +  check dragEnd and then show
    if (!focusNode.hasFocus && pageContoller.page! > .7) {
      focusNode.requestFocus();
    }
  }

  @override
  void initState() {
    super.initState();
    if (!widget.autoFocus) return;

    // can we we work  with NotificationListener instead
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageContoller.addListener(pageListener);
    });
  }

  late double width = width = MediaQuery.sizeOf(context).width;

  bool isKeyboardOpened = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    width = MediaQuery.sizeOf(context).width;

    final opened = MediaQuery.viewInsetsOf(context).bottom > 0;
    if (isKeyboardOpened != opened) isKeyboardOpened = opened;
    if (focusNode.hasFocus && !isKeyboardOpened) focusNode.unfocus();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme;

    print("rebuild"); //TODO: check  why  3x rebuilds
    return AnimatedPadding(
      duration: .zero,
      padding: .only(bottom: MediaQuery.viewInsetsOf(context).bottom + 24),
      child: GestureDetector(
        onTap: () {
          final primaryFocus = FocusManager.instance.primaryFocus;
          if (primaryFocus == null) return;

          focusNode.hasFocus
              ? primaryFocus.unfocus()
              : primaryFocus.requestFocus(focusNode);
        },
        child: Container(
          //TODO:  can merge ig
          width: width,
          alignment: .center,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: .topCenter,
              end: .bottomCenter,
              colors: [Colors.transparent, theme.scaffoldBackgroundColor],
            ),
          ),
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
                  top: 10,
                  height: 64,
                  child: TextFormField(
                    controller: widget.controller,
                    focusNode: focusNode,
                    cursorColor: Colors.grey,
                    cursorHeight: 22,
                    textAlign: .center,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: style.bodyLarge?.copyWith(
                        color: Colors.black87,
                      ),
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
      ),
    );
  }
}
