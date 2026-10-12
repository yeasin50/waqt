import 'package:flutter/material.dart';

import 'src/app/waqt_app.dart';

import './src/core/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.init();

  runApp(const WaqtApp());
}
