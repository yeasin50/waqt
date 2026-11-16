// Waqt - Minimal Android Home Launcher
// Copyright (C) 2026 Md. Yeasin Sheikh
// Licensed under GNU AGPLv3. See LICENSE file for details.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/app/waqt_app.dart';
import './src/core/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await AppDatabase.init();

  runApp(const WaqtApp());
}
