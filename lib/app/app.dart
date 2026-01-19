import 'package:flutter/material.dart';
import 'package:fpt_ojt/app/router/app_router.dart';
import 'package:fpt_ojt/core/theme/app_theme.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    routerConfig: goRouter,
    title: 'Flutter Starter',
    themeMode: ThemeMode.light,
    theme: AppTheme.light(),
  );
}
