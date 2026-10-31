import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../widgets/app_checkbox_tile.dart';
import '../../widgets/app_tile.dart';
import 'section_builder.dart';

class LockPermissionTile extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context).notifier;
    return ListenableBuilder(
      listenable: provider,
      builder: (context, child) {
        final bool hasLockPermission = provider.hasLockPermission;

        return SectionBuilder(
          label: "Double-Tap Lock",
          children: [
            if (!hasLockPermission)
              AppTile.setting(
                title: "Grant permission",
                onTap: provider.requestLockPermission,
              ),

            AppCheckboxTile(
              title: "Enable",
              isChecked: provider.preference.enableDoubleTapLock,
              onTap: !provider.hasLockPermission
                  ? null
                  : provider.toggleDoubleTapLoc,
            ),
          ],
        );
      },
    );
  }
}
