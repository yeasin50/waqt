import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../widgets/app_checkbox_tile.dart';
import '../../widgets/app_tile.dart';

class LockPermissionTile extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context).notifier;
    return ListenableBuilder(
      listenable: provider,
      builder: (context, child) {
        final bool hasLockPermission = provider.hasLockPermission;

        return Material(
          shape: RoundedRectangleBorder(borderRadius: .circular(9)),
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: 8,
            children: [
              Text("Double tap lock screen"),
              if (!hasLockPermission)
                AppTile.setting(
                  title: "Double tap lock permission",
                  onTap: provider.requestLockPermission,
                ),

              if (hasLockPermission)
                AppCheckboxTile(
                  title: "double tap lock screen",
                  isChecked: provider.preference.enableDoubleTapLock,
                  onTap: provider.toggleDoubleTapLoc,
                ),
            ],
          ),
        );
      },
    );
  }
}
