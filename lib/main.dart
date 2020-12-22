import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kul_last/splash.dart';
import 'package:kul_last/viewModel/companies.dart';
import 'package:kul_last/viewModel/sections.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

main(List<String> args) async {
  // if your flutter > 1.7.8 :  ensure flutter activated
  WidgetsFlutterBinding.ensureInitialized();

  await translator.init(
    localeDefault: LocalizationDefaultType.device,
    languagesList: <String>['ar', 'en'],
    assetsDirectory: 'assets/langs/',
    apiKeyGoogle: '<Key>', // NOT YET TESTED
  ); // intialize
  Provider.debugCheckInvalidValueType = null;
  runApp(
    LocalizedApp(
      child: MaterialApp(
        title: 'ككل',
        theme: ThemeData(fontFamily: 'jareda'),
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => SectionProvider(),
              lazy: true,
            ),
            ChangeNotifierProvider(
              create: (context) => CompanyProvider(),
            ),
          ],
          child: Splash(),
        ),
        localizationsDelegates: translator.delegates,
        locale: translator.locale,
        supportedLocales: translator.locals(),
      ),
    ),
  );
}
