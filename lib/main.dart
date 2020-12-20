import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kul_last/splash.dart';
import 'package:kul_last/viewModel/companies.dart';
import 'package:kul_last/viewModel/sections.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

main(List<String> args) {
  Provider.debugCheckInvalidValueType = null;
  runApp(MaterialApp(
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
      )));
}
