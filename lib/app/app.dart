import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fpt_ojt/app/router/app_router.dart';
import 'package:fpt_ojt/core/theme/app_theme.dart';
import 'package:fpt_ojt/l10n/app_localizations.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });

    return MaterialApp.router(
      routerConfig: goRouter,
      title: 'Minstant',
      themeMode: ThemeMode.light,
      theme: AppTheme.light(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
    );
  }
}
