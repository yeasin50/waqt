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
