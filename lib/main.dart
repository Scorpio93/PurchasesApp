import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:purchases/app.localization.dart';
import 'package:purchases/presentation/purchases_screen.dart';
import 'dependencies_container.dart' as dependenciesContainer;

void main() {
  dependenciesContainer.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PurchasesApp',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      supportedLocales: [Locale('en', 'EN'), Locale('ua', 'UA')],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: PurchasesScreen(),
    );
  }
}
