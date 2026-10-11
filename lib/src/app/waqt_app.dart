import 'package:flutter/material.dart';

import '../home_page.dart';
import 'theme.dart';

class WaqtApp extends StatelessWidget {
  const WaqtApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Waqt',
      theme: AppTheme().baseTheme(context),
      home: HomeScreen(),
    );
  }
}
