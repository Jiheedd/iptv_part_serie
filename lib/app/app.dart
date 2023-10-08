import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../presentation/resources/routes_manager.dart';
import '../presentation/resources/theme_manager.dart';


class MyApp extends StatefulWidget {
  // named constructor
  MyApp._internal();

  int appState = 0;

  static final MyApp _instance =
      MyApp._internal(); // singleton or single instance

  factory MyApp() => _instance; // factory

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(
          LogicalKeyboardKey.select,
          LogicalKeyboardKey.arrowRight,
          LogicalKeyboardKey.arrowLeft,
          LogicalKeyboardKey.arrowDown,
        ): const ActivateIntent(),
      },
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteGenerator.getRoute,
        // initialRoute: isLoggedIn ? Routes.splashChoice : Routes.loginRoute,
        initialRoute: Routes.seriesRoute,

        theme: getApplicationTheme(),
      ),
    );
  }
}

